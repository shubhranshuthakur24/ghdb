CREATE OR REPLACE FUNCTION app.cg_update_save_assessment(user_id integer, signup_qa jsonb, note text, longterm_ins text, med_adv text, health_ins text, priority text, moreinfo text, medic_aid character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
begin
		update 
			app.loved_one
		set
			signupq_ans = signup_qa,
--			notes = note,
			long_term_insurance = longterm_ins,
			medicare_advantage  = med_adv,
			health_insurance = health_ins,
			medicaid  = medic_aid,
			priorities = priority,
			more_info = moreinfo,
			updated_by = user_id,
			updated_at = now()
		from (select care_giverid from app.care_giver where userid = user_id) AS subquery
		where loved_one.care_giverid=subquery.care_giverid;
end;
$function$
;
