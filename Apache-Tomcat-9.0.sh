#!/usr/bin/env bash
set -o pipefail

help() {
  # Display Help
  echo "Apache Tomcat 9.0 Security Benchmark Tests Report."
  echo
  echo "Syntax: Apache-Tomcat-9.0.sh [OPTIONS]"
  echo "OPTIONS:"
  echo "    -f FILE     Stores report output in the given file location."
  echo
}

VERSION="0.0.3"
OUTPUT_FILE="Apache_Tomcat_9.0.txt"

options=":hfv"
while getopts ${options} option; do
  case $option in
  h) # display Help
    help
    exit 1
    ;;
  f) # Redirect output
    OUTPUT_FILE=$OPTARG
    ;;
  v) # Version output
    echo "Apache-Tomcat-9.0 - Security Benchmark Tests Report"
    echo "version: $VERSION"
    echo "license: MIT License"
    echo "website: https://github.com/Virtimo/apache-tomcat-9.0-CIS-Benchmark-script"
    exit
    ;;
  \?) # Invalid option
    echo "Error: Invalid option"
    help
    exit 1
    ;;
  esac
done

echo "##########################################"
echo "Apache Tomcat 9.0 Security Benchmark Tests"
echo "##########################################"
echo ""
echo "Checking preconditions..."
echo ""

if [[ -z ${CATALINA_BASE} ]]; then
  echo "ERROR: \$CATALINA_BASE must be set!"
  exit 1
fi
echo "\$CATALINA_BASE is set to: $CATALINA_BASE"

if [[ -z ${CATALINA_HOME} ]]; then
  echo "ERROR: \$CATALINA_HOME must be set!"
  exit 1
fi
echo "\$CATALINA_HOME is set to: $CATALINA_HOME"

while true; do
  echo ""
  echo -n "Enter the APP name located in the following directory/format \$CATALINA_HOME/webapps/<App_name>/WEB-INF/web.xml: "
  read -r APP

  WEB_XML=$CATALINA_HOME/webapps/$APP/WEB-INF/web.xml
  exists=$(ls -al "$WEB_XML" 2>&1)
  existsFlag=$(echo "$exists" | grep "No such file")
  if [[ -z "$existsFlag" ]]; then
    break
  fi
  echo "ERROR: The file $location does not exist. Type again"
done

while true; do
  echo ""
  echo -n "Enter the APP Engine name located in the following directory/format \$CATALINA_BASE/conf/<engine_name>/<host_name>: "
  read -r ENGINE_NAME
  echo -n "Enter the Host name located in the following directory/format \$CATALINA_BASE/conf/<engine_name>/<host_name>: "
  read -r HOSTNAME

  location=$CATALINA_HOME/conf/$ENGINE_NAME/$HOSTNAME
  exists=$(ls -al "$location" 2>&1)
  existsFlag=$(echo "$exists" | grep "No such file")
  if [[ -z "$existsFlag" ]]; then
    break
  fi
  echo "ERROR: The folder $location does not exist. Type again"
done
echo ""

SERVER_XML=$CATALINA_HOME/conf/server.xml
if [[ ! -f "$SERVER_XML" ]]; then
  echo "ERROR: File not found: $SERVER_XML. Is \$CATALINA_HOME set correctly?"
  exit 1
fi

CONTEXT_XML=$CATALINA_BASE/webapps/$APP/META-INF/context.xml

echo ""
echo "Start security benchmark tests..."
echo ""

echo "" >$OUTPUT_FILE
{
  echo "=========================================================================================="
  echo "|                       Apache Tomcat 9.0 CIS Benchmark v1.0.0 Script                    |"
  echo "=========================================================================================="
  echo ""
  echo "CATALINA_HOME: $CATALINA_HOME"
  echo "CATALINA_BASE: $CATALINA_BASE"
  echo ""
  echo "=========================================================================================="
  echo "1.1 Remove extraneous files and directories"
} >>$OUTPUT_FILE

directory=$CATALINA_HOME/webapps/examples
if [[ -d "$directory" ]]; then
  echo "BAD: Directory ${directory} found." >>$OUTPUT_FILE
  ls -l "$directory" >>$OUTPUT_FILE
else
  echo "GOOD: Directory ${directory} not found." >>$OUTPUT_FILE
