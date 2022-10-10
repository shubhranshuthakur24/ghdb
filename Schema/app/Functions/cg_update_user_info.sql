CREATE OR REPLACE FUNCTION app.cg_update_user_info(user_id integer, zipcode_val character varying, user_gender_id integer, ethnicity_id integer[], dob date, contact_details character varying, profile_picurl character, firstname text, lastname text, mymantra text, timezone_id integer)
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
			phone = coalesce(contact_details,phone),
			profile_pic_url = profile_picurl,
			first_name = COALESCE(firstname,first_name),
			last_name = COALESCE(lastname,last_name),
			bio = COALESCE(mymantra,'Put a motivational phrase here! E.g., Find a way to laugh everyday')
		where 
			userid = user_id;
		
		update 
			app.care_giver 
		set
			timezoneid = coalesce(timezone_id,timezoneid)
		where 
			userid = user_id;
end;
$function$
;
