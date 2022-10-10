CREATE OR REPLACE FUNCTION app.get_nav_resources(user_id integer, cg_id integer)
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
	left join app.resource_type rt
		on rt.resource_typeid = r.resource_typeid
	left join meta.media_format mf
		on mf.media_formatid = r.media_formatid) t),
		(select  row_to_json(r) as cg_resource_data
		from (select assigned_resource from app.care_giver cg where care_giverid = cg_id) r ) 
	) ) as response;

END;
$function$
;
