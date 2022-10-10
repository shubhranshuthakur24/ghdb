CREATE OR REPLACE FUNCTION app.nav_assign_resources(user_id integer, cg_id integer, resource_id integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
BEGIN
	UPDATE app.care_giver
	SET assigned_resource=array_append(assigned_resource, resource_id) 
	WHERE care_giverid=cg_id and not (assigned_resource @> ARRAY[resource_id])
	and navigatorid  = (select navigatorid from app.navigator where userid=user_id);
 
END;
$function$
;
