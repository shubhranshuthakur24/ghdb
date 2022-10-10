CREATE OR REPLACE FUNCTION app.cg_get_caregiver_details(user_id integer)
 RETURNS TABLE(care_giver_data json)
 LANGUAGE plpgsql
AS $function$
declare
	cg_id int := (select care_giverid from app.care_giver where userid=user_id);
	nav_id int := (select navigatorid from app.care_giver where userid = user_id);
--languageid slot_start new_slot_time
begin
	return QUERY 
		select
	row_to_json(t) as care_giver_data
from
	(select 
		cg.care_giverid,
		u.timezoneid,
		cg.is_archive,
		tz.abbreviation as timezone_name,
		tz.offset_from_utc,
		u.userid,
		lo.first_name as loved_one_name,
		u.bio as cg_mantra,
		u.profile_pic_url as cg_profile_pic,
		u.first_name as cg_first_name,
		u.last_name as cg_last_name,
		u.firebase_userid,
		u.user_genderid as genderid,
--		coalesce(u.phone) as cg_phone_number,
		u.phone ,
		
		(select array_agg(e.name) as ethnicity from unnest(u.ethnicityid) id 
			join meta.ethnicity e 
			on id.id = e.ethnicityid),
		u.ethnicityid, 
		coalesce( u.last_name,'') as cg_last_name,
		coalesce( u.bio,'')as cg_mantra,
		(select count(un.user_notificationid) from app.user_notification un where un.userid = user_id and un.is_archive = false) as notification_count,
		(select count(un.red_flag) from app.user_notification un where un.userid = user_id and is_archive = false and red_flag = true) as unread_notification_count,
		(select row_to_json(nd) as navigator_data
		from
			(select n.navigatorid,
			u1.timezoneid,
			tz2.offset_from_utc,
			n.meeting_url,
			(select array_agg(e.name) as ethnicity from unnest(u.ethnicityid) id 
				join meta.ethnicity e 
				on id.id = e.ethnicityid),
			u.ethnicityid,
			u.email as nav_email,
            u1.profile_pic_url as nav_profile_pic,
            u1.userid as nav_userid,
            u1.firebase_userid as nav_firebaseid,
            u1.first_name as nav_first_name,
            u1.last_name as nav_last_name,
            u1.firebase_userid,
            u1.user_genderid as genderid,
            gud.state,
            gud.city,
            m.meetingid,
            mt.meeting_type_name,
            a.availability_date,
            s.slotid,
--			(select a.availability_date  + s.slot_start_time::time - interval '6 hours' ) as cst_datetime,
--			(select a.availability_date  + s.slot_start_time::time - interval '5 hours' ) as est_datetime,
--			(select a.availability_date  + s.slot_start_time::time - interval '8 hours' ) as pst_datetime,
            s.slot_start_time,
            s.slot_end_time,
            ud.device_notification_token
            
            from
                app.navigator n
            
            left join app.users u1
                on u1.userid = n.userid 
              left join 
    	meta.timezone tz2 on
    	tz2.timezoneid = u1.timezoneid
--            left join app.care_giver cg
--                on cg.navigatorid = n.navigatorid
            left join meta.geo_us_data gud
                on gud.zipcode = u.zipcode
            left join app.meeting m 
                on m.care_giverid = cg_id and m.is_archive = false 
                and m.navigatorid = nav_id
            left join meta.meeting_type mt 
                on mt.meeting_typeid = m.meeting_typeid
            left join meta.slot s 
                on s.slotid = m.slotid
            left join app.nav_availability a 
                on a.nav_availabilityid = m.nav_availabilityid and a.navigatorid = nav_id
			--	and a.availability_date >= current_timestamp
			left join app.user_device ud
	    		on ud.userid = n.userid 
	    		and ud.device_channelid in (1,2) 
	    		and ud.device_notification_token notnull
	    		and ud.updated_at notnull
            where
--                cg.userid = user_id
					n.navigatorid = nav_id 
                order by a.availability_date desc, s.slotid, ud.updated_at DESC  
                limit 1
                )nd) as navigator_data,
		 (select
			coalesce( array_to_json( array_agg( row_to_json(dd)) ), '[]' ) as tasks
		 from
			(select nt.task_info,
                nt.taskid,
                nt.task_completion_datetime,
                nt.assign_to,
                nt.is_done
			from 
				app.task nt
				where (nt.assign_to = user_id or nt.userid= user_id )
		and nt.is_archive = false order by nt.is_done asc,nt.taskid desc limit 3) dd ) as tasks,
		
			
			
			(select
			coalesce( array_to_json( array_agg( row_to_json(ctm)) ), '[]' ) as care_team_member
		 from
			(
			select ctm.ctm_id ,ctm.team_id ,ctm."name", u.userid from app.care_giver cg 
		left join app.care_team ct 
		on ct.care_giverid = cg.care_giverid 
		join app.care_team_member ctm 
		on ctm.team_id = ct.team_id 
		join app.users u on ctm.userid = u.userid
		where cg.userid = user_id
			) ctm ) as care_team_member
			
			
			
	 from  
	 	app.care_giver cg
	
	left join 
    	app.loved_one lo on lo.care_giverid = cg.care_giverid
    left join
    	app.users u on u.userid = cg.userid
    	left join 
    	meta.timezone tz on tz.timezoneid = u.timezoneid
    where cg.userid = user_id) t;
	
end;
$function$
;
