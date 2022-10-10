CREATE OR REPLACE FUNCTION app.cg_get_nav_profile(user_id integer, nav_id integer)
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
		from
			app.navigator n
		join app.users u
			on u.userid = n.userid 
		join app.care_giver cg 
			on cg.navigatorid = n.navigatorid 
		left join meta.geo_us_data gud
			on gud.zipcode = u.zipcode
		where
			cg.userid = user_id 
			and n.navigatorid = nav_id;
	
end;
$function$
;
