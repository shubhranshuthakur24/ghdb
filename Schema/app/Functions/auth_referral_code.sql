CREATE OR REPLACE FUNCTION app.auth_referral_code(code character varying)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
declare
  cnt int := (select count(*) from meta.unique_program_code where upcode = code);
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
