CREATE OR REPLACE FUNCTION app.nav_update_meeting_status(user_id integer, meeting_id integer, meeting_status_id integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare

begin
	update app.meeting
		   set 
		   meeting_statusid = meeting_status_id,
		   updated_by = user_id,
		   updated_at = now() 
	where meetingid = meeting_id;
end;
$function$
;
