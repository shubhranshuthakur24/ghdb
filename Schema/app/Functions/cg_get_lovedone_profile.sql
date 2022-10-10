CREATE OR REPLACE FUNCTION app.cg_get_lovedone_profile(user_id integer, loved_one_id integer)
 RETURNS TABLE(loved_one_data json)
 LANGUAGE plpgsql
AS $function$
begin
	return QUERY
	select
	row_to_json(t) as loved_on_data
	from
	(select 
			lo.loved_oneid ,
			lo.first_name ,
			lo.last_name,
			lo.profile_pic_url,
			lo.relationshipid,
			lo.zipcode,
--			lo.ethnicityid,
			(SELECT array_to_string((select lo.ethnicityid from app.loved_one lo where loved_oneid = loved_one_id), ' ')) as ethnicityid,
			(select array_agg(e.name) as ethnicity from unnest(lo.ethnicityid) id 
			join meta.ethnicity e 
			on id.id = e.ethnicityid),
			lo.genderid, 
			to_char(
				lo.dob,
				'DD-Mon-YYYY'
			) as dob,
			lo.medicare_advantage,
			lo.health_insurance,
			lo.long_term_insurance,
			lo.primary_care_physician,
			lo.phone,
			lo.hospital,
			lo.allergy,
			lo.pharmacy,
			lo.mental_condition,
			lo.physical_condition,
			lo.medication,
			lo.medicaid,
			gud.state,
			gud.city,
			ug.gender_name as gender,
--			e."name" as ethnicity,
			(select array_to_json(array_agg(row_to_json(dt))) as disease_data from(
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
				lo.loved_oneid = loved_one_id)) dt)
		from
			app.loved_one lo
		join app.care_giver cg 
			on cg.care_giverid = lo.care_giverid
		left join meta.geo_us_data gud
			on gud.zipcode = lo.zipcode 
		left join meta.user_gender ug 
			on ug.user_genderid = lo.genderid 
--		left join meta.ethnicity e 
--			on e.ethnicityid = lo.ethnicityid
		where 
			lo.loved_oneid = loved_one_id
			and cg.userid = user_id) t;
	
end;
$function$
;
