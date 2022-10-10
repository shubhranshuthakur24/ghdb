CREATE OR REPLACE FUNCTION app.nav_remove_resources(user_id integer, cg_id integer, resource_id integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
BEGIN
	UPDATE app.care_giver
	SET assigned_resource=array_remove(assigned_resource, resource_id) 
	WHERE care_giverid=cg_id;
 
END;
$function$
;
