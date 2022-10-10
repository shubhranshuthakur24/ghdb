CREATE OR REPLACE FUNCTION app.nav_get_assesment_answers(user_id integer)
 RETURNS TABLE(assesment_answers json)
 LANGUAGE plpgsql
AS $function$

begin
	return QUERY 
	select
		row_to_json(a) as assesment_answers
			from(select relationshipid, 
							   diseaseid,
							   expertiseid
							   from app.navigator n 
				left join app.users u 
				on u.userid = n.userid 
				where u.userid =  user_id)a;
end;
$function$
;
