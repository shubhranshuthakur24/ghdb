CREATE OR REPLACE FUNCTION app.nav_update_uncomplete_task(user_id integer, task_id integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
begin
	update app.task 
		   set is_done = false,
		   	   taskid = task_id,
		   	   updated_by = user_id,
		   	   updated_at = now() 
	where taskid = task_id;
end;
$function$
;
