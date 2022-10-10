CREATE OR REPLACE FUNCTION app.cg_create_care_team_member(user_id integer, teamid integer, role_id integer, name character varying, email character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
begin 

	  INSERT INTO app.care_team_member  
    	( team_id , roleid,name,email,inserted_by,inserted_at)
      VALUES(teamid, role_id,name,email,user_id, now());

   

end;
$function$
;
