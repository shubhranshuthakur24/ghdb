CREATE OR REPLACE FUNCTION app.nav_get_resources(user_id integer, cg_id integer)
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
		where (r.statusid=4000)) t),
		(select array_to_json(array_agg(row_to_json(r))) as cg_resource_data
		from (select r2.*,
					 rt2.resource_type_name,
					 mf2.format_name as format
		from app.care_giver cg 
		join app.resource r2 
		on r2.resourceid = any(select unnest(cg.assigned_resource) 
		from app.care_giver cg where cg.care_giverid=cg_id)
		left join meta.resource_type rt2
		on rt2.resource_typeid = r2.resource_typeid
	left join meta.media_format mf2
		on mf2.media_formatid = r2.media_formatid 
		where care_giverid = cg_id)r) 
	) ) as response;

END;
$function$
;
