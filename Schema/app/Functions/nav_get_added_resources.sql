CREATE OR REPLACE FUNCTION app.nav_get_added_resources(user_id integer)
 RETURNS TABLE(response json)
 LANGUAGE plpgsql
AS $function$
declare

BEGIN
	return QUERY 
	
	select json_agg(
	(
		(select array_to_json(array_agg(row_to_json(t))) as response
		from (select r.*,
					rt.resource_type_name,
					mf.format_name as format
	from app.resource r
	join app.navigator n
		on n.userid = user_id
	left join meta.resource_type rt
		on rt.resource_typeid = r.resource_typeid
	left join meta.media_format mf
		on mf.media_formatid = r.media_formatid 
		where r.inserted_by = user_id and r.statusid <5000  order by r.inserted_at desc) t) 
	) ) as response;

END;
$function$
;
