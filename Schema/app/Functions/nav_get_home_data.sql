CREATE OR REPLACE FUNCTION app.nav_get_home_data(user_id integer)
 RETURNS TABLE(home_data json)
 LANGUAGE plpgsql
AS $function$
declare
nav_id int := (select navigatorid from app.navigator where userid = user_id);
begin
	return QUERY 
		select row_to_json(d) 
	from 
		(select nav_id as nav_id,
		(select array_to_json(array_agg(row_to_json(t))) as cg_data
		from( select cg.care_giverid,
				u.profile_pic_url as cg_profile_pic,
				u.first_name as cg_first_name,
				u.last_name as cg_last_name,
				u.email,
				u.phone,
				u.firebase_userid
				from  
				 	app.care_giver cg
			    join
			    	app.navigator n on n.navigatorid = cg.navigatorid
			    join 
			    	app.users u on cg.userid = u.userid 
			    where n.userid = user_id)t),
				(select array_to_json(array_agg(row_to_json(td))) as nav_todo_data
				from(select
					tl.nav_todoid,
					tl.todo_list_info,
					tl.is_done
				from app.nav_todo tl
				where tl.userid = user_id)td),
				( select array_to_json(array_agg(row_to_json(ad))) as appointments
				from(select 
					m.meetingid,
					mt.meeting_type_name,
					m.slotid,
					s.slot_start_time,
					s.slot_end_time,
					m.care_giverid,
					(select row_to_json(cgd) as care_giver_data
					from (select 
						u1.first_name,
						u1.last_name,
						u1.profile_pic_url,
						u1.firebase_userid
						from app.users u1
						join app.care_giver cg2 on cg2.userid=u1.userid
						where cg2.care_giverid=m.care_giverid)cgd)
					from
					app.meeting m 
					join meta.meeting_type mt on mt.meeting_typeid = m.meeting_typeid 
					join app.care_giver cg on cg.care_giverid = m.care_giverid 
					join app.navigator n on n.navigatorid = m.navigatorid 
					join app.nav_availability a on a.nav_availabilityid = m.nav_availabilityid 
					join meta.slot s on s.slotid = m.slotid 
					where m.navigatorid = nav_id and a.availability_date = current_date)ad 
				))d;

end;
$function$
;
