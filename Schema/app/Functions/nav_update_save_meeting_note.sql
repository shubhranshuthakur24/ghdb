CREATE OR REPLACE FUNCTION app.nav_update_save_meeting_note(user_id integer, meeting_id integer, meetingnote character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare
nav_id int := (select navigatorid from app.navigator where userid = user_id);
	begin
		
		update app.meeting 
		set nav_note  = meetingnote,
			updated_by = user_id,
			updated_at = now() 
		where meetingid = meeting_id and navigatorid = nav_id;

	END;
$function$
;