fi

directory=$CATALINA_HOME/webapps/docs
if [[ -d "$directory" ]]; then
  echo "BAD: Directory ${directory} found." >>$OUTPUT_FILE
  ls -l "$directory" >>$OUTPUT_FILE
else
  echo "GOOD: Directory ${directory} not found." >>$OUTPUT_FILE
fi

directory=$CATALINA_HOME/webapps/ROOT
if [[ -d "$directory" ]]; then
  echo "BAD: Directory ${directory} found." >>$OUTPUT_FILE
  ls -l "$directory" >>$OUTPUT_FILE
else
  echo "GOOD: Directory ${directory} not found." >>$OUTPUT_FILE
fi

directory=$CATALINA_HOME/webapps/host-manager
if [[ -d "$directory" ]]; then
  echo "BAD: Directory ${directory} found." >>$OUTPUT_FILE
  ls -l "$directory" >>$OUTPUT_FILE
else
  echo "GOOD: Directory ${directory} not found." >>$OUTPUT_FILE
fi

directory=$CATALINA_HOME/webapps/manager
if [[ -d "$directory" ]]; then
  echo "BAD: Directory ${directory} found." >>$OUTPUT_FILE
  ls -l "$directory" >>$OUTPUT_FILE
else
  echo "GOOD: Directory ${directory} not found." >>$OUTPUT_FILE
fi

