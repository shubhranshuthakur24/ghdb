CREATE OR REPLACE FUNCTION app.nav_get_cg_meetings_devlp(userid integer, cgid integer)
 RETURNS TABLE(meetingid integer, navigatorid integer, care_giverid integer, meeting_typeid integer, meeting_date text, availabilityid integer, is_archive boolean, cancel_reason text, cancelled_by integer, slotid integer, navigator_note character varying, meeting_link character varying, cg_contact_detail character varying, meeting_type_name text)
 LANGUAGE plpgsql
AS $function$
declare 
cg_userid int := (select cg.userid from app.care_giver cg where cg.care_giverid = cgid);
begin
	return QUERY 
		select m.meetingid,
			   m.navigatorid,
			   m.care_giverid,
			   m.meeting_typeid,
			   a.availability_date  :: text,
			   m.availabilityid,
			   m.is_archive,
			   m.cancel_reason,
			   m.cancelled_by,
			   m.slotid,
			   m.navigator_note,
			   m.meeting_link,
			   u.phone as cg_contact_detail,
			   mt.meeting_type_name 
			from 
				app.meeting m
				join app.nav_availability a 
				on a.nav_availabilityid = m.nav_availabilityid 
				left join app.meeting_type mt 
				on mt.meeting_typeid = m.meeting_typeid
				left join app.users u
				on u.userid = cg_userid
			where m.care_giverid = cgid and m.is_archive =false order by m.is_archive asc, a.availability_date desc ;
end;
$function$
;
