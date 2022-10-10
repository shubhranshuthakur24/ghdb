CREATE OR REPLACE FUNCTION app.nav_get_nav_basic_details(nav_id integer)
 RETURNS TABLE(data json)
 LANGUAGE plpgsql
AS $function$
begin
	return QUERY 
	select row_to_json(nbd) as nav_basic_details from
		(select
			u.email,
			n.meeting_url as meet,
			u.first_name || ' ' || u.last_name as nav_name,
			u.userid
		from
			app.users u
		join app.navigator n on
			n.userid = u.userid
		where
			n.navigatorid = nav_id)nbd;
	
end;
$function$
;
