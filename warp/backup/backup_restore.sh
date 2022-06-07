#Backup
pg_dumpall -c -U postgres > dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql

#Restore
psql -U postgres -f dump_date.sql
