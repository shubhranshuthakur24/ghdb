CREATE OR REPLACE FUNCTION app.nav_update_reassign_todo(user_id integer, task_id integer, new_user_id integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare

begin
	update app.nav_todo 
		   set 
		   assign_to = new_user_id,
		   updated_by = user_id,
		   updated_at = now() 
	where nav_todoid = task_id and userid = user_id;
end;
$function$
;
