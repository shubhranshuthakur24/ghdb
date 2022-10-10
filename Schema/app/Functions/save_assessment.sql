CREATE OR REPLACE FUNCTION app.save_assessment(user_id integer, signup_qa jsonb, note text, longterm_ins text, primary_ins text, secondary_ins text, priority text, moreinfo text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
begin
		update 
			app.loved_one
		set
			signupq_ans = signup_qa,
			notes = note,
			long_term_insurance = longterm_ins,
			primary_insurance = primary_ins,
			secondary_insurance = secondary_ins,
			priorities = priority,
			more_info = moreinfo,
			updated_at = now(),
			updated_by = user_id
		from (select care_giverid from app.care_giver where userid = user_id) AS subquery
		where loved_one.care_giverid=subquery.care_giverid;
end;
$function$
;
