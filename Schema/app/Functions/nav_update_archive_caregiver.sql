CREATE OR REPLACE FUNCTION app.nav_update_archive_caregiver(user_id integer, cg_id integer, archive_status boolean)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare 

begin
	UPDATE app.care_giver 
	set is_archive = archive_status,
		updated_by = user_id,
		updated_at = CURRENT_TIMESTAMP
	where care_giverid = cg_id;
end;
$function$
;
