CREATE OR REPLACE FUNCTION app.cg_get_assesment_answers(user_id integer)
 RETURNS TABLE(assesment_answers json)
 LANGUAGE plpgsql
AS $function$

begin
	return QUERY 
	select
		row_to_json(a) as assesment_answers
			from(select signupq_ans, 
							   medicare_advantage,
							   medicaid,
							   health_insurance,
							   long_term_insurance
							   from app.loved_one lo left join app.care_giver cg 
				on cg.care_giverid = lo.care_giverid
				left join app.users u 
				on u.userid = cg.userid 
				where u.userid = user_id)a;
end;
$function$
;
