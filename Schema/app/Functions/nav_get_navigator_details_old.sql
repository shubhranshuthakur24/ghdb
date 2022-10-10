CREATE OR REPLACE FUNCTION app.nav_get_navigator_details_old(user_id integer)
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
		u.bio as cg_mantra,
		ng.meeting_url,
		u.profile_pic_url as ng_profile_pic,
		u.first_name as ng_first_name,
		u.last_name as ng_last_name,
		u.phone as contact_detail,
		u.firebase_userid,
		u.email,
		u.ethnicityid, 
		u.zipcode,
		u.user_dob,
		u.user_genderid,
		u.ethnicityid,
		coalesce( u.last_name,'') as cg_last_name,
		coalesce( u.bio,'')as cg_mantra,
		(select count(un.user_notificationid) from app.user_notification un where un.userid = user_id) as notification_count,
		(select
			coalesce( array_to_json( array_agg( row_to_json(cgd)) ), '[]' ) as cg_detail
		 from
			(select 
		cg.care_giverid,
		u.userid as cg_userid,
		u.profile_pic_url as cg_profile_pic,
		u.first_name as cg_first_name,
		u.last_name as cg_last_name,
--		(select array_agg(e.name) as ethnicity from unnest(u.ethnicityid) id 
--			join meta.ethnicity e 
--			on id.id = e.ethnicityid),
		u.ethnicityid, 
		u.firebase_userid
		from
			app.care_giver cg
		join
		app.navigator n on cg.navigatorid = n.navigatorid 
		join
    	app.users u on u.userid = cg.userid
    	where cg.navigatorid = ng.navigatorid order by u.last_name)cgd) as cg_details,
		
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
					n.userid = user_id  and a.availability_date=date(NOW())
					order by s.slot_start_time )nm) as nav_meetings,
		 (select
			coalesce( array_to_json( array_agg( row_to_json(dd)) ), '[]' ) as tasks
		 from
			(select nt.todo_list_info,
					nt.nav_todoid,
					nt.completion_date,
					nt.assign_to,
					nt.is_done
			from 
				app.nav_todo nt
			where nt.userid = user_id
			and is_archive = false order by nt.nav_todoid asc limit 3) dd ) as tasks
	 from  
	 	app.navigator ng
    join
    	app.users u on u.userid = ng.userid
    where ng.userid = user_id) t;
	
end;
$function$
;
