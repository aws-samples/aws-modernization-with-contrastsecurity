#!/bin/sh

# Defaults
CONTRAST_APP_NAME=WebGoat

# Template value insertion
sed -e "s~\${url}~$CONTRAST_URL~" -e "s~\${api_key}~$CONTRAST_API_KEY~" -e "s~\${service_key}~$CONTRAST_SERVICE_KEY~" -e "s~\${user_name}~$CONTRAST_USER_NAME~" -e "s~\${app_name}~$CONTRAST_APP_NAME~" /opt/contrast/contrast_security.yaml.tpl > /opt/contrast/contrast_security.yaml

# Set Contrast environment variables
export CONTRAST_CONFIG_PATH="/opt/contrast/contrast_security.yaml"
export JAVA_TOOL_OPTIONS="\
-javaagent:/opt/contrast/contrast.jar \
-Dcontrast.standalone.appname=${CONTRAST_APP_NAME} \
-Dcontrast.defend.rep=true \
-Dcontrast.defend.parameters.json=true"

# Run WebGoat
java -jar webgoat-container-7.1-war-exec.jar $@
