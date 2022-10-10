CREATE OR REPLACE FUNCTION app.cg_update_meeting_preference_new(user_id integer, cg_id integer, meeting_preference integer, phone_number character varying DEFAULT NULL::character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
begin 
	if phone_number is null then
		update app.meeting  
		set 
		preference_id  = meeting_preference,
		updated_at = now()
		where care_giverid  = cg_id ;
	else
		update app.meeting  
		set 
		preference_id = meeting_preference,
		updated_at = now()
		where care_giverid  = cg_id ;
	
		update app.users 
		set 
		phone  = phone_number,
		updated_at = now()
		where userid = user_id;
	end if;


end;
$function$
;
