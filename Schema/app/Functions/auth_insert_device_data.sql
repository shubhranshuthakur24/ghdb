CREATE OR REPLACE FUNCTION app.auth_insert_device_data(user_id integer, token_device_notification text, meta_data json, device_channelid_data integer, token_data text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
begin
	
	UPDATE app.users 
	set last_login = current_timestamp,
		updated_at=current_timestamp 
	where userid = user_id;

--	INSERT into app.user_device ( userid, device_notification_token, meta, 
--		device_channelid, is_active, token, inserted_at ) 
--	VALUES (user_id, token_device_notification, meta_data, device_channelid_data, true, token_data, current_timestamp ) 
--	ON CONFLICT (userid, device_channelid) 
--	DO UPDATE SET token=EXCLUDED.token, device_notification_token=EXCLUDED.device_notification_token, 
--	meta=EXCLUDED.meta,is_active = True;

	INSERT into app.user_device ( userid, device_notification_token, meta, 
		device_channelid, is_active, token, inserted_at ) 
	VALUES (user_id, token_device_notification, meta_data, device_channelid_data, true, token_data, current_timestamp ) 
	ON CONFLICT (userid, device_channelid) 
	DO UPDATE SET token=EXCLUDED.token, device_notification_token=token_device_notification, 
	meta=meta_data,is_active = true;


	update app.user_device 
	set updated_at = now()
	where userid = user_id and device_channelid = device_channelid_data;
	
--	UPDATE app.user_device set is_active = false, 
--	updated_at=current_timestamp 
--	where token != token_data and userid = user_id
--	and device_notification_token != token_device_notification;
--	
end;
$function$
;
