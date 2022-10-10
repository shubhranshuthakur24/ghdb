CREATE OR REPLACE FUNCTION app.nav_get_task_search(user_id integer, search_string character varying)
 RETURNS TABLE(response json)
 LANGUAGE plpgsql
AS $function$
DECLARE
BEGIN
	return QUERY 
		select array_to_json(array_agg(row_to_json(t))) as response
		from 
			(select t.taskid ,
					t.task_info,
					t.userid,
					t.task_completion_datetime
					from app.task t 
					left join app.navigator n
					on user_id = n.userid
					left join app.care_giver cg
					on cg.navigatorid = n.navigatorid 
					where t.task_info ilike concat('%',search_string,'%')  and
					t.userid = cg.userid 
					limit 5
			)t;		
END;
$function$
;
