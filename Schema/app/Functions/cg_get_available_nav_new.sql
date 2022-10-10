CREATE OR REPLACE FUNCTION app.cg_get_available_nav_new(user_id integer)
 RETURNS TABLE(navigatorid integer, bio text, profile_pic_url character varying, first_name character varying, last_name character varying, firebase_userid character varying, state character varying, city character varying, disease_score bigint, common_relationship_score bigint, common_zipcode bigint, total_score bigint)
 LANGUAGE plpgsql
AS $function$
begin
	return QUERY 
		SELECT n.navigatorid,
			n.bio,
			u.profile_pic_url,
			u.first_name,
			u.last_name,
			u.firebase_userid,
			gud.state,
			gud.city,
			x.disease_score,
		((select count(*) FILTER (WHERE (select lo.relationshipid from app.loved_one lo 
			left join app.care_giver cg on cg.care_giverid = lo.care_giverid 
			where userid = user_id) = (n.relationshipid ))  )*4 )as common_relationship_score,
		((select count(*) FILTER 
		(WHERE (select u.zipcode from app.users u where userid =user_id)
		=(select u2.zipcode from app.users u2 where u2.userid = n.userid ))  )*3 ) as common_zipcode,
		((select count(*) FILTER (WHERE (select lo.relationshipid from app.loved_one lo 
			left join app.care_giver cg on cg.care_giverid = lo.care_giverid 
			where userid = user_id) = (n.relationshipid ))  )*4 )+((select count(*) FILTER 
		(WHERE (select u.zipcode from app.users u where userid =user_id)
		=(select u2.zipcode from app.users u2 where u2.userid = n.userid ))  )*3 )+x.disease_score as total_score
			FROM   app.navigator n
			left join app.users u
			on u.userid = n.userid 
		left join meta.geo_us_data gud
			on gud.zipcode = u.zipcode
   		  , LATERAL (
   			SELECT count(*)*5 AS disease_score
  		 FROM   unnest(n.diseaseid) uid
   		WHERE  uid = ANY((select unnest(lod) from (select array( select
			jsonb_array_elements(diseaseid)::int as diseases
		from
			app.loved_one lo 
			left join app.care_giver cg on cg.care_giverid = lo.care_giverid 
		where
			userid = user_id) as lod)ld))
			   ) x where n.is_active = true
			group by n.navigatorid,n.bio,u.profile_pic_url,u.first_name,u.last_name,u.firebase_userid,gud.state,gud.city,x.disease_score
			ORDER  BY Total_score desc limit 3;
	
end;
$function$
;
