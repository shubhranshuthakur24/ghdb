CREATE OR REPLACE FUNCTION app.nav_create_resource(user_id integer, title_val text, info_val text, cost_val character varying, eligibility_val character varying, phone_val character varying, email_val character varying, website_url_val character varying, media_url_val character varying, banner_pic_url_val character varying, resource_typeid_val integer, media_formatid_val integer, duration_val integer, resource_tagid_val jsonb)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare 
nav_id int := (select navigatorid from app.navigator where userid = user_id);
begin
	insert into 
		app.resource(
					title,
					info,
					navigatorid,
					resource_typeid,
					inserted_by, 
					resource_tagid,
					cost,
					eligibility,
					phone,
					email,
					website_url, 
					media_url,
					banner_pic_url,
					media_formatid,
					duration,
					inserted_by,
					inserted_at)
	values(title_val, info_val, nav_id, resource_typeid_val, nav_id, resource_tagid_val, 
            cost_val, eligibility_val, phone_val, email_val, website_url_val, 
            media_url_val, banner_pic_url_val, media_formatid_val, duration_val, user_id, now());
end;
$function$
;
