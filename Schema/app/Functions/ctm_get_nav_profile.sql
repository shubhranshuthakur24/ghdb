CREATE OR REPLACE FUNCTION app.ctm_get_nav_profile(user_id integer)
 RETURNS TABLE(navigatorid integer, bio text, profile_pic_url character varying, first_name character varying, last_name character varying, phone character varying, firebase_userid character varying, state character varying, city character varying)
 LANGUAGE plpgsql
AS $function$
begin
	return QUERY 
		select 
			n.navigatorid,
			n.bio,
			u.profile_pic_url,
			u.first_name,
			u.last_name,
			u.phone,
			u.firebase_userid,
			gud.state,
			gud.city
		from app.care_team_member ctm 
		left join app.care_team ct on ctm.team_id =ct.team_id 
		left join app.care_giver cg on ct.care_giverid = cg.care_giverid 
		left join app.navigator n on cg.navigatorid = n.navigatorid 
		left join app.users u on n.userid = u.userid 
		left join meta.geo_us_data gud
			on u.zipcode = gud.zipcode
		where ctm.userid = user_id;
	
end;
$function$
;
