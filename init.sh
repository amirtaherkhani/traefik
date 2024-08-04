# Try to get project root from current directory
PROJECT_ROOT=$(pwd)

mkdir -p ${PROJECT_ROOT}/src/certs
mkdir -p ${PROJECT_ROOT}/src/data/logs
mkdir -p ${PROJECT_ROOT}/src/volumes


if [ ! -f ${PROJECT_ROOT}/src/certs/acme.json ]; then
    touch "${PROJECT_ROOT}/src/certs/acme.json"
    chmod 600 ${PROJECT_ROOT}/src/certs/acme.json
else
    chmod 600 ${PROJECT_ROOT}/src/certs/acme.json
fi
echo "Files created successfully in ${PROJECT_ROOT}/src"
