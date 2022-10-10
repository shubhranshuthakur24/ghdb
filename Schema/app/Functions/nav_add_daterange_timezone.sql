CREATE OR REPLACE FUNCTION app.nav_add_daterange_timezone(user_id integer, timezone_id integer, daterange integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
begin
	
	update app.navigator
	set timezoneid = timezone_id,
	date_range = daterange
	where userid = user_id; 
	
end;
$function$
;
