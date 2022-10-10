CREATE OR REPLACE FUNCTION app.nav_update_remove_resources(user_id integer, cg_id integer, resource_id integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
BEGIN
	UPDATE app.care_giver
	SET 
	assigned_resource=array_remove(assigned_resource, resource_id),
	updated_by = user_id,
 	updated_at = now() 
	WHERE care_giverid=cg_id and navigatorid  = (select navigatorid from app.navigator where userid=user_id);
 
END;
$function$
;
