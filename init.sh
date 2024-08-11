PROJECT_ROOT=$(pwd)
# Remove the src directory if it exists
if [ -d "${PROJECT_ROOT}/src" ]; then
    sudo rm -rf "${PROJECT_ROOT}/src"
fi

# Create the required directories with proper permissions
mkdir -p ${PROJECT_ROOT}/src/certs
mkdir -p ${PROJECT_ROOT}/src/data/logs
mkdir -p ${PROJECT_ROOT}/src/configs

# Set permissions for the certs and logs directories to allow the owner to read/write
chmod 700 ${PROJECT_ROOT}/src/certs
chmod 700 ${PROJECT_ROOT}/src/data/logs

# Path for acme.json
ACME_JSON="${PROJECT_ROOT}/src/certs/acme.json"
CONFIG_YAML="${PROJECT_ROOT}/src/configs/traefik.yml"
# Check if acme.json exists, remove it if so
if [ -f "$ACME_JSON" ]; then
    rm "$ACME_JSON"
fi
if [ -f "$CONFIG_YAML" ]; then
    rm "$CONFIG_YAML"
fi
# Create a new acme.json file
touch "$ACME_JSON"
touch "$CONFIG_YAML"
# Set permissions for the acme.json file to allow the owner to read/write
chmod 600 "$ACME_JSON"
chmod 600 "$CONFIG_YAML"
# Create the traefik.yml configuration file in the configs directory
TRAFFIC_YML="${PROJECT_ROOT}/src/configs/traefik.yml"
cat <<EOL > "$TRAFFIC_YML"
# Traefik configuration
global:
  checkNewVersion: true
  sendAnonymousUsage: false

log:
  level: INFO  # WARN
  format: json
  # filePath: /var/log/traefik/traefik.log

accesslog:
  format: json
  filePath: /var/log/traefik/access.log

middlewares:
  admin-auth:
    basicAuth:
      users:
        - "admin:yourpasswd"

api:
  insecure: false
  dashboard: true

entryPoints:
  web:
    address: ":80"
    http:
      redirections:
        entryPoint:
          to: websecure
          scheme: https
  websecure:
    address: ":443"
    
  postgres:
    address: ":5432"

certificatesResolvers:
  letsencrypt:
    acme:
      email: yourmail
      storage: /etc/traefik/certs/acme.json
      caServer: "https://acme-v02.api.letsencrypt.org/directory"
      httpChallenge:
        entryPoint: web

providers:
  docker:
    endpoint: "unix:///var/run/docker.sock"
    exposedByDefault: false
EOL

# Set permissions for the traefik.yml file to allow the owner to read/write
chmod 600 "$TRAFFIC_YML"

echo "Files created successfully in ${PROJECT_ROOT}/src"
