CREATE OR REPLACE FUNCTION app.auth_referral_code_old(code character varying)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
declare
  cnt int := (select count(*) from meta.user_referral where referral_code = code);
begin 
	case 
		when cnt = 1 then
		return 'success';
	else
	  return 'failure';
	end case;
end
$function$
;
