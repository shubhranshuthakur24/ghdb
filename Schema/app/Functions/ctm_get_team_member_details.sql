CREATE OR REPLACE FUNCTION app.ctm_get_team_member_details(user_id integer)
 RETURNS TABLE(care_giver_data json)
 LANGUAGE plpgsql
AS $function$
declare
--	cg_id int := (select care_giverid from app.care_giver where userid=user_id);
--	nav_id int := (select navigatorid from app.care_giver where userid = user_id);
	teamid int := (select team_id from app.care_team_member where userid = user_id);
begin
	return QUERY 
	select
	row_to_json(t) as care_team_data
from
	(select 
		ctm2.ctm_id,
		ctm2.team_id,
		u.timezoneid,
--		cg.is_archive,
--		tz.offset_from_utc,
		u.userid,
		lo.first_name as loved_one_name,
		u.bio as cg_mantra,
		u.profile_pic_url as ctm_profile_pic,
		u.first_name as ctm_first_name,
		u.last_name as ctm_last_name,
		u.firebase_userid,
		u.lang_id as language_id,
		(select array_agg(l.name)as language_name from unnest(u.lang_id::int[]) id 
		 join meta.language l 
		on id.id = l.languageid ),
		u.user_genderid as genderid,
		(select array_agg(e.name) as ethnicity from unnest(u.ethnicityid) id 
			join meta.ethnicity e 
			on id.id = e.ethnicityid),
		u.ethnicityid, 
		coalesce( u.last_name,'') as ctm_last_name,
		coalesce( u.bio,'')as ctm_mantra,
		(select count(un.user_notificationid) from app.user_notification un where un.userid = user_id and un.is_archive = false) as notification_count,
		(select count(un.red_flag) from app.user_notification un where un.userid = user_id and is_archive = false and red_flag = true) as unread_notification_count,
		(select row_to_json(nd) as navigator_data
		from
			(select n.navigatorid,
			u.timezoneid,
			tz2.offset_from_utc,
			n.meeting_url,
			(select array_agg(e.name) as ethnicity from unnest(u.ethnicityid) id 
				join meta.ethnicity e 
				on id.id = e.ethnicityid),
			u.ethnicityid,
			u.email as nav_email,
            u.profile_pic_url as nav_profile_pic,
            u.userid as nav_userid,
            u.firebase_userid as nav_firebaseid,
            u.first_name as nav_first_name,
            u.last_name as nav_last_name,
            u.firebase_userid,
            u.user_genderid as genderid,
            gud.state,
            gud.city,
            m.meetingid,
            mt.meeting_type_name,
            a.availability_date,
            s.slot_start_time,
            ud.device_notification_token
            from
                app.navigator n
            left join 
    		meta.timezone tz2 on tz2.timezoneid = u.timezoneid
            left join app.users u
                on n.userid = u.userid 
--            left join app.care_giver cg
--                on cg.navigatorid = n.navigatorid
            left join meta.geo_us_data gud
                on gud.zipcode = u.zipcode
            left join app.meeting m 
                on m.care_giverid = cg.care_giverid  and m.is_archive = false 
                and m.navigatorid = cg.navigatorid 
            left join meta.meeting_type mt 
                on mt.meeting_typeid = m.meeting_typeid
            left join meta.slot s 
                on s.slotid = m.slotid
            left join app.nav_availability a 
                on a.nav_availabilityid = m.nav_availabilityid and a.navigatorid = cg.navigatorid 
				and a.availability_date >= current_timestamp
			left join app.user_device ud
	    		on ud.userid = n.userid 
	    		and ud.device_channelid in (1,2) 
	    		and ud.device_notification_token notnull
	    		and ud.updated_at notnull
            where
--                cg.userid = user_id
					n.navigatorid = cg.navigatorid  
                order by a.availability_date, s.slotid, ud.updated_at DESC  
                limit 1
                )nd) as navigator_data,
		 (select
			coalesce( array_to_json( array_agg( row_to_json(dd)) ), '[]' ) as tasks
		 from
			(select t.task_info,
                t.taskid,
                t.task_completion_datetime,
                t.assign_to,
                t.is_done
			from 
				app.task t
--			left join app.care_giver cg1 on cg1.care_giverid = c.care_giverid
			where t.userid  = user_id
			and t.is_archive = false order by t.is_done asc limit 3) dd ) as tasks,
			
			
			(select
			coalesce( array_to_json( array_agg( row_to_json(cd)) ), '[]' ) as primary_cg_detail
		 from
			(select cg.care_giverid ,u.userid ,u.first_name ,u.last_name
			from app.care_team_member ctm
			left join app.care_team ct
			on ctm.team_id = ct.team_id
			left join app.care_giver cg 
			on ct.care_giverid = cg.care_giverid 
			left join app.users u 
			on cg.userid = u.userid 
			where ctm.userid = user_id
			) cd ) as primary_cg_detail,
			
		(select
			coalesce( array_to_json( array_agg( row_to_json(ctm)) ), '[]' ) as care_team_member
		 from
			(select ctm.name,ctm.ctm_id,ctm.userid
			from app.care_team_member ctm
			where ctm.team_id =teamid
			
			) ctm ) as care_team_member
			
	 from  
	 	app.care_team_member ctm2  
--	left join 
--    	meta.timezone tz on tz.timezoneid = cg.timezoneid
	
    left join
    	app.users u on ctm2.userid  = u.userid
    	left join 
    	app.care_team ct on ctm2.team_id = ct.team_id 
    	left join 
    	app.care_giver cg on ct.care_giverid = cg.care_giverid 
    	left join 
    	app.loved_one lo on cg.care_giverid = lo.care_giverid
    where ctm2.userid = user_id) t;
--   1433
	
end;
$function$
;
