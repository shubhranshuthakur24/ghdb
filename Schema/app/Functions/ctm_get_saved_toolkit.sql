CREATE OR REPLACE FUNCTION app.ctm_get_saved_toolkit(user_id integer, data_limit integer, data_offset integer)
 RETURNS TABLE(toolkit json)
 LANGUAGE plpgsql
AS $function$
	begin
		return QUERY
			select
	row_to_json(t) as toolkit
		from(with cte as (
				select
					unnest(saved_toolkit) as toolkitid
				from
					app.care_team_member ctm
				where
					userid = user_id)
				select 
					t.title,
					t.info,
					tt.toolkit_type_name as toolkit_type,
					t.toolkit_typeid,
					t.toolkitid,
					mf.format_name as format,
					mf.media_formatid as formatid,
					t.media_url,
					t.duration,
					(select is_saved from (
						select (select saved_toolkit from app.care_team_member ctm where userid=user_id) @>  array[unnest(array(select toolkitid from app.toolkit))] as is_saved, 
						unnest(array(select toolkitid from app.toolkit)) as toolkitids ) as d where d.toolkitids=t.toolkitid) as is_saved
						
				from app.toolkit t 
				join meta.toolkit_type tt 
				on tt.toolkit_typeid = t.toolkit_typeid
				join meta.media_format mf
				on mf.media_formatid = t.media_formatid
				where
				t.toolkitid in (
				select
					cte.toolkitid::int
				from
					cte)
			limit data_limit offset data_offset)t;

	END;
$function$
;
