CREATE OR REPLACE FUNCTION app.cg_get_task_list_userid(user_id integer)
 RETURNS TABLE(task_info text, taskid integer, is_done boolean, task_completion_datetime text, asignee_userid integer, inserted_by integer)
 LANGUAGE plpgsql
AS $function$
begin
	return QUERY 
		select t.task_info,
			   t.taskid,
			   t.is_done,
			   t.task_completion_datetime:: text,
			   t.assign_to as asignee_userid,
			   t.inserted_by 
			from 
				app.task t
			where t.userid  = user_id  and t.is_archive = false order by t.is_done asc;
end;
$function$
;
