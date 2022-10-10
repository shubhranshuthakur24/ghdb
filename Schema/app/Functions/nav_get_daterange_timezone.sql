CREATE OR REPLACE FUNCTION app.nav_get_daterange_timezone(user_id integer)
 RETURNS TABLE(resp json)
 LANGUAGE plpgsql
AS $function$
declare
begin
	return QUERY
	select row_to_json(t) as res
	from (select u.timezoneid, 
			n.date_range 
			from app.navigator n 
			join app.users u on user_id = u.userid
			where n.userid = user_id)t;
end
$function$
;
