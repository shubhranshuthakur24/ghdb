CREATE OR REPLACE FUNCTION app.cg_get_group_chat_data(firebaseid text[])
 RETURNS TABLE(group_chat_data json)
 LANGUAGE plpgsql
AS $function$
begin
	return QUERY 
		select
	row_to_json(t) as group_chat_data
from
	(select u.userid,
			u.first_name,
			u.last_name,
			u.profile_pic_url,
			u.firebase_userid,
		(select ud.device_notification_token 
		from app.user_device ud where ud.userid = u.userid 
		order by ud.updated_at asc limit 1)
			from app.users u 
			where u.firebase_userid = any (firebaseid)) t;
	
end;
$function$
;
