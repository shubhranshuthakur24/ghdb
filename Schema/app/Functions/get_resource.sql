CREATE OR REPLACE FUNCTION app.get_resource(user_id integer, resource_type_id integer)
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
					rt.resource_type_name as resource_type,
					r.resource_typeid,
					mf.format_name as format,
					mf.media_formatid as formatid,
					r.media_url,
					r.duration,
					(select is_saved from (
					select (select saved_resource from app.care_giver where userid=user_id) @>  array[unnest(array(select resourceid from app.resource order by resourceid))] as is_saved, 
					unnest(array(select resourceid from app.resource r3 order by resourceid)) as resourceids ) as d where d.resourceids=r.resourceid),
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
					join app.resource_type rt 
					on rt.resource_typeid = r.resource_typeid
					join meta.media_format mf
					on mf.media_formatid = r.media_formatid
					where array[r.resourceid] <@ (select assigned_resource from app.care_giver where userid=user_id) )t;
					
				end;
$function$
;
