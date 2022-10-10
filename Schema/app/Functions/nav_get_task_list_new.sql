CREATE OR REPLACE FUNCTION app.nav_get_task_list_new(cg_userid integer)
 RETURNS TABLE(task_info text, taskid integer, is_done boolean, task_completion_datetime text, asignee_userid integer, userid integer, inserted_by integer)
 LANGUAGE plpgsql
AS $function$
begin
	return QUERY 
		select t.task_info,
			  t.taskid,
			   t.is_done,
			   t.task_completion_datetime:: text,
			   t.assign_to as asignee_userid,
			   t.userid as cg_user_task_list,
			   t.inserted_by 
			from 
				app.task t
--			join app.care_giver cg1 on cg1.care_giverid = nt.care_giverid
			where t.userid  = cg_userid and t.is_archive = false order by t.taskid asc;
end;
$function$
;
