CREATE OR REPLACE FUNCTION app.cg_get_task_list_userid_limit_offset(user_id integer, off_set integer, t_limit integer)
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
			where t.is_archive = false and t.userid  = user_id order by t.taskid  desc  
			 offset off_set limit t_limit 
		;
end;
$function$
;
