CREATE OR REPLACE FUNCTION app.nav_update_navigator_info_old(user_id integer, zipcode_val character varying, user_gender_id integer, ethnicity_id integer, dob date, profile_picurl character, firstname text, lastname text, contact_detail character varying, mymantra text, education_val character varying, bio_val text, language_id integer, meetingurl character varying, expertise_id integer[], relationship_id integer, disease_id integer[])
 RETURNS void
 LANGUAGE plpgsql
AS $function$
begin
		update 
			app.users
		set 
			zipcode = zipcode_val,
			user_genderid = user_gender_id,
			ethnicityid = ethnicity_id,
			user_dob = dob,
			profile_pic_url = profile_picurl,
			first_name = COALESCE(firstname,first_name),
			last_name = COALESCE(lastname,last_name),
			phone = COALESCE(contact_detail,phone),
			bio = COALESCE(mymantra,'Put a motivational phrase here! E.g., Find a way to laugh everyday')
		where 
			userid = user_id;
		
		update app.navigator 
		   set 
		   	   bio = coalesce(bio_val,bio),
		   	   languageid = coalesce(language_id,languageid),
		   	   meeting_url = coalesce (meetingurl, meeting_url),
		   	   expertiseid = coalesce (expertise_id, expertiseid),
		   	   relationshipid = coalesce (relationship_id,relationshipid),
		   	   diseaseid = coalesce (disease_id,diseaseid)
		   	where userid = user_id;	
end;
$function$
;
