CREATE OR REPLACE FUNCTION app.cg_get_care_team_member(teamid integer)
 RETURNS TABLE(ctm_id integer, userid integer, name character varying, email character varying, roleid integer, inserted_at text, team_name character varying, made_by integer)
 LANGUAGE plpgsql
AS $function$
begin 
	return query 
	select ctm.ctm_id ,ctm.userid,ctm."name" ,ctm.email ,ctm.roleid,
	ctm.inserted_at ::text,
	
	ct.team_name ,ct.care_giverid as made_by
	from app.care_team_member ctm
	left join app.care_team ct on ctm.team_id = ct.team_id 
--	left join on care_team table with team_id
	where ctm.team_id = teamid;
	
end;
$function$
;
