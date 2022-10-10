CREATE OR REPLACE FUNCTION app.nav_get_navigator_details(user_id integer)
 RETURNS TABLE(navigator_data json)
 LANGUAGE plpgsql
AS $function$
begin
	return QUERY 
		select
	row_to_json(t) as navigator_data
from
	(select 
		ng.navigatorid ,
		ng.bio,
		u.userid,
		ng.meeting_url,
		tz1.offset_from_utc,
		u.profile_pic_url as ng_profile_pic,
		u.first_name as ng_first_name,
		u.last_name as ng_last_name,
		u.phone as contact_detail,
		u.firebase_userid,
		u.email, 
		u.zipcode,
		u.user_dob,
		u.user_genderid,
		u.ethnicityid,
		
		(select count(un.user_notificationid) from app.user_notification un where un.userid = user_id and is_archive = false) as notification_count,
		(select count(un.red_flag) from app.user_notification un where un.userid = user_id and is_archive = false and red_flag = true) as unread_notification_count,
		(select
			coalesce( array_to_json( array_agg( row_to_json(cgd)) ), '[]' ) as cg_detail
		 from
			(select 
		cg.care_giverid,
		tz2.offset_from_utc,
		u.userid as cg_userid,
		u.profile_pic_url as cg_profile_pic,
		u.first_name as cg_first_name,
		u.last_name as cg_last_name,
		(select array_agg(e.name) as ethnicity from unnest(u.ethnicityid) id 
			join meta.ethnicity e 
			on id.id = e.ethnicityid),
		u.ethnicityid, 
		(select device_notification_token 
		from app.user_device ud
		where ud.userid = cg.userid order by ud.updated_at desc limit 1),
		u.firebase_userid
--		ud.device_notification_token
		from
			app.care_giver cg
		join
		app.navigator n on cg.navigatorid = n.navigatorid 
		
		join
    	app.users u on u.userid = cg.userid
    	join 
    			meta.timezone tz2 on tz2.timezoneid = u.timezoneid
--    	left join app.user_device ud
--    		on ud.userid = u.userid 
--    		and ud.device_channelid in (1,2) 
--    		and ud.device_notification_token notnull
--    		and ud.updated_at notnull
    	where cg.navigatorid = ng.navigatorid and ((cg.is_archive = false) or (cg.is_archive = null))
    	order by u.last_name)cgd) as cg_details,
		
		(select
			coalesce( array_to_json( array_agg( row_to_json(nm)) ), '[]' ) as nav_meetings
		 from
			(
			select n.navigatorid,
				n.meeting_url,
				u.profile_pic_url as cg_profile_pic,
				u.userid as cg_userid,
				cg.care_giverid,
				u.firebase_userid as cg_firebaseid,
				u.first_name as cg_first_name,
				u.last_name as cg_last_name,
				u.firebase_userid,
				u.user_genderid ,
				gud.state,
				gud.city,
				m.meetingid,
				mt.meeting_type_name,
				a.availability_date,
				a.nav_availabilityid ,
				s.slot_start_time
				from
					app.navigator n
				join app.care_giver cg
					on cg.navigatorid = n.navigatorid
					
				join app.users u
					on u.userid = cg.userid 	
				left join meta.geo_us_data gud
					on gud.zipcode = u.zipcode
				left join app.meeting m 
					on cg.care_giverid  = m.care_giverid  	and m.is_archive = false
				left join meta.meeting_type mt 
					on mt.meeting_typeid = m.meeting_typeid
				left join meta.slot s 
					on s.slotid = m.slotid
				left join app.nav_availability a 
					on a.nav_availabilityid = m.nav_availabilityid
					where
					n.userid = user_id   and a.availability_date>=date(NOW()) and ((cg.is_archive = false) or (cg.is_archive = null))
--					and to_timestamp((select s2.slot_start_time from app.meeting m2 
--			  					 left join meta.slot s2
--			  					 on s2.slotid = m2.slotid
--			  					 left join app.nav_availability na2 
--			  					 on na2.nav_availabilityid = m2.nav_availabilityid where na2.availability_date = date(NOW())), 'hh12:mi:PM')::time >= current_time
					order by a.availability_date asc, s.slotid asc  limit 5)nm) as nav_meetings,
		 (select
			coalesce( array_to_json( array_agg( row_to_json(dd)) ), '[]' ) as tasks
		 from
			(select nt.todo_list_info,
					nt.nav_todoid,
					nt.completion_date,
					nt.is_done
			from 
				app.nav_todo nt
			where nt.userid = user_id
			and is_archive = false order by nt.nav_todoid asc limit 3) dd ) as tasks
	 from  
	 	app.navigator ng
	 
    join
    	app.users u on u.userid = ng.userid
    	left join 
    			meta.timezone tz1 on tz1.timezoneid = u.timezoneid
    where ng.userid = user_id) t;
	
end;
$function$
;
