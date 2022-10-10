CREATE OR REPLACE FUNCTION app.nav_update_resources(user_id integer, title_val text, info_val text, typeid integer, markdown text, status_id smallint, resource_id integer, media_formatid_val integer, duration_val integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare 
nav_id int := (select navigatorid from app.navigator where userid = user_id);
begin
	UPDATE app.resource
	set title = coalesce (title_val, title),
	info = coalesce(info_val, info),
	navigatorid = nav_id,
	resource_typeid = coalesce(typeid, resource_typeid),
	updated_at = CURRENT_TIMESTAMP,
	updated_by = user_id,
	md_info = coalesce(markdown, md_info),
	statusid = coalesce(status_id, statusid),
	media_formatid = coalesce(media_formatid_val, media_formatid), 
	duration = coalesce(duration_val, duration)
	where resourceid = resource_id;
end;
$function$
;
