CREATE OR REPLACE FUNCTION app.nav_get_resource_search(user_id integer, search_string character varying)
 RETURNS TABLE(response json)
 LANGUAGE plpgsql
AS $function$
DECLARE
BEGIN
	return QUERY 
		select array_to_json(array_agg(row_to_json(t))) as response
		from 
			(
			
(select r.resourceid ,
					r.title,
					r.resource_typeid ,
					r.statusid,
					r.navigatorid 
					from app.resource r 
					left join app.navigator n 
					on user_id = n.userid
					where r.title ilike concat('%',search_string,'%')  and r.navigatorid = n.navigatorid limit 3)
					union 
					select r.resourceid ,
					r.title,
					r.resource_typeid ,
					r.statusid,
					r.navigatorid 
					from app.resource r 
					where r.title ilike concat('%',search_string,'%')  and statusid = 4000
					limit 3
					 
			)t;	
END;
$function$
;
