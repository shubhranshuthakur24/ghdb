CREATE OR REPLACE FUNCTION app.cg_create_care_team(user_id integer, team_name_ character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare
cgid integer=(select care_giverid   from app.care_giver where userid=user_id);
begin
	INSERT INTO app.care_team 
				(team_name,
				care_giverid,
				inserted_by,
				inserted_at)
		values
			(team_name_,
			cgid,
			user_id,
			now());
	
end;
$function$
;
