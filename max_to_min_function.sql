CREATE OR REPLACE FUNCTION max_to_min(table_name REGCLASS, column_name TEXT, format_type TEXT)

RETURNS TEXT AS
$$

    DECLARE

        sub_table_name regclass;
        n_max BIGINT:= NULL;
        n_min BIGINT:= NULL;
        n_temp_result TEXT;
        n_max_temp BIGINT;
        n_min_temp BIGINT;

    BEGIN

     EXECUTE 'SELECT MAX(' || column_name || ') FROM ONLY ' || table_name INTO n_max;

     EXECUTE 'SELECT MIN(' || column_name || ') FROM ONLY ' || table_name INTO n_min;

     FOR sub_table_name IN SELECT inhrelid FROM pg_inherits WHERE inhparent = table_name

     LOOP

         n_temp_result := max_to_min(table_name, column_name);
         n_max_temp := SPLIT_PART(n_temp_result, ' -> ', 1)::BIGINT;
         n_min_temp := SPLIT_PART(n_temp_result, ' -> ', 2)::BIGINT;
         n_max := GREATEST(n_max_temp, n_max);
         n_min := LOWEST(n_min_temp, n_min);

         END LOOP;

         IF n_max IS NULL THEN

             RETURN 'no value found in column ' || column_name;

         ELSE

             IF format_type = 'record' THEN

                 RETURN CAST(ROW(n_max, n_min) AS TEXT);
             
             ELSE

                 RETURN n_max || ' -> ' || n_min;
             
             END IF;

         END IF;          

     END;

$$ LANGUAGE plpgsql STRICT;
