CREATE OR REPLACE FUNCTION app.nav_update_remove_weekly_schedule(user_id integer, slot_data integer[])
 RETURNS void
 LANGUAGE plpgsql
AS $function$
begin

	update app.navigator 
	set 
	weekly_schedule = (select array(
		select unnest(weekly_schedule) from app.navigator where userid=user_id 
		except 
		select unnest(slot_data) )),
		updated_by = user_id,
 		updated_at = now() 
	where userid = user_id ;	

end;
$function$
;
