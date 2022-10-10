CREATE OR REPLACE FUNCTION app.ctm_cg_team_member_details_new(user_id integer)
 RETURNS TABLE(care_giver_data json)
 LANGUAGE plpgsql
AS $function$
declare
	ctmid int := (select ctm_id from app.care_team_member where userid = user_id);
	cg_id int := (	select care_giverid from app.care_team_member   
	left join app.team_n  on app.team_n.team_id =app.care_team_member.team_id 
	where ctm_id =ctmid);
	nav_id int := (select navigatorid from app.care_giver cg1 where cg1.care_giverid = cg_id);
begin
	return QUERY 
select
	row_to_json(t) as care_giver_data
from(
select ctm.ctm_id,
ctm.team_id,
ctm.roleid,ctm.saved_toolkit,
u.userid ,
u.first_name ,
-- 108
u.user_genderid as genderid,
		(select array_agg(e.name) as ethnicity from unnest(u.ethnicityid) id 
			join meta.ethnicity e 
			on id.id = e.ethnicityid),
		u.ethnicityid, 
		coalesce( u.last_name,'') as ctm_last_name,
		coalesce( u.bio,'')as ctm_mantra,
		(select count(un.user_notificationid) from app.user_notification un where un.userid = user_id and un.is_archive = false) as notification_count,
		(select count(un.red_flag) from app.user_notification un where un.userid = user_id and is_archive = false and red_flag = true) as unread_notification_count,
		
(select row_to_json(ld)as lovedone_data
from(
select lo.loved_oneid from app.loved_one lo where 
care_giverid = cg_id
)ld
),
(select row_to_json(nd)as navigator_data
from
	(select n.navigatorid ,
			n.timezoneid,
			n.meeting_url,
			(select array_agg(e.name) as ethnicity from unnest(u.ethnicityid) id 
				join meta.ethnicity e 
				on id.id = e.ethnicityid),
			u1.ethnicityid,
			u1.email as nav_email,
            u1.profile_pic_url as nav_profile_pic,
            u1.userid as nav_userid,
            u1.firebase_userid as nav_firebaseid,
            u1.first_name as nav_first_name,
            u1.last_name as nav_last_name,
            u1.firebase_userid,
            u1.user_genderid as genderid,
	n.bio ,
	u1.userid ,
	u1.first_name ,
	u1.last_name ,
	u1.email as navigator_email 
	from 
app.navigator n
left join app.users u1 on n.userid = u1.userid
where n.navigatorid=nav_id 
) nd),
(
select  coalesce( array_to_json( array_agg( row_to_json(td)) ), '[]' ) task_data from(
select t.taskid,
t.task_info
from app.task t
where userid=1114)td
)
from app.care_team_member ctm 
left join app.users u on ctm.userid = u.userid 
where ctm.userid = user_id

)t;

end;
$function$
;
