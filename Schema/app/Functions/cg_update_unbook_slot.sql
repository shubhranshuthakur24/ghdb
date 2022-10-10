CREATE OR REPLACE FUNCTION app.cg_update_unbook_slot(user_id integer, meeting_id integer, cancelled_reason text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
	declare
	slot_id int:= (select slotid  from app.meeting where meetingid = meeting_id);
	availability_id integer:= (select nav_availabilityid from app.meeting where meetingid = meeting_id);

	begin
		
		UPDATE app.meeting SET is_archive = true,
		cancel_reason = cancelled_reason,
		cancelled_by = user_id,
		updated_at = now(),
		updated_by = user_id
		where 
		meetingid = meeting_id;
	
		UPDATE app.nav_availability
		SET available_slot = array_append(available_slot, slot_id) ,
		    booked_slot = array_remove(booked_slot, slot_id),
		    updated_at = now()
		WHERE nav_availabilityid = availability_id and not available_slot @> array[slot_id];
	
	END;
$function$
;
