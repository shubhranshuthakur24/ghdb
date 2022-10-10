CREATE OR REPLACE FUNCTION app.cg_check_assessment_status(user_id integer)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
declare
  qacount int := (SELECT COUNT(*)as assessment_questions from (select jsonb_array_elements(signupq_ans)
					from app.loved_one lo
				left join app.care_giver cg 
				on cg.care_giverid = lo.care_giverid
				left join app.users u 
				on u.userid = cg.userid 
				where u.userid = user_id)SQA);
begin 
	if 
		qacount <17 then
		update app.care_giver
		set assessment_status = 'incomplete'
		where userid = user_id;
	
	else 
		update app.care_giver
		set assessment_status = 'completed'
		where userid = user_id;
		
	end if;
	  return (select assessment_status from app.care_giver cg 
				left join app.users u 
				on u.userid = cg.userid 
				where u.userid = user_id);
end
$function$
;
