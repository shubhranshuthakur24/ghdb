CREATE OR REPLACE FUNCTION app.nav_create_task(user_id integer, cg_id integer, task_text text, deadline character varying, assign_to_user_id integer)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
declare 
return_nav_task_id integer;
-- nav_id int := (select navigatorid from app.navigator where userid = user_id);
begin
	insert into 
		app.task (
					task_info,
				    is_done,
				    task_completion_datetime,
				    is_navigator_owner,
				    assign_to,
				    userid,
				    inserted_by,
				    inserted_at)
					values
					(
					task_text,
					false,
					case when deadline is null then null else deadline::timestamp end,
					false,
					assign_to_user_id,
				    user_id,
				   	user_id,
				  	now()) returning taskid into return_nav_task_id;
	return return_nav_task_id;

end;
$function$
;
