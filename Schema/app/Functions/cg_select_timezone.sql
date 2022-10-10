CREATE OR REPLACE FUNCTION app.cg_select_timezone(user_id integer, timezone_id integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
begin
	
	update app.users 
	set timezoneid = timezone_id
	where userid = user_id; 
	
end;
$function$
;
