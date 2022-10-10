-- app.vw_get_nav_available_slots source

CREATE OR REPLACE VIEW app.vw_get_nav_available_slots
AS SELECT na.availability_date,
    na.available_slot,
    na.navigatorid AS navid
   FROM app.nav_availability na;