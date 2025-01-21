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

# Path for acme.json and traefik.yml
ACME_JSON="${PROJECT_ROOT}/src/certs/acme.json"
CONFIG_YAML="${PROJECT_ROOT}/src/configs/traefik.yml"
DYNAMIC_YAML="${PROJECT_ROOT}/src/configs/dynamic.yml"

# Check if acme.json, traefik.yml, or dynamic.yml exists, remove them if so
if [ -f "$ACME_JSON" ]; then
    rm "$ACME_JSON"
fi
if [ -f "$CONFIG_YAML" ]; then
    rm "$CONFIG_YAML"
fi
if [ -f "$DYNAMIC_YAML" ]; then
    rm "$DYNAMIC_YAML"
fi

# Create new acme.json, traefik.yml, and dynamic.yml files
touch "$ACME_JSON"
touch "$CONFIG_YAML"
touch "$DYNAMIC_YAML"

# Set permissions for the acme.json file to allow the owner to read/write
chmod 600 "$ACME_JSON"
chmod 600 "$CONFIG_YAML"
chmod 600 "$DYNAMIC_YAML"

# Create the traefik.yml configuration file in the configs directory
cat <<EOL > "$CONFIG_YAML"
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
  file:
    filename: ${PROJECT_ROOT}/src/configs/dynamic.yml
EOL


# Set permissions for the traefik.yml and dynamic.yml files
chmod 600 "$CONFIG_YAML"
chmod 600 "$DYNAMIC_YAML"

echo "Files created successfully in ${PROJECT_ROOT}/src"
