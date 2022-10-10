CREATE OR REPLACE FUNCTION app.nav_update_todo_status(user_id integer, todo_id integer, todo_text text, deadline character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare

begin
	update app.nav_todo
		   set 
		   nav_todoid = todo_id,
		   todo_list_info = todo_text, 
		   updated_by = user_id,
		   completion_date = case when deadline is null then null else deadline::timestamp end,
		   updated_at = now() 
	where nav_todoid = todo_id and userid = user_id;
end;
$function$
;
