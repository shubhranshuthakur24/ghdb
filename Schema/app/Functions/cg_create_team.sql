CREATE OR REPLACE FUNCTION app.cg_create_team(user_id integer, team_name_ character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare

begin
	INSERT INTO app.team
	(team_name, created_by, "member")
	VALUES(team_name_ , user_id, '{}'::integer[]);
	
end;
$function$
;
