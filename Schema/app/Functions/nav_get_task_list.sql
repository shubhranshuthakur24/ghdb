CREATE OR REPLACE FUNCTION app.nav_get_task_list(user_id integer, cg_id integer DEFAULT NULL::integer)
 RETURNS TABLE(task_info text, navigator_taskid integer, is_done boolean, task_completion_datetime text, asignee_userid integer, care_giverid integer)
 LANGUAGE plpgsql
AS $function$
begin
	return QUERY 
		select nt.task_info,
			   nt.taskid,
			   nt.is_done,
			   nt.task_completion_datetime:: text,
			   nt.assign_to as asignee_userid,
			   cg1.care_giverid as care_giverID
			from 
				app.task nt
			LEFT JOIN app.care_giver cg1 on cg1.userid  = nt.userid 
			where nt.assign_to  = user_id 
		and nt.userid =cg_id and nt.is_archive = false order by nt.is_done asc,nt.taskid desc;
		
	
end;
$function$
;
