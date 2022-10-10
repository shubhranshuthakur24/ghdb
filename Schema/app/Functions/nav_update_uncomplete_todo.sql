CREATE OR REPLACE FUNCTION app.nav_update_uncomplete_todo(user_id integer, todo_id integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
begin
	update app.nav_todo 
		   set is_done = false,
		   	   nav_todoid = todo_id,
		   	   updated_by = user_id,
		   	   updated_at = now() 
	where nav_todoid = todo_id and userid = user_id;
end;
$function$
;
