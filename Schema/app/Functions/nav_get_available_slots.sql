CREATE OR REPLACE FUNCTION app.nav_get_available_slots(user_id integer, start_date character varying, end_date character varying)
 RETURNS TABLE(slots_data json)
 LANGUAGE plpgsql
AS $function$
DECLARE
nav_id int := (select navigatorid from app.navigator where userid = user_id);
	BEGIN

		return QUERY 
		select
			array_to_json(array_agg(row_to_json(t))) as slots_data
				from (select 
						
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
									a2.nav_availabilityid = a.nav_availabilityid )order by s.slotid ) asl),
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
									a2.nav_availabilityid = a.nav_availabilityid)) bsl),
		(select
			coalesce( array_to_json( array_agg( row_to_json(nm)) ), '[]' ) as nav_meetings
		 from
			(
		select n.navigatorid,
					u.profile_pic_url as cg_profile_pic,
					u.userid as cg_userid,
					cg.care_giverid,
					u.firebase_userid as cg_firebaseid,
					u.first_name as cg_first_name,
					u.last_name as cg_last_name,
					u.firebase_userid,
					gud.state,
					gud.city,
					m.meetingid,
					mt.meeting_type_name,
					a1.availability_date,
					a1.nav_availabilityid ,
					s.slot_start_time 
					from
						app.navigator n
					join app.care_giver cg
						on cg.navigatorid = n.navigatorid
					join app.users u
						on u.userid = cg.userid 	
					left join meta.geo_us_data gud
						on gud.zipcode = u.zipcode
					left join app.meeting m 
						on cg.care_giverid  = m.care_giverid  	and m.is_archive = false
					left join meta.meeting_type mt 
						on mt.meeting_typeid = m.meeting_typeid
					left join meta.slot s 
						on s.slotid = m.slotid
					left join app.nav_availability a1 
						on a1.nav_availabilityid = m.nav_availabilityid
						where
						n.userid = user_id  and a1.nav_availabilityid=a.nav_availabilityid 
						order by s.slot_start_time )nm) as nav_meetings
		from app.nav_availability a 
		where a.navigatorid = nav_id
	    and a."availability_date" between start_date::date and end_date::date
	   order by a.availability_date)t;

		
	END;
$function$
;
