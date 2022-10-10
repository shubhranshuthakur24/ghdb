CREATE OR REPLACE FUNCTION app.auth_get_team_referral(user_id integer)
 RETURNS TABLE(upcode jsonb)
 LANGUAGE plpgsql
AS $function$
declare
	result jsonb ;
begin
	result := (select jsonb_agg(row_to_json(t))
		from (select tr.upcode as code, tr.inserted_at as created_at from app.team_referral tr
			where tr.created_by = user_id) t);
		
	if result isnull then
		return Query (select '["No data"]'::jsonb as upcode);
	else 
		return Query (select result);
	end if;
end
$function$
;
