CREATE OR REPLACE FUNCTION app.nav_update_nav_info(user_id integer, education_val character varying, bio_val text, language_id integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
begin
	update app.navigator 
		   set education = education_val,
		   	   bio = bio_val,
		   	   languageid = language_id,
		   	   updated_by = user_id,
 			   updated_at = now()
		   	where userid = user_id;	
end;
$function$
;
