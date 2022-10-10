CREATE OR REPLACE FUNCTION app.ctm_update_save_toolkit(user_id integer, toolkit_id integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
	begin
		
		UPDATE app.care_team_member  
		SET 
		saved_toolkit = array_append(saved_toolkit, toolkit_id),
		updated_by = user_id,
		updated_at = now() 
		where userid = user_id
		AND NOT (saved_toolkit @> ARRAY[toolkit_id]);

	END;
$function$
;
