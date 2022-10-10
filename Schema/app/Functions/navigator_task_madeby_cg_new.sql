CREATE OR REPLACE FUNCTION app.navigator_task_madeby_cg_new(user_id integer)
 RETURNS TABLE(response json)
 LANGUAGE plpgsql
AS $function$
begin
	return query
	select array_to_json(array_agg(row_to_json(t))) as response
		from (
	select t.task_info,
			  t.taskid,
			   t.is_done,
			   t.task_completion_datetime:: text,
			   t.assign_to as asignee_userid,
			   t.userid  as cg_user_task_list,
			   t.care_giverid,
			   t.navigatorid,
			   t.inserted_by 
			   from app.task t
			   left join app.navigator n 
			   on user_id = n.userid
			   where t.navigatorid =n.navigatorid  and
			   assign_to = user_id and
			   t.is_archive = false
			union 
	select t1.task_info,
			  t1.taskid,
			   t1.is_done,
			   t1.task_completion_datetime:: text,
			   t1.assign_to as asignee_userid,
			   t1.userid as cg_user_task_list,
			   t1.care_giverid,
			   t1.navigatorid,
			   t1.inserted_by  from app.task t1 where t1.assign_to = user_id 
			   and t1.is_archive = false)t;
end;

$function$
;
