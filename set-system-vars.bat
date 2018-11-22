@echo off

SETX PD_DB_HOSTNAME "localhost"
SETX PD_DB_DATABASE "phoenix_distillery_prod"
SETX PD_DB_USERNAME "postgres"
SETX PD_DB_PASSWORD "postgres"

echo Variables-Setup successful!
echo DANGER - You need to relog your Windows-User, to use the variables!
