CREATE OR REPLACE FUNCTION app.cg_get_notifications(user_id integer, change_flag boolean)
 RETURNS TABLE(notifications json)
 LANGUAGE plpgsql
AS $function$
begin
	if change_flag = true then 
		update app.user_notification 
		set red_flag = false 
		where userid = user_id and red_flag = true;
		
		end if;
	return QUERY 
		select
			array_to_json( array_agg(row_to_json(t))) as notifications
		from
			(select 
			un.user_notificationid,
			un.title,
			un.body,
			date_part('day',now()-un.inserted_at) as days_old,
			un.notification_data,
			red_flag
		from 
			app.user_notification un 
		where 
			un.userid = user_id and un.is_archive = false) t;
		
end;
$function$
;
