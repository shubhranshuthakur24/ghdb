CREATE OR REPLACE FUNCTION app.nav_update_archive_meet(user_id integer, meeting_id integer, cancel_reason_text text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare
 nav_id int := (select navigatorid from app.navigator where userid = user_id);
begin
	update app.meeting 
		   set is_archive = false,
		   	   cancelled_by = user_id,
		   	   updated_by = user_id,
		   	   cancel_reason = cancel_reason_text,
		   	   updated_by = user_id,
 			   updated_at = now() 
	where meetingid = meeting_id and navigatorid = nav_id;
end;
$function$
;
