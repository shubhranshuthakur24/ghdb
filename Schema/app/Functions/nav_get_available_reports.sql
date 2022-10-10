CREATE OR REPLACE FUNCTION app.nav_get_available_reports(user_id integer)
 RETURNS TABLE(available_reports json)
 LANGUAGE plpgsql
AS $function$

begin
	return QUERY 
			
			select row_to_json(a)as available_reports
			from(select n.reportid from app.navigator n where userid = user_id)a;
		
			
end;
$function$
;
