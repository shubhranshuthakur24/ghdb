CREATE OR REPLACE FUNCTION app.nav_get_appointment_data(availability_id integer, slot_id integer)
 RETURNS TABLE(apt_date text, apt_time json)
 LANGUAGE plpgsql
AS $function$
begin
	return QUERY 
		select
			to_char(
				a.availability_date,
				'DD-Mon-YYYY'
			) as date,
			(
			select
				row_to_json(apt) as appointment_time
			from
				(
				select
					s.slot_start_time,
					s.slot_end_time
				from
					meta.slot s
				where
					s.slotid = slot_id)apt)
		from
			app.nav_availability a
		where	a.nav_availabilityid = availability_id;
		
	
end;
$function$
;
