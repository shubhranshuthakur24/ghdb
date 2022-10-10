CREATE OR REPLACE FUNCTION app.recover_userid_for_tasks()
 RETURNS void
 LANGUAGE plpgsql
AS $function$
begin
	
	with new_data as(
	select n.userid,n.timezoneid  from app.navigator n    
	)
	update app.users Task  set
	timezoneid = new_data.timezoneid
	from new_data
	where Task.userid = new_data.userid ;
	
	
end;
$function$
;
