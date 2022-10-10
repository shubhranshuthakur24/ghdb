-- app.vw_user_initial_data source

CREATE OR REPLACE VIEW app.vw_user_initial_data
AS SELECT 'Gv Health Support'::text AS support_name,
    'https://phyzio.s3.amazonaws.com/logos/phyzio_favicon.png'::text AS support_profile_pic_url,
    'rWHs4q7PBgJ0plXbxJ35'::text AS support_firebaseid,
    ug.gender_name,
    u.lang_id,
    u.is_otp_verified,
    u.phone,
    u.email,
    cl.phone_code,
    u.userid,
    cl.sortname AS country_code,
    u.countryid,
    u.first_name,
    u.last_name,
    u.profile_pic_url,
    u.user_typeid,
    u.firebase_userid,
    true AS is_firebase_chat,
    COALESCE(ud.is_active, false) AS notification_active,
    cg.care_giverid
   FROM app.users u
     LEFT JOIN meta.country cl ON cl.countryid = u.countryid
     LEFT JOIN app.user_device ud ON ud.userid = u.userid AND ud.is_active = true
     LEFT JOIN meta.user_gender ug ON ug.user_genderid = u.user_genderid
     LEFT JOIN app.care_giver cg ON cg.userid = u.userid;