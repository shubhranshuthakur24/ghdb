CREATE OR REPLACE FUNCTION app.nav_update_reassign_task(user_id integer, task_id integer, new_user_id integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare

begin
	update app.task 
		   set 
		   assign_to = new_user_id,
		   updated_by = user_id,
		   updated_at = now() 
	where taskid = task_id;
end;
$function$
;
