CREATE OR REPLACE FUNCTION app.cg_create_team_member(user_id integer, teamid integer, role_id integer, name character varying, email character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare
--  up_code varchar := (SELECT array_to_string(array(select substr('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',((random()*(36-1)+1)::integer),1) from generate_series(1,6)),''));
--  cnt int := select
begin 
--	perform * from app.team_referral where created_by = user_id;
	
--	if not found then 
	  INSERT INTO app.care_team_member  
    	( team_id , roleid,name,email,inserted_by)
      VALUES(teamid, role_id,name,email,user_id);
--    end if;
   
--    update app.team_referral  
--    set roleid = role_id
--    where created_by = user_id;
--   
--    return (select up_code as code);
end
$function$
;
