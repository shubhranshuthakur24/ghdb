CREATE OR REPLACE FUNCTION app.nav_update_delete_task(user_id integer, task_id integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
begin
	update app.task 
		   set is_archive = true,
		   	   taskid = task_id,
		   	   updated_by = user_id,
		   	   updated_at = now() 
	where taskid = task_id;
end;
$function$
;
