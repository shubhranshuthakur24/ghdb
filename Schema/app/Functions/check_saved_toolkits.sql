CREATE OR REPLACE FUNCTION app.check_saved_toolkits(user_id integer, toolkit_id integer)
 RETURNS TABLE(exist boolean)
 LANGUAGE plpgsql
AS $function$
begin
	return QUERY
	with cte as (
		select
			jsonb_array_elements(saved_toolkitid)::int as toolkit
		from
			app.care_giver cg 
		where
			userid = user_id)
		select
			exists (
			select
				1
			from
				cte
			where
				cte.toolkit in (toolkit_id)) as exist;
end;
$function$
;
