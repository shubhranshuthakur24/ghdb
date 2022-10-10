CREATE OR REPLACE FUNCTION app.auth_users_post_sign_up_gvhealth_trial(user_id integer, ph_num character varying, firebase_id character varying, country_id integer, u_email character varying, signup_type character varying, user_type_id integer, f_name character varying, l_name character varying, code character varying)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
declare
return_user_id integer;
returning_care_giver_id integer;
primary_cg_user_id int;
--currency_id_user int  := (select currencyid from meta.currency where countryid = country_id);

up_id int := (select upid from meta.unique_program_code where upcode=code);
begin
	if signup_type = 'Phone' then
		INSERT INTO app.users
			(userid,
			phone,
			firebase_userid,
			inserted_at,
			countryid,
			user_typeid,
			first_name,
			last_name, 
			upid) values
			(user_id,
			ph_num,
			firebase_id,
			current_timestamp,
			country_id,
			user_type_id,
			f_name,
			l_name, up_id) returning userid into return_user_id;
		
		if user_type_id = 1 then
			INSERT into app.care_giver
			(userid, inserted_by) values
			(user_id, user_id) returning care_giverid into returning_care_giver_id;
			INSERT into app.loved_one
			(care_giverid) values
			(returning_care_giver_id);
		elseif user_type_id = 2 then
			INSERT into app.navigator
			(userid) values
			(user_id);
		elseif user_type_id = 4 then 
		update app.care_team_member set
		userid = user_id where ctm_id  = code::integer;
--			INSERT into app.care_giver
--			(userid, inserted_by) values
--			(user_id, user_id) returning care_giverid into returning_care_giver_id;
--			primary_cg_user_id = (select created_by from app.team_referral where upcode=code);
--			INSERT INTO app.loved_one
--			(care_giverid, inserted_by, updated_by, 
--			first_name, last_name, zipcode, genderid, signup_qaid, signupq_ans, 
--			dob, diseaseid, relationshipid, primary_insurance, secondary_insurance, 
--			primary_care_physician, hospital, phone, pharmacy, medication, profile_pic_url, 
--			long_term_insurance, priorities, more_info, allergy, ethnicityid)
--			select returning_care_giver_id, user_id, updated_by, 
--				first_name, last_name, zipcode, genderid, signup_qaid, signupq_ans, 
--				dob, diseaseid, relationshipid, primary_insurance, secondary_insurance, 
--				primary_care_physician, hospital, phone, pharmacy, medication, profile_pic_url, 
--				long_term_insurance, priorities, more_info, allergy, ethnicityid
--				from app.loved_one where care_giverid = (
--					select care_giverid from app.care_giver where userid = primary_cg_user_id
--			);

		else
			INSERT into app.care_manager
			(userid) values
			(user_id);
		end if;
	end if;
	
	if signup_type = 'Email' or signup_type ='Social_media' then
		INSERT INTO app.users
			(userid,
			email,
			firebase_userid,
			inserted_at,
			countryid,
			user_typeid,
			first_name,
			last_name, upid) values
			(user_id,
			u_email,
			firebase_id,
			current_timestamp,
			country_id,
			user_type_id,
			f_name,
			l_name, up_id) returning userid into return_user_id;
		if user_type_id = 1 then
			INSERT into app.care_giver
			(userid,
			inserted_by) values
			(user_id,
		user_id) returning care_giverid into returning_care_giver_id;
			INSERT into app.loved_one
			(care_giverid, inserted_by) values
			(returning_care_giver_id, user_id);
		elseif user_type_id = 2 then
			INSERT into app.navigator
			(userid,
			inserted_by) values
			(user_id, user_id);
		elseif user_type_id = 4 then 
		update app.care_team_member set
		userid = user_id where ctm_id = code::integer;
--			INSERT into app.care_giver
--			(userid, inserted_by) values
--			(user_id, user_id) returning care_giverid into returning_care_giver_id;
--		primary_cg_user_id = (select created_by from app.team_referral where upcode=code);
--			INSERT INTO app.loved_one
--			(care_giverid, inserted_by, updated_by, 
--			first_name, last_name, zipcode, genderid, signup_qaid, signupq_ans, 
--			dob, diseaseid, relationshipid, primary_insurance, secondary_insurance, 
--			primary_care_physician, hospital, phone, pharmacy, medication, profile_pic_url, 
--			long_term_insurance, priorities, more_info, allergy, ethnicityid)
--			select returning_care_giver_id, user_id, updated_by, 
--				first_name, last_name, zipcode, genderid, signup_qaid, signupq_ans, 
--				dob, diseaseid, relationshipid, primary_insurance, secondary_insurance, 
--				primary_care_physician, hospital, phone, pharmacy, medication, profile_pic_url, 
--				long_term_insurance, priorities, more_info, allergy, ethnicityid
--				from app.loved_one where care_giverid = (
--					select care_giverid from app.care_giver where userid = primary_cg_user_id
--			);
		else
			INSERT into app.care_manager
			(userid, inserted_by) values
			(user_id,user_id);
		end if;
	end if;	
	

	return return_user_id;

end;
$function$
;
