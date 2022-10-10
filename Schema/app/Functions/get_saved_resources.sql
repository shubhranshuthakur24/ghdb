CREATE OR REPLACE FUNCTION app.get_saved_resources(user_id integer, data_limit integer, data_offset integer)
 RETURNS TABLE(resources json)
 LANGUAGE plpgsql
AS $function$
	begin
		return QUERY
		select
			row_to_json(t) as resources
				from(with cte as (
					select
						unnest(saved_resource) as resourceid
					from
						app.care_giver
					where
						userid = user_id)
					select 
					r.resourceid,
					r.title,
					r.info,
					(select is_saved from (
					select (select saved_resource from app.care_giver where userid=user_id) @>  array[unnest(array(select resourceid from app.resource))] as is_saved, 
					unnest(array(select resourceid from app.resource)) as resourceids ) as d where d.resourceids=r.resourceid) as is_saved,
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
					from
						app.resource r 
					join app.resource_type rt 
					on rt.resource_typeid = r.resource_typeid
					where
						r.resourceid in (
						select
							cte.resourceid::int
						from
							cte)
					limit data_limit offset data_offset)t;


	END;
$function$
;
