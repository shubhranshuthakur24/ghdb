CREATE OR REPLACE FUNCTION app.nav_get_weekly_schedule(user_id integer)
 RETURNS TABLE(resp json)
 LANGUAGE plpgsql
AS $function$
declare
begin
	return QUERY
	select row_to_json(t) as res
	from ( 
	select array(select unnest(weekly_schedule) as slots 
		from app.navigator where userid = user_id order by slots ) slots
	)t ;
end
$function$
;
