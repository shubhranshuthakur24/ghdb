CREATE OR REPLACE FUNCTION app.cg_chat_suggestions()
 RETURNS TABLE(resourceid integer, title text)
 LANGUAGE plpgsql
AS $function$
begin
	return query select r.resourceid ,r.title  from app.resource r where statusid =3000;
end

$function$
;
