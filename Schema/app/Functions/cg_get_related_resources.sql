CREATE OR REPLACE FUNCTION app.cg_get_related_resources(user_id integer, resource_type_id integer, data_limit integer, data_offset integer)
 RETURNS TABLE(resource_data json)
 LANGUAGE plpgsql
AS $function$
begin
	return QUERY 
		select
			row_to_json(t) as resource_data
				from (select 
					r.resourceid,
					r.title,
					r.info,
					(select array_to_json(array_agg(row_to_json(td))) as tag_data from(
						select
							rtg.resource_tagid as tagid,
							rtg.tag_name as tag
						from
							meta.resource_tag rtg
						where
							resource_tagid in (
							select
								jsonb_array_elements(r2.resource_tagid)::int as tag_id
							from
								app.resource r2 
							where
								r2.resourceid = r.resourceid)) td)
					from app.resource r 
					join meta.resource_type rt 
					on rt.resource_typeid = r.resource_typeid
					where r.resource_typeid = resource_type_id
					limit data_limit offset data_offset)t;
	
end;
$function$
;
