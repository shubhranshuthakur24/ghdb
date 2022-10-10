CREATE OR REPLACE FUNCTION app.ctm_update_user_info(user_id integer, zipcode_val character varying, user_gender_id integer, ethnicity_id integer[], dob date, contact_details character varying, profile_picurl character, firstname text, lastname text, mymantra text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare 
tz varchar := (select timezone  from meta.zip z where z.zip  = zipcode_val);
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
			bio = COALESCE(mymantra,'Put a motivational phrase here! E.g., Find a way to laugh everyday'),
			updated_at = now() 
		where 
			userid = user_id;
		
		if tz = 'America/Los_Angeles' then 
		 update 
			 
			app.users 
		 set
			timezoneid = 152 
			where userid = user_id;
		
		
		elsif tz = 'America/New_York' then 
		update
		app.users 
		 set
			timezoneid = 74 
			where userid = user_id;
		
		elsif tz = 'America/Chicago' then 
		update
		app.users 
		 set
			timezoneid = 50 
		    where userid = user_id;
		   
		elsif tz = 'America/Boise' then 
		update
		app.users 
		 set
			timezoneid = 127 
		    where userid = user_id;
		else
		update
		app.users
		 set
			timezoneid = 74 
		    where userid = user_id;
		
	
		end if;
		
end;
$function$
;
