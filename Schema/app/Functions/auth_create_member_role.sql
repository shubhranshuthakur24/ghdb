CREATE OR REPLACE FUNCTION app.auth_create_member_role(user_id integer, role_id_ integer)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
declare

begin
	UPDATE app.team_member
	SET roleid=role_id_
	WHERE userid = user_id;

	return (select tr.role_name from app.team_member tm 
	inner join meta.team_role tr  on tm.roleid = tr.roleid
	where tm.userid = user_id);

end;
$function$
;
