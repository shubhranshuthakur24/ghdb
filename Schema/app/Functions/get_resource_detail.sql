CREATE OR REPLACE FUNCTION app.get_resource_detail(user_id integer, resource_id integer)
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
		r.cost,
		r.eligibility,
		r.phone,
		r.email,
		r.website_url,
		r.media_url,
		r.banner_pic_url,
		r.duration,
		mf.format_name as format,
		case when 
				(select resource_ids from(
				select jsonb_array_elements(saved_resourceid):: int as resource_ids from app.care_giver cg where userid = user_id)a
				where resource_ids = r.resourceid)= r.resourceid then true
				else false end as is_saved,
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
		where r.resourceid = resource_id)t;
	
end;
$function$
;
