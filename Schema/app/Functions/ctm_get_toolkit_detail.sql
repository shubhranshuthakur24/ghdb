CREATE OR REPLACE FUNCTION app.ctm_get_toolkit_detail(user_id integer, toolkit_id integer)
 RETURNS TABLE(toolkit_data json)
 LANGUAGE plpgsql
AS $function$
begin
	return QUERY
	select
		row_to_json(t) as toolkit_data
			from (select 
					t.toolkitid,
					t.title,
					t.info,
					tt.toolkit_type_name as toolkit_type,
					t.toolkit_typeid,
					t.media_url,
					t.duration,
					mf.format_name as format,
					mf.media_formatid as formatid,
					(select is_saved from (
						select (select saved_toolkit from app.care_team_member ctm where userid=user_id) @>  array[unnest(array(select toolkitid from app.toolkit))] as is_saved, 
						unnest(array(select toolkitid from app.toolkit)) as toolkitids ) as d where d.toolkitids=t.toolkitid)
					from app.toolkit t 
					join meta.toolkit_type tt 
					on tt.toolkit_typeid = t.toolkit_typeid
					join meta.media_format mf
					on mf.media_formatid = t.media_formatid
					where t.toolkitid = toolkit_id)t;
				
end;
$function$
;
