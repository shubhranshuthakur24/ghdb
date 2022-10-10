CREATE OR REPLACE FUNCTION app.auth_user_reset_password_request(user_id integer)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
	declare
		key_ text;
		return_generated_key text;
	begin
		key_ :=  app.random_string(6);
		insert into app.user_password_request (userid, generated_key, generated_time ) values (user_id, key_, current_timestamp) returning generated_key into return_generated_key;
		return return_generated_key;
end ;
$function$
;
