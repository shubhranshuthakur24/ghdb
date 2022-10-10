CREATE OR REPLACE FUNCTION app.nav_get_hours_markings(user_id integer, calendar_date character varying)
 RETURNS TABLE(marking_data json)
 LANGUAGE plpgsql
AS $function$
DECLARE
timezone int := (select timezoneid from app.navigator where userid = user_id );

--new_date date := (select case when timezone = 50 then (SELECT date(calendar_date::date - interval '6 hours'))
--							  when timezone = 74 then (SELECT date(calendar_date::date - interval '5 hours'))
--							  when timezone = 152 then (SELECT date(calendar_date::date - interval '8 hours'))end);
							 
new_date_part int := (select case (select extract(dow from date (calendar_date))) when 0 then 7 else (select extract(dow from date (calendar_date))) end);

first_slot int := (select CONCAT (new_date_part::text, '0000')::integer);
	BEGIN
		if new_date_part <7 then
		return QUERY 
		select array_to_json(array_agg(row_to_json(md))) as marking_data from(
							select
								s.slotid,
--								s.date_part,
									case
					when s.date_part = new_date_part then calendar_date::date
					when s.date_part  != new_date_part then (SELECT date(calendar_date::date + interval '1 day'))
					  END as new_availability_date,
								case
					when timezone = 50 then(select to_char(s.slot_start_time::time - interval '6 hours 00 minutes', 'hh12:mi PM')::text)
					when timezone = 74 then(select to_char(s.slot_start_time::time - interval '5 hours 00 minutes', 'hh12:mi PM')::text)
					when timezone = 152 then(select to_char(s.slot_start_time::time - interval '5 hours 00 minutes', 'hh12:mi PM')::text)
					END as new_slot_start_time,
					case
					when timezone = 50 then(select to_char(s.slot_end_time::time - interval '6 hours 00 minutes', 'hh12:mi PM')::text)
					when timezone = 74 then(select to_char(s.slot_end_time::time - interval '5 hours 00 minutes', 'hh12:mi PM')::text)
					when timezone = 152 then(select to_char(s.slot_end_time::time - interval '5 hours 00 minutes', 'hh12:mi PM')::text)
					END as new_slot_end_time
							from
								meta.slot s
							where
								first_slot <= (select case
					when timezone = 50 then s.cst_slots
					when timezone = 74 then s.est_slots
					when timezone = 152 then s.pst_slots
					  END) 
					  and
--					  s.date_part = (new_date_part)apply below when datepart is not 7
					  (s.date_part = new_date_part  or s.date_part = (new_date_part + 1)) 
--					  and s.date_part = (select case new_date_part when 0 then 7 else new_date_part end)
					 order by s.date_part limit 24)md;
					
		else     
		
		return QUERY 
		select array_to_json(array_agg(row_to_json(md))) as marking_data from(
							select
								s.slotid,
--								s.date_part,
								case
					when s.date_part = new_date_part then calendar_date::date 
					when s.date_part  != new_date_part then (SELECT date(calendar_date::date + interval '1 day'))
					  END as new_availability_date,
--									case
--					when timezone = 50 then s.cst_slots 
--					when timezone = 74 then s.est_slots
--					when timezone = 152 then s.pst_slots
--					  END as new_slotid,
								case
					when timezone = 50 then(select to_char(s.slot_start_time::time - interval '6 hours 00 minutes', 'hh12:mi PM')::text)
					when timezone = 74 then(select to_char(s.slot_start_time::time - interval '5 hours 00 minutes', 'hh12:mi PM')::text)
					when timezone = 152 then(select to_char(s.slot_start_time::time - interval '5 hours 00 minutes', 'hh12:mi PM')::text)
					END as new_slot_start_time,
					case
					when timezone = 50 then(select to_char(s.slot_end_time::time - interval '6 hours 00 minutes', 'hh12:mi PM')::text)
					when timezone = 74 then(select to_char(s.slot_end_time::time - interval '5 hours 00 minutes', 'hh12:mi PM')::text)
					when timezone = 152 then(select to_char(s.slot_end_time::time - interval '5 hours 00 minutes', 'hh12:mi PM')::text)
					END as new_slot_end_time
							from
								meta.slot s
							where
								first_slot <= (select case
					when timezone = 50 then s.cst_slots
					when timezone = 74 then s.est_slots
					when timezone = 152 then s.pst_slots
					  END) 
--					  and
--					  s.date_part = (new_date_part)apply below when datepart is not 7
--					  (s.date_part = new_date_part  or s.date_part = (new_date_part + 1)) 
--					  and s.date_part = (select case new_date_part when 0 then 7 else new_date_part end)
					 order by s.date_part limit 24)md;
					
		end if;
		
	END;
$function$
;
