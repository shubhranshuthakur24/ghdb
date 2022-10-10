CREATE OR REPLACE FUNCTION app.cg_get_signup_qa_old(user_id integer)
 RETURNS TABLE(questions json)
 LANGUAGE plpgsql
AS $function$
declare
	question json;
begin
	
	question := (select jsonb_agg(row_to_json(t))
		from (select signup_qaid, question  from meta.signup_qa order by signup_qaid )t
		);
	
	if question is null then 
		return Query ( select '["No question"]'::json );
	else 
		return Query (select question);
	end if;
	
end;
$function$
;
