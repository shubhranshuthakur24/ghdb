CREATE OR REPLACE FUNCTION app._get_all_meeting_questionnaire(user_id integer, meeting_type_id integer)
 RETURNS TABLE(questions json)
 LANGUAGE plpgsql
AS $function$
declare
	question json;
begin
	
	question := (select jsonb_agg(row_to_json(t))
		from (select * from meta.meeting_questionnaire mq 
				where meeting_typeid = meeting_type_id
			)t );
	if question is null then 
		return Query ( select '["No question"]'::json );
	else 
		return Query (select question);
	end if;
	
end;
$function$
;
