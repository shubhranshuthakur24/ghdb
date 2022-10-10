CREATE OR REPLACE FUNCTION app.nav_select_language(user_id integer, language_id integer)
 RETURNS TABLE(selected_language json)
 LANGUAGE plpgsql
AS $function$
begin
	
	update app.navigator 
	set languageid = language_id
	where userid = user_id; 


end;
$function$
;
