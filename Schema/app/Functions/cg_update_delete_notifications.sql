CREATE OR REPLACE FUNCTION app.cg_update_delete_notifications(user_id integer, notification_id integer, all_clear boolean)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
begin
	if all_clear = true then
		update app.user_notification 
			set is_archive = true,
			updated_by = user_id,
			updated_at = now()
		where userid = user_id;
	else
		update app.user_notification un
			   set is_archive = true,
			   	   updated_by = user_id,
			   	   updated_at = now() 
		where un.user_notificationid = notification_id;
	end if;
end;
$function$
;
