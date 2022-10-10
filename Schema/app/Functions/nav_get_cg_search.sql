CREATE OR REPLACE FUNCTION app.nav_get_cg_search(user_id integer, search_string character varying)
 RETURNS TABLE(response json)
 LANGUAGE plpgsql
AS $function$
DECLARE
BEGIN
	return QUERY 
		select array_to_json(array_agg(row_to_json(t))) as response
		from 
			(select cg.care_giverid,
					u.first_name,
					u.last_name ,
					u.profile_pic_url 
			from app.care_giver cg 
			left join app.navigator n on user_id = n.userid 
			left join app.users u 
			on u.userid = cg.userid 
			where concat(u.first_name,u.last_name)  ilike concat('%',search_string,'%') 
			and cg.navigatorid = n.navigatorid  and 
			is_archive is false
			limit 5
			
			)t;	
END;
$function$
;
