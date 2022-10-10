CREATE OR REPLACE FUNCTION app.nav_get_assessment(user_id integer)
 RETURNS TABLE(response json)
 LANGUAGE plpgsql
AS $function$
declare
 cg_id int := (select care_giverid from app.care_giver where userid = user_id limit 1); 
begin
	return QUERY 
	select array_to_json(array_agg(row_to_json(t))) as response
	from 
		(select 
			(select question 
			from meta.signup_qa sq where signup_qaid=qid::int) as question,
			(select (answer::json->>(aid::int-1))::json->>'ans'  
			from meta.signup_qa sq2 
			where signup_qaid=qid::int) as answer
		from (
			select jsonb_array_elements_text(signupq_ans)::json->>'qid' qid, 
			jsonb_array_elements_text(signupq_ans)::json->>'aid' aid
			from app.loved_one lo 
			where care_giverid =cg_id) qaid
		union all
		select 'What is your relationship with your loved one?' as question, rs."name" as answer
		from app.loved_one lo2 
		inner join meta.relationship rs 
		on rs.relationshipid = lo2.relationshipid
		where lo2.care_giverid =cg_id
		union all
		select 'What are the diseases your loved one diagnosed with?' as question, array_to_string(array(select d.disease_name 
		from (select jsonb_array_elements_text(diseaseid)::int d 
			from app.loved_one lo 
			where care_giverid=cg_id) d1
		inner join meta.disease d 
		on d1.d = d.diseaseid), ',') as answer
		union all
		select res.question,res.answer 
		from (select unnest(array['Does your loved one have private health insurance?',
		'Does your loved one have Medicaid?',
		'Does your loved one have Medicare or Medicare Advantage (also known as Medicare Part C)?',
		'Does your loved one have Long-Term Care Insurance or Life Insurance that includes Long-term benefits?' ,
		'Anything else you would like us to know about you or your loved one?',
		'Let us know the top 1-2 things you need help with right now in helping care for your loved one and yourself.']) as question,
		unnest((select array[health_insurance::text, medicaid::text, medicare_advantage::text, long_term_insurance::text, more_info::text, priorities::text] 
		from app.loved_one lo where care_giverid=cg_id) ) as answer) as res
		) t;
		
end;
$function$
;
