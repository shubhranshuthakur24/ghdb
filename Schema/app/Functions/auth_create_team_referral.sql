CREATE OR REPLACE FUNCTION app.auth_create_team_referral(user_id integer, role_id integer)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
declare
  up_code varchar := (SELECT array_to_string(array(select substr('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',((random()*(36-1)+1)::integer),1) from generate_series(1,6)),''));
--  cnt int := select
begin 
--	perform * from app.team_referral where created_by = user_id;
	
--	if not found then 
	  INSERT INTO app.team_referral 
    	(upcode, created_by, roleid)
      VALUES(up_code, user_id, role_id);
--    end if;
   
    update app.team_referral  
    set roleid = role_id
    where created_by = user_id;
   
    return (select up_code as code);
end
$function$
;
