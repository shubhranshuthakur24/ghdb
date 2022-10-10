CREATE OR REPLACE FUNCTION app.get_notifications(user_id integer)
 RETURNS TABLE(notifications json)
 LANGUAGE plpgsql
AS $function$
begin
	return QUERY 
		select
			array_to_json( array_agg(row_to_json(t))) as notifications
		from
			(select 
			un.user_notificationid,
			un.title,
			un.body,
			date_part('day',now()-un.inserted_at) as days_old,
			un.notification_data 
		from 
			app.user_notification un 
		where 
			un.userid = user_id) t;
	
end;
$function$
;
