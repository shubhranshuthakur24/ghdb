CREATE OR REPLACE FUNCTION app.nav_get_todo_list_offset_limit(user_id integer, off_set integer, l_limit integer)
 RETURNS TABLE(todo_list_info text, todo_listid integer, todo_completion_datetime text, is_done boolean)
 LANGUAGE plpgsql
AS $function$
begin
	return QUERY 
		select td.todo_list_info,
			   td.nav_todoid,
			   td.completion_date:: text,
			   td.is_done
			from 
				app.nav_todo td
			where td.userid = user_id and is_archive = false order by td.is_done asc,
		td.nav_todoid offset off_set limit l_limit;
end;
$function$
;
