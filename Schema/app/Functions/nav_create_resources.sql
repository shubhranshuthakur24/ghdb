CREATE OR REPLACE FUNCTION app.nav_create_resources(user_id integer, title_val text, info_val text, typeid integer, markdown text, media_formatid_val integer, duration_val integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare 
nav_id int := (select navigatorid from app.navigator where userid = user_id);
begin
	INSERT INTO app.resource
	(title, info, navigatorid, resource_typeid, inserted_at, updated_at,
	inserted_by, updated_by, md_info, media_formatid, duration)
	VALUES(title_val, info_val, nav_id, typeid, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 
	user_id, user_id, markdown, media_formatid_val, duration_val);
end;
$function$
;
