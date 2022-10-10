CREATE OR REPLACE FUNCTION app.nav_get_selected_settings(user_id integer)
 RETURNS TABLE(selected_settings json)
 LANGUAGE plpgsql
AS $function$
declare
begin
	return QUERY
	select
			array_to_json( array_agg(row_to_json(ss))) as selected_language
		from
			(select n.languageid,
					l."name" as language_name
			from app.navigator n
			left join meta."language" l 
			on l.languageid = n.languageid
		where 
			n.userid = user_id ) ss;
	
			
		end;
$function$
;
