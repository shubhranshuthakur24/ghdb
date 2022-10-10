CREATE OR REPLACE FUNCTION app.nav_get_survey(user_id integer, meeting_id integer)
 RETURNS TABLE(response json)
 LANGUAGE plpgsql
AS $function$
DECLARE
BEGIN
	return QUERY 
		select array_to_json(array_agg(row_to_json(t))) as response
		from 
			(select sq.question, qa.answer, sq.meeting_questionnaireid as id
			from ( 
			   select jsonb_array_elements_text(questionnaire)::json->>'id' question, 
				jsonb_array_elements_text(questionnaire)::json->>'ans' answer
				from app.meeting m 
				where meetingid = meeting_id 
				and m.navigatorid  = (select navigatorid from app.navigator where userid=user_id)
			) qa
			inner join meta.meeting_questionnaire sq  
			on sq.meeting_questionnaireid = qa.question::int
			)t;		
END;
$function$
;
