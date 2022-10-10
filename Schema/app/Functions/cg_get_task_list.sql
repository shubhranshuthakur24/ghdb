CREATE OR REPLACE FUNCTION app.cg_get_task_list(user_id integer)
 RETURNS TABLE(task_info text, taskid integer, is_done boolean, task_completion_datetime text, asignee_userid integer)
 LANGUAGE plpgsql
AS $function$
begin
	return QUERY 
		select nt.task_info,
			   nt.taskid,
			   nt.is_done,
			   nt.task_completion_datetime:: text,
			   nt.assign_to as asignee_userid
			from 
				app.task nt
			
			where (nt.assign_to = user_id or nt.userid= user_id )
		and nt.is_archive = false order by nt.is_done asc,nt.taskid desc;
end;
$function$
;
