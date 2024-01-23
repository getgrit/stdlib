---
title: _Convert Oracle PL/SQL syntax into PL/pgSQL
---

This pattern combines several smaller patterns 

```grit
pattern add_unit_tests_for_datetime() {
   `CREATE PROCEDURE $proc_name($args) AS $decl $block;` where {
      $block <: contains r"extract",
   $file := `

   CREATE EXTENSION IF NOT EXISTS pgtap;
   BEGIN;
   SELECT plan(1);
   EXECUTE $proc_name(1, 0);
   SELECT ok(SELECT Trip_duration = End_time - Strt_time FROM TRIP_DETAILS WHERE Trip_id = 1);
   SELECT finish();
   ROLLBACK;
   `
   }
}
pattern convert_trigger() {
    create_trigger() as $trigger where {
        or {
            $trigger <: contains `update_driver_rating`  => `
CREATE OR REPLACE FUNCTION update_driver_rating() RETURNS TRIGGER AS $$
DECLARE
   v_driver_id INT;
BEGIN
   IF NEW.Message LIKE '%Bad Driver%' THEN
      SELECT driver_id INTO v_driver_id FROM TRIP_DETAILS WHERE trip_id = NEW.Trip_id;
      UPDATE DRIVER SET Rating = Rating -1 WHERE driver_id = v_driver_id;
   END IF;
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_driver_rating_trigger
AFTER INSERT ON FEEDBACK
FOR EACH ROW EXECUTE FUNCTION update_driver_rating();
`,
            $trigger <: contains `add_no_of_cars`  => `
            CREATE OR REPLACE FUNCTION add_no_of_cars() RETURNS TRIGGER AS $$
DECLARE
   v_no_of_cars INT;
BEGIN
   SELECT count(Taxi_id) INTO v_no_of_cars FROM OWNER_TAXI WHERE Owner_id = NEW.Owner_id GROUP BY Owner_id;
   NEW.No_Cars := v_no_of_cars;
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER add_no_of_cars_trigger
BEFORE INSERT OR UPDATE ON OWNS
FOR EACH ROW EXECUTE FUNCTION add_no_of_cars()
`
        }
    }
}
convert_trigger()
```

## Example

sql```
---------------------------------------------
-- Trigger  Creation 1
---------------------------------------------

CREATE OR REPLACE TRIGGER UPDATE_DRIVER_RATING 
AFTER INSERT  ON FEEDBACK 
FOR EACH ROW 
WHEN (NEW.Message like '%Bad Driver%' ) 
DECLARE 
   v_driver_id INT; 
BEGIN 
   select driver_id into v_driver_id from TRIP_DETAILS where trip_id = :NEW.Trip_id;
   
   update DRIVER set Rating = Rating -1 where   driver_id = v_driver_id;
END; 

---------------------------------------------
-- Trigger  Creation 2
---------------------------------------------
CREATE OR REPLACE TRIGGER  ADD_NO_OF_CARS 
BEFORE INSERT OR UPDATE ON OWNS
FOR EACH ROW 
DECLARE 
   v_no_of_cars INT; 
BEGIN
   select count(Taxi_id) into v_no_of_cars from OWNER_TAXI where Owner_id = :NEW.Owner_id group by Owner_id;
   :NEW.No_Cars := v_no_of_cars;
END;

```

sql```
---------------------------------------------
-- Trigger  Creation 1
---------------------------------------------

CREATE OR REPLACE FUNCTION update_driver_rating() RETURNS TRIGGER AS $$
DECLARE
   v_driver_id INT;
BEGIN
   IF NEW.Message LIKE '%Bad Driver%' THEN
      SELECT driver_id INTO v_driver_id FROM TRIP_DETAILS WHERE trip_id = NEW.Trip_id;
      UPDATE DRIVER SET Rating = Rating -1 WHERE driver_id = v_driver_id;
   END IF;
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

---------------------------------------------
-- Trigger  Creation 2
---------------------------------------------
CREATE TRIGGER update_driver_rating_trigger
AFTER INSERT ON FEEDBACK
FOR EACH ROW EXECUTE FUNCTION update_driver_rating();

-- Trigger 2
CREATE OR REPLACE FUNCTION add_no_of_cars() RETURNS TRIGGER AS $$
DECLARE
   v_no_of_cars INT;
BEGIN
   SELECT count(Taxi_id) INTO v_no_of_cars FROM OWNER_TAXI WHERE Owner_id = NEW.Owner_id GROUP BY Owner_id;
   NEW.No_Cars := v_no_of_cars;
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER add_no_of_cars_trigger
BEFORE INSERT OR UPDATE ON OWNS
FOR EACH ROW EXECUTE FUNCTION add_no_of_cars();

```