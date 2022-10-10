CREATE OR REPLACE FUNCTION app.cg_get_available_slots(user_id integer, nav_id integer, start_date character varying, end_date character varying)
 RETURNS TABLE(slots_data json)
 LANGUAGE plpgsql
AS $function$
	BEGIN

		return QUERY 
		select
			array_to_json(array_agg(row_to_json(t))) as slots_data
				from (select 
						au.timezoneid as navigator_timezone,
						t2.offset_from_utc as nav_offset_from_utc,
						cg.timezoneid as cg_timezone,
						t.offset_from_utc as cg_offset_from_utc,
						a.nav_availabilityid as availability_id,
						a.availability_date,
						(select array_to_json(array_agg(row_to_json(asl))) as available_slots from(
							select
								s.slotid,
								s.slot_start_time,
								s.slot_end_time
							from
								meta.slot s
							where
								slotid in (
								select
									unnest(a2.available_slot) as slot_id
								from
									app.nav_availability a2 
								where
									a2.nav_availabilityid = a.nav_availabilityid )order by s.slotid) asl),
						(select array_to_json(array_agg(row_to_json(bsl))) as booked_slots from(
							select
								s.slotid,
								s.slot_start_time,
								s.slot_end_time
							from
								meta.slot s
							where
								slotid in (
								select
									unnest(a2.booked_slot) as slot_id
								from
									app.nav_availability a2 
								where
									a2.nav_availabilityid = a.nav_availabilityid)) bsl)
						from app.nav_availability a 
						join app.navigator n 
						on n.navigatorid = nav_id
						join app.users au 
						on n.userid = au.userid 
						join app.care_giver cg 
						on cg.userid = user_id
						join meta.timezone t 
						on t.timezoneid = cg.timezoneid 
						join meta.timezone t2 
						on t2.timezoneid = au.timezoneid 
						where a.navigatorid = nav_id
						and a."availability_date" between start_date::date and end_date::date
					order by a.availability_date
				)t;

		
	END;
$function$
;
