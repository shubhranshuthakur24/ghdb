CREATE OR REPLACE FUNCTION app.select_language(user_id integer, language_id integer[])
 RETURNS void
 LANGUAGE plpgsql
AS $function$
begin 
	update app.users 
	set 
	lang_id = language_id
	where userid = user_id;
end;

$function$
;
