# Try to get project root from current directory
PROJECT_ROOT=$(dirname "$(pwd)")

mkdir -p ${PROJECT_ROOT}/src/certs
mkdir -p ${PROJECT_ROOT}/src/data/logs
mkdir -p ${PROJECT_ROOT}/src/volumes

# Create the files (replace with your desired filenames)
touch "${PROJECT_ROOT}/src/certs/acme.json"
echo "Files created successfully in ${PROJECT_ROOT}/src"
