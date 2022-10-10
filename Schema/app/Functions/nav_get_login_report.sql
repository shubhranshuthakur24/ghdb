CREATE OR REPLACE FUNCTION app.nav_get_login_report(user_id integer)
 RETURNS TABLE(login_report json)
 LANGUAGE plpgsql
AS $function$
declare
	login_report json;

begin
	return QUERY 
			
			select array_to_json(array_agg(row_to_json(a)))as login_report
			from(select cg.care_giverid, u.userid, u.first_name, u.last_name,u.last_login 
			from app.care_giver cg
			left join app.users u  
			on u.userid = cg.userid
			where cg.navigatorid =(select navigatorid from app.navigator where userid = user_id))a;
		
		
--			INSERT INTO app.reports
--			(report_name, 
--			 sql_function,
--			 description,
--			 parameters,
--			 inserted_by) values
--			 ('Login_report',
--			 'nav_get_login_report',
--			 'A breif report of user last login data',
--			 login_report,
--			 user_id);
			 	
end;
$function$
;
