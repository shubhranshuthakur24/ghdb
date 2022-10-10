CREATE OR REPLACE FUNCTION app.ctm_get_toolkit(user_id integer, toolkit_type_id integer)
 RETURNS TABLE(toolkit json)
 LANGUAGE plpgsql
AS $function$
begin
	return QUERY
select
row_to_json(t) as toolkit
	from (select 
		t.title,
		t.info,
		t.toolkitid,
		tt.toolkit_type_name as toolkit_type,
		t.toolkit_typeid,
		mf.format_name as format,
		mf.media_formatid as formatid,
		t.media_url,
		t.duration,
		(select is_saved from (
		select (select saved_toolkit from app.care_team_member ctm where userid=user_id) @>  array[unnest(array(select toolkitid from app.toolkit order by toolkitid))] as is_saved, 
		unnest(array(select toolkitid from app.toolkit order by toolkitid)) as toolkitids ) as d where d.toolkitids=t.toolkitid)
--		
		from app.toolkit t 
		join meta.toolkit_type tt 
		on tt.toolkit_typeid = t.toolkit_typeid
		join meta.media_format mf
		on mf.media_formatid = t.media_formatid
		where t.toolkit_typeid = toolkit_type_id)t;
end;
$function$
;
