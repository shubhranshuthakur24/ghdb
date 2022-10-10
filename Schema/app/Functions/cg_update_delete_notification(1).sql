CREATE OR REPLACE FUNCTION app.cg_update_delete_notifications(user_id integer, notification_id integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
begin
	update app.user_notification un
		   set is_archive = true,
		   	   updated_by = user_id,
		   	   updated_at = now() 
	where un.user_notificationid = notification_id;
end;
$function$
;
