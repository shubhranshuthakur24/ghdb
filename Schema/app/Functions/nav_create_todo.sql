CREATE OR REPLACE FUNCTION app.nav_create_todo(user_id integer, todo_text text, deadline character varying)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
declare 
return_nav_todo_id integer;
begin
	insert into 
		app.nav_todo (userid,
							inserted_by,
							todo_list_info,
						    is_done,
						    completion_date,
						    inserted_at)
							values
							(user_id,
							user_id,
							todo_text,
							false,
							case when deadline is null then null else deadline::timestamp end,
							now()) returning nav_todoid into return_nav_todo_id;
	return return_nav_todo_id;
		
end;
$function$
;
