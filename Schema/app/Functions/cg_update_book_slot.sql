CREATE OR REPLACE FUNCTION app.cg_update_book_slot(user_id integer, nav_id integer, availability_id integer, slot_id integer, meeting_type_id integer, slot_data integer[])
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare
	care_giver_id integer:= (select care_giverid from app.care_giver where userid = user_id);
begin
	INSERT INTO app.meeting
				(navigatorid, 
				care_giverid , 
				meeting_typeid,
				slotid,
				nav_availabilityid,
				inserted_by) values
				(nav_id,
				care_giver_id,
				meeting_type_id,
				slot_id,
				availability_id,
				user_id);

	update app.nav_availability
	set booked_slot  = array_append(booked_slot, slot_id), 
	available_slot  = slot_data,
	updated_at = now()
	where nav_availabilityid  = availability_id and not booked_slot @> array[slot_id];	
	

end;
$function$
;
