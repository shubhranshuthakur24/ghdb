CREATE OR REPLACE FUNCTION app.nav_update_save_survey(user_id integer, meeting_id integer, meetingtype_id integer, survey_ jsonb)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare
	nav_id int := (select navigatorid from app.navigator where userid = user_id);
BEGIN
	UPDATE app.meeting 
	SET questionnaire = survey_,
		updated_by = user_id,
		meeting_typeid = meetingtype_id,
		updated_at = now()
	WHERE meetingid = meeting_id and navigatorid = nav_id;
 
END;
$function$
;
