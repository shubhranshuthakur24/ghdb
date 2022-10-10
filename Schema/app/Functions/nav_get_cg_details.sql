CREATE OR REPLACE FUNCTION app.nav_get_cg_details(user_id integer, cg_id integer, cg_note text)
 RETURNS TABLE(care_giver_data json)
 LANGUAGE plpgsql
AS $function$
begin
	return QUERY 
		select
	row_to_json(t) as care_giver_data
from
	(select lo.first_name as lo_first_name,
		lo.last_name as lo_last_name,
		lo.profile_pic_url as lo_profile_pic,
		lo.ethnicityid,
		(select array_agg(e.name) as ethnicity from unnest(lo.ethnicityid) id 
			join meta.ethnicity e 
			on id.id = e.ethnicityid) as ethnicity,
		lo.genderid as lo_genderid,
		u.firebase_userid cg_firebase_id,
		u.first_name as cg_first_name,
		u.last_name as cg_last_name,
		u.profile_pic_url as cg_profile_pic,
		u.phone as contact,
		u.userid as cg_userid,
		u.user_genderid as cg_genderid,
		gud.state as cg_state,
		gud.city as cg_city,
		array_length(assigned_resource, 1) as resources,
		count(t.task_info) as tasks,
		(select count(nt2.task_info) from app.task nt2 
		where nt2.assign_to = user_id and nt2.userid =u.userid 
		and nt2.is_archive = false and nt2.is_done=false  
		) as pending_tasks,
		(select count (m.meetingid) from app.meeting m where is_archive = false and care_giverid = cg_id) as upcoming_meetings,
		cg.notes,
		cg.assessment_status
		from app.care_giver cg
		inner join app.users u 
			on u.userid = cg.userid
		left join meta.geo_us_data gud
			on gud.zipcode = u.zipcode
		inner join app.loved_one lo
		 	on lo.care_giverid = cg.care_giverid 
		 left join app.task t 
		 	on t.userid = cg.userid and t.is_done = false
		 left join app.meeting m 
		 	on m.care_giverid = cg.care_giverid -- and m.is_archive = false
		where cg.care_giverid = cg_id
		group by lo.first_name, lo.last_name, lo.profile_pic_url, lo.ethnicityid,ethnicity,lo.genderid, 
			u.first_name, u.last_name, u.profile_pic_url, 
			u.phone,u.userid,u.user_genderid ,
			gud.state, gud.city, 
			cg.assigned_resource,cg.notes,
			cg.assessment_status 
	) t;


		update app.care_giver 
		   set notes = coalesce(cg_note, notes)
		   where care_giverid = cg_id;



end;
$function$
;
