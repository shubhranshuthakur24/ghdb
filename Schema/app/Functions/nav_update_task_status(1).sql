CREATE OR REPLACE FUNCTION app.nav_update_task_status(user_id integer, task_id integer, task_text text, deadline character varying, assign_to_user_id integer)
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
		   updated_at = now(),
		   assign_to = assign_to_user_id
	where taskid = task_id;
end;
$function$
;
