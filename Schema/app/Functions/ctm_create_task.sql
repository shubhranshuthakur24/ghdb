CREATE OR REPLACE FUNCTION app.ctm_create_task(user_id integer, task_text character varying, deadline character varying, assign_to_user_id integer)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
declare 
return_task_id integer;
	begin
		insert into 
		app.task (userid,
						task_info,
					    is_done,
					    task_completion_datetime,
					    is_navigator_owner,
					    assign_to,
					    inserted_by,
					    inserted_at)
						values
						(user_id,
						task_text,
						false,
						case when deadline is null then null else deadline::timestamp end,
						false,
						assign_to_user_id,
						user_id,
						now())  returning taskid into return_task_id;
	return return_task_id;

	END;
$function$
;
