CREATE OR REPLACE FUNCTION app.cg_update_loved_one_info(user_id integer, first_name_val character varying, last_name_val character varying, zipcode_val character varying, user_gender_id integer, ethnicity_id integer[], dob_val date, relationship_id integer, disease_id jsonb, profile_picurl character, med_adv character varying, health_ins character varying, primarycarephysician character varying, hospital_of_choice character varying, contact_details text, known_allergy character varying, phramacy_information character varying, medication_list character varying, medic_aid character varying, long_term_ins character varying, physical_cond character varying, mental_cond character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
begin
		update 
			app.loved_one
		set 
			first_name = first_name_val,
			last_name = last_name_val,
			zipcode = zipcode_val,
			genderid = user_gender_id,
			ethnicityid = ethnicity_id,
			dob = dob_val,
			relationshipid = COALESCE(relationship_id,relationshipid),
			diseaseid = COALESCE(disease_id,diseaseid),
			profile_pic_url = coalesce(profile_picurl,profile_pic_url),
			medicare_advantage = coalesce(med_adv, medicare_advantage),
			health_insurance = coalesce(health_ins,health_insurance),
			primary_care_physician = coalesce(primarycarephysician, primary_care_physician),
			hospital  = coalesce(hospital_of_choice,hospital),
			phone = coalesce(contact_details,phone),
			allergy = coalesce(known_allergy,allergy),
			pharmacy = coalesce(phramacy_information,pharmacy),
			medication = coalesce(medication_list,medication),
			medicaid = coalesce(medic_aid, medicaid),
			long_term_insurance = coalesce(long_term_ins, long_term_insurance),
			physical_condition = coalesce(physical_cond, physical_condition),
			mental_condition = coalesce(mental_cond, mental_condition)
		from (select care_giverid from app.care_giver where userid = user_id) AS subquery
		where loved_one.care_giverid = subquery.care_giverid;
end;
$function$
;
