CREATE OR REPLACE FUNCTION app.ctm_get_ctm_profile(user_id integer)
 RETURNS TABLE(ctm_profile json)
 LANGUAGE plpgsql
AS $function$
declare 
	user_type_id int := (select user_typeid from app.users where userid  = user_id);
	cg_id int := (select ct.care_giverid from app.care_team_member ctm
left join app.care_team ct on ctm.team_id  = ct.team_id 
where userid =user_id);
	lo_id int := (select loved_oneid from app.loved_one lo where lo.care_giverid = cg_id);
	
begin
	return QUERY 
		
select
			row_to_json(t) as ctm_profile
				from(select 
					ctm.ctm_id,
					u.profile_pic_url as ctm_profile_pic,
					u.first_name as ctm_first_name,
					u.last_name as ctm_last_name,
					u.bio as mymantra,
					u.email,
					u.phone,
					u.zipcode,
					u.timezoneid ,
					u.user_genderid as genderid,
					(select array_agg(e.name) as ethnicity from unnest(u.ethnicityid) id 
					join meta.ethnicity e 
					on id.id = e.ethnicityid),
--					u.ethnicityid,
					(SELECT array_to_string((select u.ethnicityid from app.users u2 where u2.userid = user_id), ' ')) as ethnicityid,
					ug.gender_name as ctm_gender,
--					e.name as cg_ethnicity,
					gud.state,
					gud.city,
					to_char(
								u.user_dob,
								'DD-Mon-YYYY'
							) as cg_dob,
					(select row_to_json(nd) as navigator_data
					from
						(select n.navigatorid,
								u.profile_pic_url as nav_profile_pic,
								u.first_name as nav_first_name,
								u.last_name as nav_last_name,
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
									cg.care_giverid  = cg_id)nd) ,
					(select row_to_json(ld) as loved_one
					from 
						(select 
							lo.loved_oneid,
							lo.first_name,
							lo.last_name,
							lo.profile_pic_url,
--							lo.ethnicityid,
							(SELECT array_to_string((select lo.ethnicityid from app.loved_one lo where loved_oneid = lo_id), ' ')) as ethnicityid,
							to_char(
								lo.dob,
								'DD-Mon-YYYY'
							) as dob,
							gud.state,
							gud.city,
							ug.gender_name as loved_one_gender
							from
								app.loved_one lo
							join app.care_giver cg
								on cg.care_giverid = lo.care_giverid
							join app.users u 
								on u.userid = cg.userid	
							left join meta.geo_us_data gud
								on gud.zipcode = lo.zipcode
							left join meta.user_gender ug 
							on ug.user_genderid = lo.genderid
							where
								cg.care_giverid =cg_id
								)ld) as loved_one_data
				from  
					 	app.care_team_member ctm  
				    left join
				    	app.users u on ctm.userid = u.userid 
				    	
				    left join meta.geo_us_data gud
							on gud.zipcode = u.zipcode
					left join meta.user_gender ug 
							on ug.user_genderid = u.user_genderid
--					left join meta.ethnicity e 1433
--							on e.ethnicityid = u.ethnicityid 
				    where ctm.userid = user_id)t;
	
end;
$function$
;
