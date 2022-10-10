CREATE OR REPLACE FUNCTION app.cm_get_newuser(user_id integer, newuser boolean DEFAULT NULL::boolean)
 RETURNS TABLE(new_user boolean)
 LANGUAGE plpgsql
AS $function$
begin
	if newuser is null then
			return query select u.new_user  from app.users u where u.userid  = user_id;
	else
		update app.users 
		   set new_user  = newuser ,
--		   	   updated_by = user_id,
		   	   updated_at = now() 
		where userid  = user_id;
		return query select u.new_user  from app.users u where userid =user_id;
	end if;
end;
$function$
;
