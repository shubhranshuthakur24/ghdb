CREATE OR REPLACE FUNCTION app.nav_get_questionnaire_answers(user_id integer, meeting_id integer)
 RETURNS TABLE(questionnaire_answers json)
 LANGUAGE plpgsql
AS $function$
declare
	nav_id int := (select navigatorid from app.navigator where userid = user_id);
begin
	return QUERY 
	select
		row_to_json(a) as questionnaire_answers
			from(select questionnaire
							   from app.meeting m  
								where m.meetingid = meeting_id and m.navigatorid = nav_id)a;
end;
$function$
;
