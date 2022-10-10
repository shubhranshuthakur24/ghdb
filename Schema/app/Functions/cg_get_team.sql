CREATE OR REPLACE FUNCTION app.cg_get_team(user_id integer)
 RETURNS TABLE(members json)
 LANGUAGE plpgsql
AS $function$
begin
	return QUERY
--		select json_agg(row_to_json(t)) from (select ta.team_name, u.first_name, u.last_name, 
--	u.email, u.user_typeid, u.userid,
--	tr.role_name as cg_role_as 
--	from (select unnest(member) as tt,team_name
--		from app.team where created_by = user_id)ta
--	left join app.team_member tm 
--	  on tm.team_memberid = ta.tt 
--	left join app.users u 
--	  on u.userid = tm.userid 
--	left join meta.team_role tr 
--	  on tr.roleid = tm.roleid) t;
		
	select json_agg(row_to_json(r)) 
	from (select t.teamid, t.team_name, u.first_name, u.last_name,
		(select json_agg(row_to_json(r)) as members 
			from (
			select u.first_name, u.last_name, u.email, tr.role_name as role from (select unnest(t2."member") as id 
				from app.team t2 
				where t2.teamid = t.teamid
				)tt inner join app.team_member tm 
					 on tm.team_memberid = tt.id
					inner join app.users u
					  on u.userid = tm.userid
					inner join meta.team_role tr 
					  on tr.roleid = tm.roleid) r
		) as members
		from app.team t
		inner join app.users u 
			on u.userid = t.created_by 
		where t.created_by = user_id
	) r;
		

end;
$function$
;
