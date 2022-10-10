CREATE OR REPLACE FUNCTION app.ctm_update_unsave_toolkit(user_id integer, toolkit_id integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
	BEGIN

		update app.care_team_member  
		set 
		saved_toolkit = array_remove(saved_toolkit, toolkit_id),
		updated_by = user_id,
		updated_at = now() 
		where userid = user_id; 
		
	END;
$function$
;
