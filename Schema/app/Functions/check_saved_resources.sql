CREATE OR REPLACE FUNCTION app.check_saved_resources(user_id integer, resource_id integer)
 RETURNS TABLE(exist boolean)
 LANGUAGE plpgsql
AS $function$
begin
	return QUERY
	with cte as (
		select
			jsonb_array_elements(saved_resourceid)::int as resource
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
				cte.resource in (resource_id)) as exist;
end;
$function$
;
