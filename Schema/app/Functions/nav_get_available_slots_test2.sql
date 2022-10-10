CREATE OR REPLACE FUNCTION app.nav_get_available_slots_test2(user_id integer, start_date character varying, end_date character varying, calendar_date character varying)
 RETURNS TABLE(slots_data json)
 LANGUAGE plpgsql
AS $function$
DECLARE
nav_id int := (select navigatorid from app.navigator where userid = user_id);

timezone int := (select timezoneid from app.navigator where userid = user_id );

new_date_part int := (select case (select extract(dow from date (calendar_date))) when 0 then 7 else (select extract(dow from date (calendar_date))) end);

first_slot int := (select CONCAT (new_date_part::text, '0000')::integer);

--new_date date := (select case when timezone = 50 then (SELECT date(start_date::date - interval '6 hours'))
--							  when timezone = 74 then (SELECT date(start_date::date - interval '5 hours'))
--							  when timezone = 152 then (SELECT date(start_date::date - interval '8 hours'))end);
--							 
--new_date_part int := (select case when timezone = 50 then (select extract(dow from date (new_date - interval '6 hours')))
--								  when timezone = 74 then (select extract(dow from date (new_date - interval '5 hours')))
--								  when timezone = 152 then (select extract(dow from date (new_date - interval '8 hours')))end);
								 
