CREATE OR REPLACE FUNCTION app.nav_get_cg_task_list(user_id integer, cg_userid integer DEFAULT NULL::integer)
 RETURNS TABLE(task_info text, navigator_taskid integer, is_done boolean, task_completion_datetime text, asignee_userid integer, assign_to_first_name character varying, assigned_by_userid integer, assigned_by_first_name character varying)
 LANGUAGE plpgsql
AS $function$
begin
	return QUERY 
	select nt.task_info,
			   nt.taskid,
			   nt.is_done,
			   nt.task_completion_datetime:: text,
			   nt.assign_to as asignee_userid,
			   u2.first_name ,
			--   u2.last_name ,
			--   u2.user_typeid ,
			   nt.userid ,
			    u1.first_name 
			--   u1.last_name ,
			--   u1.user_typeid 
		from app.task nt
		inner join app.users u1 on u1.userid =nt.userid 
		inner join app.users u2 on u2.userid =nt.assign_to 
		where (nt.assign_to  = user_id or nt.userid = user_id)
		and    (coalesce (cg_userid,nt.userid) = nt.userid or coalesce (cg_userid,nt.assign_to) = nt.assign_to )
		and nt.is_archive = false order by nt.is_done asc,nt.taskid desc; 
	
	
end;
$function$
;
