CREATE OR REPLACE FUNCTION app.auth_update_notification_status(user_id integer, change_status boolean)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
begin 

	if change_status=true then
		update app.users 
		set notification_status = not notification_status ,
		updated_at = now()
		where userid = user_id;
	end if;

	return (select notification_status from app.users where userid = user_id);

end
$function$
;
