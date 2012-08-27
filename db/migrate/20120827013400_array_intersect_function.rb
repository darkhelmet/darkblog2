class ArrayIntersectFunction < ActiveRecord::Migration
  def up
    sql = <<-SQL
      CREATE OR REPLACE FUNCTION array_intersect(anyarray, anyarray)
      RETURNS anyarray
      LANGUAGE sql
      AS $FUNCTION$
        SELECT ARRAY(
          SELECT UNNEST($1)
          INTERSECT
          SELECT UNNEST($2)
        );
      $FUNCTION$
    SQL
    ActiveRecord::Base.connection.execute(sql)
  end

  def down
  end
end
