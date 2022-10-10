CREATE OR REPLACE FUNCTION app.cg_select_navigator(user_id integer, navigator_id integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
begin
		update 
			app.care_giver
		set 
			navigatorid = navigator_id
		where 
			userid = user_id;
end;
$function$
;