{
  echo ""
  echo "=========================================================================================="
  echo "1.2 Disable Unused Connectors"
  echo "=========================================================================================="
  grep -H "Connector" "$SERVER_XML"

  # Skip if JAR command is missing
  if command -v jar >/dev/null; then
    echo ""
    echo "=========================================================================================="
    echo "2.1 Alter the Advertised server.info String"
    echo "=========================================================================================="
    jar xf "$CATALINA_HOME/lib/catalina.jar" org/apache/catalina/util/ServerInfo.properties
    grep -H "server.info" org/apache/catalina/util/ServerInfo.properties
    rm -rf org

    echo ""
    echo "=========================================================================================="
    echo "2.2 Alter the Advertised server.number String "
    echo "=========================================================================================="
    jar xf "$CATALINA_HOME/lib/catalina.jar" org/apache/catalina/util/ServerInfo.properties
    grep -H "server.number" org/apache/catalina/util/ServerInfo.properties
    rm -rf org

    echo ""
    echo "=========================================================================================="
    echo "2.3 Alter the Advertised server.built Date"
    echo "=========================================================================================="
    jar xf "$CATALINA_HOME/lib/catalina.jar" org/apache/catalina/util/ServerInfo.properties
    grep -H "server.built" org/apache/catalina/util/ServerInfo.properties
    rm -rf org
  else
    echo "JAR command not found. Install it to apply further checks inside of Tomcat's catalina.jar."
  fi

  echo ""
  echo "=========================================================================================="
  echo "2.4 Disable X-Powered-By HTTP Header and Rename the Server Value for all Connectors"
  echo "=========================================================================================="
  echo "Manual Test Required"

  echo ""
  echo "=========================================================================================="
  echo "2.5 Disable client facing Stack Traces"
  echo "=========================================================================================="
  echo "Manual Test Required"

  echo ""
  echo "=========================================================================================="
  echo "2.6 Turn off TRACE"
  echo "=========================================================================================="
  echo "Manual Test Required"

  echo ""
  echo "=========================================================================================="
  echo "2.6 Turn off TRACE"
  echo "=========================================================================================="
  echo "Manual Test Required"

  echo ""
  echo "=========================================================================================="
  echo "2.7 Ensure Sever Header is Modified To Prevent Information Disclosure"
  echo "=========================================================================================="
  echo "Manual Test Required"

  echo ""
  echo "=========================================================================================="
  echo "3.1 Set a nondeterministic Shutdown command value "
  echo "=========================================================================================="
  grep -H 'shutdown[[:space:]]*=[[:space:]]*"SHUTDOWN"' "$SERVER_XML"

  echo ""
  echo "=========================================================================================="
  echo "3.2 Disable the Shutdown port "
  echo "=========================================================================================="
  grep -H '<Server[[:space:]]\+[^>]*port[[:space:]]*=[[:space:]]*"-1"' "$SERVER_XML"

  echo "It is recommended that the ownership of \$CATALINA_HOME be tomcat_admin:tomcat"
  echo "It is recommended that the ownership of \$CATALINA_BASE be tomcat_admin:tomcat"
  if groups "tomcat_admin" | grep -q "\btomcat\b" >/dev/null; then
    echo ""
    echo "=========================================================================================="
    echo "4.1 Restrict access to $CATALINA_HOME"
    echo "=========================================================================================="
    find "$CATALINA_HOME" -follow -maxdepth 0 \( -perm o+rwx,g=w -o ! -user tomcat_admin -o ! -group tomcat \) -ls

    echo ""
    echo "=========================================================================================="
    echo "4.2 Restrict access to $CATALINA_BASE"
    echo "=========================================================================================="
    find "$CATALINA_BASE" -follow -maxdepth 0 \( -perm o+rwx,g=w -o ! -user tomcat_admin -o ! -group tomcat \) -ls

    echo ""
    echo "=========================================================================================="
    echo "4.3 Restrict access to Tomcat configuration directory"
    echo "=========================================================================================="
    find "$CATALINA_HOME/conf" -maxdepth 0 \( -perm o+rwx,g=w -o ! -user tomcat_admin -o ! -group tomcat \) -ls

    echo ""
    echo "=========================================================================================="
    echo "4.4 Restrict access to Tomcat logs directory"
    echo "=========================================================================================="
    if [[ -d "$CATALINA_HOME/logs" ]]; then
      find "$CATALINA_HOME/logs" -follow -maxdepth 0 \( -perm o+rwx -o ! -user tomcat_admin -o ! -group tomcat \) -ls
    else
      echo "Skip: Folder not found: $CATALINA_HOME/logs"
    fi

    echo ""
    echo "=========================================================================================="
    echo "4.5 Restrict access to Tomcat temp directory "
    echo "=========================================================================================="
    find "$CATALINA_HOME/temp" -follow -maxdepth 0 \( -perm o+rwx -o ! -user tomcat_admin -o ! -group tomcat \) -ls

    echo ""
    echo "=========================================================================================="
    echo "4.6 Restrict access to Tomcat binaries directory "
    echo "=========================================================================================="
    find "$CATALINA_HOME/bin" -follow -maxdepth 0 \( -perm o+rwx,g=w -o ! -user tomcat_admin -o ! -group tomcat \) -ls

    echo ""
    echo "=========================================================================================="
    echo "4.7 Restrict access to Tomcat web application directory "
    echo "=========================================================================================="
    find "$CATALINA_HOME/webapps" -follow -maxdepth 0 \( -perm o+rwx,g=w -o ! -user tomcat_admin -o ! -group tomcat \) -ls

    echo ""
    echo "=========================================================================================="
    echo "4.8 Restrict access to Tomcat catalina.properties "
    echo "=========================================================================================="
    find "$CATALINA_HOME/conf/catalina.properties" -follow -maxdepth 0 \( -perm o+rwx,g+rwx,u+x -o ! -user tomcat_admin -o ! -group tomcat \) -ls

    echo ""
    echo "=========================================================================================="
    echo "4.9 Restrict access to Tomcat catalina.policy"
    echo "=========================================================================================="
    find "$CATALINA_HOME/conf/catalina.policy" -follow -maxdepth 0 \( -perm o+rwx,g+rwx,u+x -o ! user tomcat_admin -o ! -group tomcat \) -ls

    echo ""
    echo "=========================================================================================="
    echo "4.10 Restrict access to Tomcat context.xml"
    echo "=========================================================================================="
    find "$CATALINA_HOME/conf/context.xml" -follow -maxdepth 0 \( -perm o+rwx,g+rwx,u+x -o ! -user tomcat_admin -o ! -group tomcat \) -ls

    echo ""
    echo "=========================================================================================="
    echo "4.11 Restrict access to Tomcat logging.properties"
    echo "=========================================================================================="
    find "$CATALINA_HOME/conf/logging.properties" -follow -maxdepth 0 \( -perm o+rwx,g+rwx,u+x -o ! -user tomcat_admin -o ! -group tomcat \) -ls

    echo ""
    echo "=========================================================================================="
    echo "4.12 Restrict access to Tomcat server.xml "
    echo "=========================================================================================="
    find "$SERVER_XML" -follow -maxdepth 0 \( -perm o+rwx,g+rwx,u+x -o ! -user tomcat_admin -o ! -group tomcat \) -ls

    echo ""
    echo "=========================================================================================="
    echo "4.13 Restrict access to Tomcat tomcat-users.xml"
    echo "=========================================================================================="
    find "$CATALINA_HOME/conf/tomcat-users.xml" -follow -maxdepth 0 \( -perm o+rwx,g+rwx,u+x -o ! user tomcat_admin -o ! -group tomcat \) -ls

    echo ""
    echo "=========================================================================================="
    echo "4.14 Restrict access to Tomcat web.xml"
    echo "=========================================================================================="
    find "$CATALINA_HOME/conf/web.xml" -follow -maxdepth 0 \( -perm o+rwx,g+rwx,u+wx -o ! -user tomcat_admin -o ! -group tomcat \) -ls

    echo ""
    echo "=========================================================================================="
    echo "4.15 Restrict access to jaspic-providers.xml"
    echo "=========================================================================================="
    find "$CATALINA_HOME/conf/jaspic-providers.xml" -follow -maxdepth 0 \( -perm o+rwx,g+rwx,u+x -o ! -user tomcat_admin -o ! -group tomcat \) -ls
  else
    echo "BAD: User [tomcat_admin] in group [tomcat] not found!"
  fi

  echo ""
  echo "=========================================================================================="
  echo "5.1 Use secure Realms"
  echo "=========================================================================================="
  grep -H "Realm className" "$SERVER_XML" | grep -H "MemoryRealm"
  grep -H "Realm className" "$SERVER_XML" | grep -H "JDBCRealm"
  grep -H "Realm className" "$SERVER_XML" | grep -H "UserDatabaseRealm"
  grep -H "Realm className" "$SERVER_XML" | grep -H "JAASReal"

  echo ""
  echo "=========================================================================================="
  echo "5.2 Use LockOut Realms"
  echo "=========================================================================================="
  grep -H "LockOutRealm" "$SERVER_XML"

  echo ""
  echo "=========================================================================================="
  echo "6. Connector Security"
  echo "=========================================================================================="
  echo "Manual Test Required"

  echo ""
  echo "=========================================================================================="
  echo "7.1 Application specific logging"
  echo "=========================================================================================="
  LOGGING_PROPERTIES_FILE=$CATALINA_BASE/webapps/$APP/WEB-INF/classes/logging.properties
  if [[ -f "$LOGGING_PROPERTIES_FILE" ]]; then
    echo "$LOGGING_PROPERTIES_FILE exist"
  else
    echo "$LOGGING_PROPERTIES_FILE not found"
  fi

  echo ""
  echo "=========================================================================================="
  echo "7.2 Specify file handler in logging.properties files"
  echo "=========================================================================================="
  if [[ -f "$LOGGING_PROPERTIES_FILE" ]]; then
    grep -H "handlers" "$CATALINA_BASE/webapps/$APP/WEB-INF/classes/logging.properties"
  else
    grep -H "handlers" "$CATALINA_BASE/conf/logging.properties"
  fi

  echo ""
  echo "=========================================================================================="
  echo "7.3 Ensure className is set correctly in context.xml"
  echo "=========================================================================================="
  if [[ -f $CONTEXT_XML ]]; then
    grep -H "org.apache.catalina.valves.AccessLogValve" "$CONTEXT_XML"
  else
    echo "Skip: File not found: $CONTEXT_XML"
  fi

  echo "=========================================================================================="
  echo "7.4 Ensure directory in context.xml is a secure location"
  echo "=========================================================================================="
  if [[ -f $CONTEXT_XML ]]; then
    location=$(grep "directory" "$CONTEXT_XML" | cut -d "=" -f 2 | tr -d '"')
    if [[ -n "$location" ]]; then
      ls -ld "$location"
    fi
  else
    echo "Skip: File not found: $CONTEXT_XML"
  fi

  echo ""
  echo "=========================================================================================="
  echo "7.5 Ensure pattern in context.xml is correct"
  echo "=========================================================================================="
  if [[ -f $CONTEXT_XML ]]; then
    grep -H "pattern" "$CONTEXT_XML"
  else
    echo "Skip: File not found: $CONTEXT_XML"
  fi

  echo "=========================================================================================="
  echo "7.6 Ensure directory in logging.properties is a secure location"
  echo "=========================================================================================="
  if [[ -f "$LOGGING_PROPERTIES_FILE" ]]; then
    echo "Check directories in log file: $LOGGING_PROPERTIES_FILE"
    grep "directory" "$LOGGING_PROPERTIES_FILE" | cut -d "=" -f 2 | tr -d '"' | sort | uniq | xargs ls -ld
  else
    echo "Skip: File not found: $LOGGING_PROPERTIES_FILE"
  fi
  echo ""
  if [[ -f "$CATALINA_BASE/conf/logging.properties" ]]; then
    echo "Check directories in log file: $CATALINA_BASE/conf/logging.properties"
    grep "directory" "$CATALINA_BASE/conf/logging.properties" | cut -d "=" -f 2 | tr -d '"' | sort | uniq | xargs ls -ld
  else
    echo "Skip: File not found: $CATALINA_BASE/conf/logging.properties"
  fi

  echo ""
  echo "=========================================================================================="
  echo "8.1 Restrict runtime access to sensitive packages"
  echo "=========================================================================================="
  echo "Manual Test Required"

  echo ""
  echo "=========================================================================================="
  echo "9.1 Starting Tomcat with Security Manager"
  echo "=========================================================================================="
  echo "Manual Test Required"

  echo ""
  echo "=========================================================================================="
  echo "9.2 Disabling auto deployment of applications"
  echo "=========================================================================================="
  grep -H "autoDeploy" "$SERVER_XML"

  echo ""
  echo "=========================================================================================="
  echo "9.3 Disable deploy on startup of applications"
  echo "=========================================================================================="
  grep -H "deployOnStartup" "$SERVER_XML"

  echo ""
  echo "=========================================================================================="
  echo "10.1 Ensure Web content directory is on a separate partition from the Tomcat system files"
  echo "=========================================================================================="
  df "$CATALINA_HOME/webapps"
  df "$CATALINA_HOME/webapps"
  df "$CATALINA_HOME"

  echo ""
  echo "=========================================================================================="
  echo "10.2 Restrict access to the web administration application"
  echo "=========================================================================================="
  grep -H "^<Valve className=\"org.apache.catalina.valves.RemoteAddrValve\" allow=\"127" "$SERVER_XML"

  echo ""
  echo "=========================================================================================="
  echo "10.3 Restrict manager application"
  echo "=========================================================================================="
  if [[ -f "$CATALINA_BASE/conf/$ENGINE_NAME/$HOSTNAME/manager.xml" ]]; then
    grep -H "^<Valve className=\"org.apache.catalina.valves.RemoteAddrValve\" allow=\"127" "$CATALINA_BASE/conf/$ENGINE_NAME/$HOSTNAME/manager.xml"
  else
    echo "GOOD: $CATALINA_BASE/conf/$ENGINE_NAME/$HOSTNAME/manager.xml do not exist"
  fi

  echo ""
  echo "=========================================================================================="
  echo "10.4 Force SSL when accessing the manager application"
  echo "=========================================================================================="
  if [[ -f "$CATALINA_HOME/webapps/manager/WEB-INF/web.xml" ]]; then
    grep -H "transport-guarantee" "$CATALINA_HOME/webapps/manager/WEB-INF/web.xml"
  else
    echo "Skip: File not found: $CATALINA_HOME/webapps/manager/WEB-INF/web.xml"
  fi

  echo ""
  echo "=========================================================================================="
  echo "10.5 Rename the manager application"
  echo "=========================================================================================="

  FILE=$CATALINA_HOME/conf/Catalina/localhost/manager.xml
  if [[ -f "$FILE" ]]; then
    echo "BAD: file $FILE exist"
  else
    echo "GOOD: file not found $FILE"
  fi

  FILE=$CATALINA_HOME/webapps/host-manager/manager.xml
  if [[ -f "$FILE" ]]; then
    echo "BAD: file $FILE exist"
  else
    echo "GOOD: file not found $FILE"
  fi

  FILE=$CATALINA_HOME/webapps/manager
  if [[ -f "$FILE" ]]; then
    echo "BAD: folder $FILE exist"
  else
    echo "GOOD: folder not found $FILE"
  fi

  echo ""
  echo "=========================================================================================="
  echo "10.6 Enable strict servlet Compliance"
  echo "=========================================================================================="
  grep -H "Dorg.apache.catalina.STRICT_SERVLET_COMPLIANCE=true" "$CATALINA_HOME/bin/catalina.sh"

  echo ""
  echo "=========================================================================================="
  echo "10.7 Turn off session facade recycling"
  echo "=========================================================================================="
  grep -H "Dorg.apache.catalina.connector.RECYCLE_FACADES=true" "$CATALINA_HOME/bin/catalina.sh"

  echo ""
  echo "=========================================================================================="
  echo "10.8 Do not allow additional path delimiters"
  echo "=========================================================================================="
  grep -H "Dorg.apache.catalina.connector.CoyoteAdapter.ALLOW_BACKSLASH=false" "$CATALINA_HOME/bin/catalina.sh"
  grep -H "Dorg.apache.tomcat.util.buf.UDecoder.ALLOW_ENCODED_SLASH=false" "$CATALINA_HOME/bin/catalina.sh"

  echo ""
  echo "=========================================================================================="
  echo "10.9 Configure connectionTimeout"
  echo "=========================================================================================="
  grep -H "connectionTimeout" "$SERVER_XML"

  echo ""
  echo "=========================================================================================="
  echo "10.10 Configure maxHttpHeaderSize"
  echo "=========================================================================================="
  grep -H "maxHttpHeaderSize" "$SERVER_XML"

  echo ""
  echo "=========================================================================================="
  echo "10.11 Force SSL for all applications"
  echo "=========================================================================================="
  grep -H "transport-guarantee" "$CATALINA_HOME/conf/web.xml"

  echo ""
  echo "=========================================================================================="
  echo "10.12 Do not allow symbolic linking"
  echo "=========================================================================================="
  find "$CATALINA_BASE" -name "context.xml" | xargs -0 grep -H "allowLinking"
  find "$CATALINA_HOME" -name "context.xml" | xargs -0 grep -H "allowLinking"

  echo ""
  echo "=========================================================================================="
  echo "10.13 Do not run applications as privileged"
  echo "=========================================================================================="
  find "$CATALINA_BASE" -name "context.xml" | xargs -0 grep -H "privileged"
  find "$CATALINA_HOME" -name "context.xml" | xargs -0 grep -H "privileged"

  echo ""
  echo "=========================================================================================="
  echo "10.14 Do not allow cross context requests"
  echo "=========================================================================================="
  find "$CATALINA_BASE" -name "context.xml" | xargs -0 grep -H "crossContext"
  find "$CATALINA_HOME" -name "context.xml" | xargs -0 grep -H "crossContext"

  echo ""
  echo "=========================================================================================="
  echo "10.15 Do not resolve hosts on logging valves"
  echo "=========================================================================================="
  grep -H "enableLookups" "$SERVER_XML"

  echo ""
  echo "=========================================================================================="
  echo "10.16 Enable memory leak listener"
  echo "=========================================================================================="
  grep -H "^<Listener className=\"org.apache.catalina.core.JreMemoryLeakPreventionListener" "$SERVER_XML"

  echo ""
  echo "=========================================================================================="
  echo "10.17 Setting Security Lifecycle Listener"
  echo "=========================================================================================="
  echo "Manual Test Required"

  echo ""
  echo "=========================================================================================="
  echo "10.18 Use the logEffectiveWebXml and metadata-complete settings for deploying applications in production"
  echo "=========================================================================================="
  grep -H "metadata-complete=\"true\"" "$WEB_XML"
  if [[ -f $CONTEXT_XML ]]; then
    grep -H "logEffectiveWebXml=\"true\"" "$CONTEXT_XML"
  else
    echo "Skip: File not found: $CONTEXT_XML"
  fi
  echo ""
} >>$OUTPUT_FILE 2>/dev/null

echo ""
echo "Security benchmark test completed. Find all results in: $OUTPUT_FILE"
echo ""
