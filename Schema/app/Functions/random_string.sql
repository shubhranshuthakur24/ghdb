CREATE OR REPLACE FUNCTION app.random_string(input_length integer)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
declare
  chars text[] := '{0,1,2,3,4,5,6,7,8,9}';
  result text := '';
  i integer := 0;
begin
  if input_length < 0 then
    raise exception 'Given length cannot be less than 0';
  end if;
  for i in 1..input_length loop
    result := result || chars[1+random()*(array_length(chars, 1)-1)];
  end loop;
  return result;
end;
$function$
;