--dummy_slot int := (select case when timezone = 50 then s.cst_slots 
--						   when timezone = 152 then s.pst_slots 
--						   when timezone = 74 then s.est_slots 
--						   when timezone = 23 then s.bit_slots end from meta.slot s);
	BEGIN
	
		if new_date_part <7 then
		
		return QUERY 
		select
			array_to_json(array_agg(row_to_json(t))) as slots_data
				from (select 
						
--						a.nav_availabilityid as availability_id,
--						a.availability_date,
						(select array_to_json(array_agg(row_to_json(asl))) as available_slots from(
							select
								a.nav_availabilityid as availability_id,
								a.availability_date as availability_date_UTC,
								s.slotid as UTC_slotid,
								s.slot_start_time,
								case
					when timezone = 50 then(select to_char(s.slot_start_time::time - interval '6 hours 00 minutes', 'hh12:mi PM')::text)
					when timezone = 74 then(select to_char(s.slot_start_time::time - interval '5 hours 00 minutes', 'hh12:mi PM')::text)
					when timezone = 152 then(select to_char(s.slot_start_time::time - interval '8 hours 00 minutes', 'hh12:mi PM')::text)
					END as new_slot_start_time_as_selected_timezone,
								case
					when timezone = 50 then(select to_char(s.slot_end_time::time - interval '6 hours 00 minutes', 'hh12:mi PM')::text)
					when timezone = 74 then(select to_char(s.slot_end_time::time - interval '5 hours 00 minutes', 'hh12:mi PM')::text)
					when timezone = 152 then(select to_char(s.slot_end_time::time - interval '8 hours 00 minutes', 'hh12:mi PM')::text)
					END as new_slot_end_time_as_selected_timezone,
									case
					when timezone = 50 then(select(SELECT (((select to_char((select na2.availability_date from app.nav_availability na2  where na2.nav_availabilityid =a.nav_availabilityid),'YYYY-MON-DD ')))||(select to_char((select s2.slot_start_time::time from meta.slot s2 where s2.slotid =s.slotid),'HH12:MIPM')))::timestamp + interval '6 hours')::date)
					when timezone = 74 then(select(SELECT (((select to_char((select na2.availability_date from app.nav_availability na2  where na2.nav_availabilityid =a.nav_availabilityid),'YYYY-MON-DD ')))||(select to_char((select s2.slot_start_time::time from meta.slot s2 where s2.slotid =s.slotid),'HH12:MIPM')))::timestamp + interval '5 hours')::date)
					when timezone = 152 then(select(SELECT (((select to_char((select na2.availability_date from app.nav_availability na2  where na2.nav_availabilityid =a.nav_availabilityid),'YYYY-MON-DD ')))||(select to_char((select s2.slot_start_time::time from meta.slot s2 where s2.slotid =s.slotid),'HH12:MIPM')))::timestamp + interval '8 hours')::date)
					END as new_availability_date_as_selected_timezone
--								(SELECT DATE((select to_timestamp((SELECT EXTRACT(EPOCH FROM ((a.availability_date)::date+(s.slot_start_time)::time))))- interval '5 hours')))
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
				(select array_to_json(array_agg(row_to_json(md))) as marking_data from(
							select
								s.slotid as UTC_slotid,
								case
					when s.date_part = new_date_part then calendar_date::date
					when s.date_part  != new_date_part then (SELECT date(calendar_date::date + interval '1 day'))
					  END as new_availability_date_UTC,
--									case
--					when timezone = 50 then s.cst_slots 
--					when timezone = 74 then s.est_slots
--					when timezone = 152 then s.pst_slots
--					  END as new_slotid,
								case
					when timezone = 50 then(select to_char(s.slot_start_time::time - interval '6 hours 00 minutes', 'hh12:mi PM')::text)
					when timezone = 74 then(select to_char(s.slot_start_time::time - interval '5 hours 00 minutes', 'hh12:mi PM')::text)
					when timezone = 152 then(select to_char(s.slot_start_time::time - interval '8 hours 00 minutes', 'hh12:mi PM')::text)
					END as new_slot_start_time_as_selected_timezone,
					case
					when timezone = 50 then(select to_char(s.slot_end_time::time - interval '6 hours 00 minutes', 'hh12:mi PM')::text)
					when timezone = 74 then(select to_char(s.slot_end_time::time - interval '5 hours 00 minutes', 'hh12:mi PM')::text)
					when timezone = 152 then(select to_char(s.slot_end_time::time - interval '8 hours 00 minutes', 'hh12:mi PM')::text)
					END as new_slot_end_time_as_selected_timezone
							from
								meta.slot s
							where
								first_slot <= (select case
					when timezone = 50 then s.cst_slots 
					when timezone = 74 then s.est_slots
					when timezone = 152 then s.pst_slots
					  END) 
--					 Below condition is applicable when date part is not 7
					  and
					  (s.date_part = new_date_part  or s.date_part = (new_date_part + 1)) 

					 order by s.slotid limit 24)md),
		(select
			coalesce( array_to_json( array_agg( row_to_json(nm)) ), '[]' ) as nav_meetings
		 from
			(
		select n.navigatorid,
					n.timezoneid,
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
					s.slotid as UTC_slotid,
--					(select a.availability_date  + s.slot_start_time::time - interval '6 hours' ) as cst_datetime,
--					(select a.availability_date  + s.slot_start_time::time - interval '5 hours' ) as est_datetime,
--					(select a.availability_date  + s.slot_start_time::time - interval '8 hours' ) as pst_datetime,
					s.slot_start_time as UTC_start_time,
					case
					when timezone = 50 then(select (SELECT ((select to_timestamp(((SELECT EXTRACT(EPOCH FROM ((a.availability_date)::date+(s.slot_start_time)::time))))))::timestamp AT TIME ZONE 'UTC')::date - interval '6 hours')::date)
					when timezone = 74 then(select (SELECT ((select to_timestamp(((SELECT EXTRACT(EPOCH FROM ((a.availability_date)::date+(s.slot_start_time)::time))))))::timestamp AT TIME ZONE 'UTC')::date - interval '5 hours')::date)
					when timezone = 152 then(select (SELECT ((select to_timestamp(((SELECT EXTRACT(EPOCH FROM ((a.availability_date)::date+(s.slot_start_time)::time))))))::timestamp AT TIME ZONE 'UTC')::date - interval '8 hours')::date)
					END as new_availability_date_as_selected_timezone,
				case
					when n.timezoneid = 50 then s.cst_slots 
					when n.timezoneid = 74 then s.est_slots
					when n.timezoneid = 152 then s.pst_slots
					  END as new_slotid_as_selected_timezone,
				case
					when n.timezoneid = 50 then (select to_char(s.slot_start_time::time - interval '6 hours 00 minutes', 'hh12:mi:PM')::text)
					when n.timezoneid = 74 then (select to_char(s.slot_start_time::time - interval '5 hours 00 minutes', 'hh12:mi:PM')::text)
					when n.timezoneid = 152 then (select to_char(s.slot_start_time::time - interval '8 hours 00 minutes', 'hh12:mi:PM')::text)
					  END as new_slot_start_time_as_selected_timezone
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
						n.userid = user_id 
						and a1.nav_availabilityid=a.nav_availabilityid
						order by s.slot_start_time )nm) as nav_meetings
		from app.nav_availability a 
		where a.navigatorid = nav_id
	    and a."availability_date" between start_date::date and end_date::date
	   order by a.availability_date)t;
	
else

	return QUERY 
		select
			array_to_json(array_agg(row_to_json(t))) as slots_data
				from (select 
						
--						a.nav_availabilityid as availability_id,
--						a.availability_date,
						(select array_to_json(array_agg(row_to_json(asl))) as available_slots from(
							select
								a.nav_availabilityid as availability_id,
								a.availability_date as availability_date_UTC,
								s.slotid as UTC_slotid,
								s.slot_start_time,
								case
					when timezone = 50 then(select to_char(s.slot_start_time::time - interval '6 hours 00 minutes', 'hh12:mi PM')::text)
					when timezone = 74 then(select to_char(s.slot_start_time::time - interval '5 hours 00 minutes', 'hh12:mi PM')::text)
					when timezone = 152 then(select to_char(s.slot_start_time::time - interval '8 hours 00 minutes', 'hh12:mi PM')::text)
					END as new_slot_start_time_as_selected_timezone,
								case
					when timezone = 50 then(select to_char(s.slot_end_time::time - interval '6 hours 00 minutes', 'hh12:mi PM')::text)
					when timezone = 74 then(select to_char(s.slot_end_time::time - interval '5 hours 00 minutes', 'hh12:mi PM')::text)
					when timezone = 152 then(select to_char(s.slot_end_time::time - interval '8 hours 00 minutes', 'hh12:mi PM')::text)
					END as new_slot_end_time_as_selected_timezone,
								case
					when timezone = 50 then(select(SELECT (((select to_char((select na2.availability_date from app.nav_availability na2  where na2.nav_availabilityid =a.nav_availabilityid),'YYYY-MON-DD ')))||(select to_char((select s2.slot_start_time::time from meta.slot s2 where s2.slotid =s.slotid),'HH12:MIPM')))::timestamp + interval '6 hours')::date)
					when timezone = 74 then(select(SELECT (((select to_char((select na2.availability_date from app.nav_availability na2  where na2.nav_availabilityid =a.nav_availabilityid),'YYYY-MON-DD ')))||(select to_char((select s2.slot_start_time::time from meta.slot s2 where s2.slotid =s.slotid),'HH12:MIPM')))::timestamp + interval '5 hours')::date)
					when timezone = 152 then(select(SELECT (((select to_char((select na2.availability_date from app.nav_availability na2  where na2.nav_availabilityid =a.nav_availabilityid),'YYYY-MON-DD ')))||(select to_char((select s2.slot_start_time::time from meta.slot s2 where s2.slotid =s.slotid),'HH12:MIPM')))::timestamp + interval '8 hours')::date)
					END as new_availability_date_as_selected_timezone
--								(SELECT DATE((select to_timestamp((SELECT EXTRACT(EPOCH FROM ((a.availability_date)::date+(s.slot_start_time)::time))))- interval '5 hours')))
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
		(select array_to_json(array_agg(row_to_json(md))) as marking_data from(
							select
								s.slotid as UTC_slotid,
								case
					when s.date_part = new_date_part then calendar_date::date
					when s.date_part  != new_date_part then (SELECT date(calendar_date::date + interval '1 day'))
					  END as new_availability_date_UTC,
--									case
--					when timezone = 50 then s.cst_slots 
--					when timezone = 74 then s.est_slots
--					when timezone = 152 then s.pst_slots
--					  END as new_slotid,
								case
					when timezone = 50 then(select to_char(s.slot_start_time::time - interval '6 hours 00 minutes', 'hh12:mi PM')::text)
					when timezone = 74 then(select to_char(s.slot_start_time::time - interval '5 hours 00 minutes', 'hh12:mi PM')::text)
					when timezone = 152 then(select to_char(s.slot_start_time::time - interval '8 hours 00 minutes', 'hh12:mi PM')::text)
					END as new_slot_start_time_as_selected_timezone,
					case
					when timezone = 50 then(select to_char(s.slot_end_time::time - interval '6 hours 00 minutes', 'hh12:mi PM')::text)
					when timezone = 74 then(select to_char(s.slot_end_time::time - interval '5 hours 00 minutes', 'hh12:mi PM')::text)
					when timezone = 152 then(select to_char(s.slot_end_time::time - interval '8 hours 00 minutes', 'hh12:mi PM')::text)
					END as new_slot_end_time_as_selected_timezone
							from
								meta.slot s
							where
								first_slot <= (select case
					when timezone = 50 then s.cst_slots 
					when timezone = 74 then s.est_slots
					when timezone = 152 then s.pst_slots
					  END)order by s.slotid limit 24)md),
		(select
			coalesce( array_to_json( array_agg( row_to_json(nm)) ), '[]' ) as nav_meetings
		 from
			(
		select n.navigatorid,
					n.timezoneid,
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
					s.slotid,
--					(select a.availability_date  + s.slot_start_time::time - interval '6 hours' ) as cst_datetime,
--					(select a.availability_date  + s.slot_start_time::time - interval '5 hours' ) as est_datetime,
--					(select a.availability_date  + s.slot_start_time::time - interval '8 hours' ) as pst_datetime,
					s.slot_start_time,
					case
					when n.timezoneid = 50 then (select a.availability_date  + s.slot_start_time::time - interval '6 hours')::date
					when n.timezoneid = 74 then (select a.availability_date  + s.slot_start_time::time - interval '5 hours')::date 
					when n.timezoneid = 152 then (select a.availability_date  + s.slot_start_time::time - interval '8 hours')::date
					  END as new_availability_dates,
				case
					when n.timezoneid = 50 then s.cst_slots 
					when n.timezoneid = 74 then s.est_slots
					when n.timezoneid = 152 then s.pst_slots
					  END as new_slotid,
				case
					when n.timezoneid = 50 then (select to_char(s.slot_start_time::time - interval '6 hours 00 minutes', 'hh12:mi:PM')::text)
					when n.timezoneid = 74 then (select to_char(s.slot_start_time::time - interval '5 hours 00 minutes', 'hh12:mi:PM')::text)
					when n.timezoneid = 152 then (select to_char(s.slot_start_time::time - interval '8 hours 00 minutes', 'hh12:mi:PM')::text)
					  END as new_slot_time
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
	  
	  end if;
		
	END;
$function$
;
