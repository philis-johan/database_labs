## Connect
psql -U postgres

## create database
postgres: create database NAME;

## Connect to database portal (make sure to create it first)
psql -v ON_ERROR_STOP=1 -U postgres portal
