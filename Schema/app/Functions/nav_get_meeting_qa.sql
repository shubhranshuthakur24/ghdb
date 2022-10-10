CREATE OR REPLACE FUNCTION app.nav_get_meeting_qa(user_id integer, type_id integer)
 RETURNS TABLE(questions json)
 LANGUAGE plpgsql
AS $function$
declare
	question json;
begin
	
	question := (select jsonb_agg(row_to_json(t))
		from (select mq.meeting_questionnaireid, mq.question, mq.answer from meta.meeting_questionnaire mq where mq.meeting_typeid = type_id order by meeting_questionnaireid )t
		);
	
	if question is null then 
		return Query ( select '["No question"]'::json );
	else 
		return Query (select question);
	end if;
	
end;
$function$
;
