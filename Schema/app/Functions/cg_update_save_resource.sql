CREATE OR REPLACE FUNCTION app.cg_update_save_resource(user_id integer, resource_id integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
	begin
		
		update app.care_giver 
		set saved_resource = array_append(saved_resource, resource_id)
		where userid = user_id
		and not (saved_resource @> ARRAY[resource_id]);

	END;
$function$
;
