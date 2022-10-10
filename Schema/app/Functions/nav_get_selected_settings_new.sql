CREATE OR REPLACE FUNCTION app.nav_get_selected_settings_new(user_id integer)
 RETURNS TABLE(language_id integer[])
 LANGUAGE plpgsql
AS $function$
declare
begin
	return QUERY
	 select u.lang_id::int[] as language_id from app.users u where userid = user_id;
			
		end;
$function$
;
