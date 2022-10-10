CREATE OR REPLACE FUNCTION app.cg_get_related_toolkit(user_id integer, toolkit_type_id integer, data_limit integer, data_offset integer)
 RETURNS TABLE(toolkit_data json)
 LANGUAGE plpgsql
AS $function$
begin
	return QUERY 
		select
			row_to_json(t) as toolkit_data
				from (select 
				t.title,
				t.info,
				tt.toolkit_type_name as toolkit_type,
				t.toolkit_typeid,
				mf.format_name as format,
				mf.media_formatid as formatid,
				(select array_to_json(array_agg(row_to_json(dt))) as category_data from(
					select
						tc.toolkit_categoryid as categoryid,
						tc.category_name as category
					from
						meta.toolkit_category tc 
					where
						toolkit_categoryid in (
						select
							jsonb_array_elements(t2.toolkit_categoryid)::int as category_id
						from
							app.toolkit t2
						where
							t2.toolkitid = t.toolkitid)) dt)
				from app.toolkit t 
				join meta.toolkit_type tt 
				on tt.toolkit_typeid = t.toolkit_typeid
				join meta.media_format mf
				on mf.media_formatid = t.media_formatid
				where t.toolkit_typeid = toolkit_type_id
				limit data_limit offset data_offset)t;
	
end;
$function$
;
