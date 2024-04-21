declare -a tables
tables="$(./run_sql.sh SHOW TABLES )"
echo $tables
for i in $tables 
do
  echo $i ...
  echo -e "$(./run_sql.sh DROP TABLE $i )" >"$i.sql.log"
done
echo OK