CREATE OR REPLACE FUNCTION app.nav_update_loved_one_info(user_id integer, cg_id integer, cg_note text)
 RETURNS TABLE(loved_one_data json)
 LANGUAGE plpgsql
AS $function$
begin
	return QUERY 
		select
	row_to_json(t) as loved_one_data
from
	(select lo.first_name as lo_first_name,
		lo.last_name as lo_last_name,
		lo.profile_pic_url as lo_profile_pic,
		lo.dob as lo_dob,
		(select array_agg(row_to_json(dt)) as disease_data from(
		select
			d.diseaseid,
			d.disease_name
		from
			meta.disease d 
		where
			diseaseid in (
			select
				jsonb_array_elements(lo.diseaseid)::int as disease_id
			from
				app.loved_one lo
			where
				lo.care_giverid = cg_id)) dt),
		lo.medicare_advantage,
		lo.health_insurance,
		lo.primary_care_physician,
		lo.hospital,
		lo.pharmacy,
		lo.medication,
		lo.medicaid,
		cg.notes,
		gud.state as cg_state,
		gud.city as cg_city
		from app.care_giver cg
		inner join app.users u 
			on u.userid = cg.userid
		left join meta.geo_us_data gud
			on gud.zipcode = u.zipcode
		inner join app.loved_one lo
		 	on lo.care_giverid = cg.care_giverid
		left join meta.disease d 
			on d.diseaseid = lo.diseaseid::int
		where cg.care_giverid = cg_id
		and cg.navigatorid = (select navigatorid  from app.navigator n where userid = user_id)
		group by lo.first_name, lo.last_name, lo.profile_pic_url, lo.dob, 
		lo.medicare_advantage, lo.health_insurance, lo.primary_care_physician, 
		lo.hospital,lo.pharmacy, lo.medication, lo.medicaid, cg.notes, gud.state, gud.city) t;		
	
	update app.care_giver 
		   set notes = coalesce(cg_note, notes),
		   updated_at = now(),
		   updated_by = user_id
		   where care_giverid = cg_id
		  and navigatorid = (select navigatorid  from app.navigator n where userid = user_id);
end;
$function$
;
