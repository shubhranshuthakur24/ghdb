CREATE OR REPLACE FUNCTION app.cg_update_unsave_resource(user_id integer, resource_id integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
	begin
		update app.care_giver 
		set 
		saved_resource = array_remove(saved_resource, resource_id),
		updated_by = user_id,
		updated_at = now()
		where userid = user_id; 
	END;
$function$
;
