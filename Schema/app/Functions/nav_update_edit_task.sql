CREATE OR REPLACE FUNCTION app.nav_update_edit_task(user_id integer, task_id integer, task_text text, deadline character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare

begin
	update app.task 
		   set 
		   taskid = task_id,
		   task_info = task_text, 
		   task_completion_datetime = case when deadline is null then null else deadline::timestamp end,
		   updated_by = user_id,
		   updated_at = now() 
	where taskid = task_id;
end;
$function$
;
