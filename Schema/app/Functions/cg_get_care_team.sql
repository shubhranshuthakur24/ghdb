CREATE OR REPLACE FUNCTION app.cg_get_care_team(cgid integer)
 RETURNS TABLE(team_id integer, team_name character varying, made_by integer, inserted_at text)
 LANGUAGE plpgsql
AS $function$
begin
	return query 
		select ct.team_id ,
		ct.team_name ,
		ct.care_giverid  as made_by,
		ct.inserted_at ::text
		from app.care_team ct
		where ct.care_giverid =cgid;
		
--		using cgid for getting the TEAM
end;
$function$
;
