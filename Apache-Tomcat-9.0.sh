#!/usr/bin/env bash

#set -ouex pipefail
set -o pipefail

echo "##########################################"
echo "Apache Tomcat 9.0 Security Benchmark Tests"
echo "##########################################"
echo ""
echo "Checking preconditions..."
echo ""

# $CATALINA_BASE
if [[ -n ${CATALINA_BASE} ]]; then
	echo "\$CATALINA_BASE is set to: $CATALINA_BASE"
else
	echo "ERROR: \$CATALINA_BASE must be set!"
	exit 1;
fi

# $CATALINA_HOME
if [[ -n ${CATALINA_HOME} ]]; then
	echo "\$CATALINA_HOME is set to: $CATALINA_HOME"
else
	echo "ERROR: \$CATALINA_HOME must be set!"
	exit 1;
fi
echo ""

while true; do
	echo -n "Enter the APP name located in the following directory/format \$CATALINA_HOME/webapps/<App_name>/WEB-INF/web.xml: "
	read APP

	WEB_XML=$CATALINA_HOME/webapps/$APP/WEB-INF/web.xml
	exists=$(ls -al "$WEB_XML" 2>&1)
	existsFlag=$(echo $exists | grep "No such file")
	if [[ -z "$existsFlag" ]]; then
		break
	fi
	echo "ERROR: The file $location does not exist. Type again"
	echo ""
done

while true; do
	echo -n "Enter the APP Engine name located in the following directory/format \$CATALINA_BASE/conf/<engine_name>/<host_name>: "
	read ENGINE_NAME
	echo -n "Enter the Host name located in the following directory/format \$CATALINA_BASE/conf/<engine_name>/<host_name>: "
	read HOSTNAME

	location=$CATALINA_HOME/conf/$ENGINE_NAME/$HOSTNAME
	exists=$(ls -al "$location" 2>&1)
	existsFlag=$(echo "$exists" | grep "No such file")
	if [[ -z "$existsFlag" ]]; then
		break
	fi
	echo "ERROR: The folder $location does not exist. Type again"
	echo ""
done

SERVER_XML=$CATALINA_HOME/conf/server.xml
if [[ ! -f "$SERVER_XML" ]]; then
	echo "ERROR: File not found: $SERVER_XML. Is \$CATALINA_HOME set correctly?"
	exit 1;
fi

CONTEXT_XML=$CATALINA_BASE/webapps/$APP/META-INF/context.xml

echo ""
echo "Start security benchmark tests..."
echo ""

OUTPUT_FILE="Apache_Tomcat_9.0.txt"

echo "" > $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "|                       Apache Tomcat 9.0 CIS Benchmark v1.0.0 Script                    |" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "1.1 Remove extraneous files and directories" >> $OUTPUT_FILE

directory=$CATALINA_HOME/webapps/examples
if [[ -d "$directory" ]]; then
	echo "BAD: Directory ${directory} found." >> $OUTPUT_FILE
	ls -l "$directory" 2>&1 >> $OUTPUT_FILE
else
	echo "GOOD: Directory ${directory} not found." >> $OUTPUT_FILE
fi

directory=$CATALINA_HOME/webapps/docs
if [[ -d "$directory" ]]; then
	echo "BAD: Directory ${directory} found." >> $OUTPUT_FILE
	ls -l "$directory" 2>&1 >> $OUTPUT_FILE
else
	echo "GOOD: Directory ${directory} not found." >> $OUTPUT_FILE
fi

directory=$CATALINA_HOME/webapps/ROOT
if [[ -d "$directory" ]]; then
	echo "BAD: Directory ${directory} found." >> $OUTPUT_FILE
	ls -l "$directory" 2>&1 >> $OUTPUT_FILE
else
	echo "GOOD: Directory ${directory} not found." >> $OUTPUT_FILE
fi

directory=$CATALINA_HOME/webapps/host-manager
if [[ -d "$directory" ]]; then
	echo "BAD: Directory ${directory} found." >> $OUTPUT_FILE
	ls -l "$directory" 2>&1 >> $OUTPUT_FILE
else
	echo "GOOD: Directory ${directory} not found." >> $OUTPUT_FILE
fi

directory=$CATALINA_HOME/webapps/manager
if [[ -d "$directory" ]]; then
	echo "BAD: Directory ${directory} found." >> $OUTPUT_FILE
	ls -l "$directory" 2>&1 >> $OUTPUT_FILE
else
	echo "GOOD: Directory ${directory} not found." >> $OUTPUT_FILE
fi

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "1.2 Disable Unused Connectors" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
grep -H "Connector" "$SERVER_XML" >> $OUTPUT_FILE

# Skip if JAR command is missing
if command -v jar 2>&1 > /dev/null
then
	echo "" >> $OUTPUT_FILE
	echo "==========================================================================================" >> $OUTPUT_FILE
	echo "2.1 Alter the Advertised server.info String" >> $OUTPUT_FILE
	echo "==========================================================================================" >> $OUTPUT_FILE
	jar xf "$CATALINA_HOME/lib/catalina.jar" org/apache/catalina/util/ServerInfo.properties
	grep -H "server.info" org/apache/catalina/util/ServerInfo.properties >> $OUTPUT_FILE

	echo "" >> $OUTPUT_FILE
	echo "==========================================================================================" >> $OUTPUT_FILE
	echo "2.2 Alter the Advertised server.number String " >> $OUTPUT_FILE
	echo "==========================================================================================" >> $OUTPUT_FILE
	jar xf "$CATALINA_HOME/lib/catalina.jar" org/apache/catalina/util/ServerInfo.properties
	grep -H "server.number" org/apache/catalina/util/ServerInfo.properties >> $OUTPUT_FILE

	echo "" >> $OUTPUT_FILE
	echo "==========================================================================================" >> $OUTPUT_FILE
	echo "2.3 Alter the Advertised server.built Date" >> $OUTPUT_FILE
	echo "==========================================================================================" >> $OUTPUT_FILE
	jar xf "$CATALINA_HOME/lib/catalina.jar" org/apache/catalina/util/ServerInfo.properties
	grep -H "server.built" org/apache/catalina/util/ServerInfo.properties >> $OUTPUT_FILE
else
	echo "JAR command not found. Install it to apply further checks inside of Tomcat's catalina.jar."
fi

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "2.4 Disable X-Powered-By HTTP Header and Rename the Server Value for all Connectors" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "Manual Test Required" >> $OUTPUT_FILE

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "2.5 Disable client facing Stack Traces" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "Manual Test Required" >> $OUTPUT_FILE

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "2.6 Turn off TRACE" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "Manual Test Required" >> $OUTPUT_FILE

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "2.6 Turn off TRACE" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "Manual Test Required" >> $OUTPUT_FILE

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "2.7 Ensure Sever Header is Modified To Prevent Information Disclosure" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "Manual Test Required" >> $OUTPUT_FILE

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "3.1 Set a nondeterministic Shutdown command value " >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
grep -H 'shutdown[[:space:]]*=[[:space:]]*"SHUTDOWN"' "$SERVER_XML" >> $OUTPUT_FILE

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "3.2 Disable the Shutdown port " >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
grep -H '<Server[[:space:]]\+[^>]*port[[:space:]]*=[[:space:]]*"-1"' "$SERVER_XML" >> $OUTPUT_FILE

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "4.1 Restrict access to $CATALINA_HOME" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
find "$CATALINA_HOME" -follow -maxdepth 0 \( -perm /o+rwx,g=w -o ! -user tomcat_admin -o ! -group tomcat \) -ls >> $OUTPUT_FILE

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "4.2 Restrict access to $CATALINA_BASE" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
find "$CATALINA_BASE" -follow -maxdepth 0 \( -perm /o+rwx,g=w -o ! -user tomcat_admin -o ! -group tomcat \) -ls >> $OUTPUT_FILE

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "4.3 Restrict access to Tomcat configuration directory" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
find "$CATALINA_HOME/conf" -maxdepth 0 \( -perm /o+rwx,g=w -o ! -user tomcat_admin -o ! -group tomcat \) -ls >> $OUTPUT_FILE

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "4.4 Restrict access to Tomcat logs directory" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
if [[ -d "$CATALINA_HOME/logs" ]]; then
	find "$CATALINA_HOME/logs" -follow -maxdepth 0 \( -perm /o+rwx -o ! -user tomcat_admin -o ! -group tomcat \) -ls >> $OUTPUT_FILE
else
	echo "Skip: Tomcat logs directory under $CATALINA_HOME/logs does not exist" >> $OUTPUT_FILE
fi

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "4.5 Restrict access to Tomcat temp directory " >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
find "$CATALINA_HOME/temp" -follow -maxdepth 0 \( -perm /o+rwx -o ! -user tomcat_admin -o ! -group tomcat \) -ls >> $OUTPUT_FILE

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "4.6 Restrict access to Tomcat binaries directory " >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
find "$CATALINA_HOME/bin" -follow -maxdepth 0 \( -perm /o+rwx,g=w -o ! -user tomcat_admin -o ! -group tomcat \) -ls >> $OUTPUT_FILE

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "4.7 Restrict access to Tomcat web application directory " >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
find "$CATALINA_HOME/webapps" -follow -maxdepth 0 \( -perm /o+rwx,g=w -o ! -user tomcat_admin -o ! -group tomcat \) -ls >> $OUTPUT_FILE

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "4.8 Restrict access to Tomcat catalina.properties " >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
find "$CATALINA_HOME/conf/catalina.properties" -follow -maxdepth 0 \( -perm /o+rwx,g+rwx,u+x -o ! -user tomcat_admin -o ! -group tomcat \) -ls >> $OUTPUT_FILE

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "4.9 Restrict access to Tomcat catalina.policy" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
find "$CATALINA_HOME/conf/catalina.policy" -follow -maxdepth 0 \( -perm /o+rwx,g+rwx,u+x -o ! user tomcat_admin -o ! -group tomcat \) -ls >> $OUTPUT_FILE

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "4.10 Restrict access to Tomcat context.xml" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
find "$CATALINA_HOME/conf/context.xml" -follow -maxdepth 0 \( -perm /o+rwx,g+rwx,u+x -o ! -user tomcat_admin -o ! -group tomcat \) -ls >> $OUTPUT_FILE

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "4.11 Restrict access to Tomcat logging.properties" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
find "$CATALINA_HOME/conf/logging.properties" -follow -maxdepth 0 \( -perm /o+rwx,g+rwx,u+x -o ! -user tomcat_admin -o ! -group tomcat \) -ls >> $OUTPUT_FILE

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "4.12 Restrict access to Tomcat server.xml " >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
find "$SERVER_XML" -follow -maxdepth 0 \( -perm /o+rwx,g+rwx,u+x -o ! -user tomcat_admin -o ! -group tomcat \) -ls >> $OUTPUT_FILE

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "4.13 Restrict access to Tomcat tomcat-users.xml" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
find "$CATALINA_HOME/conf/tomcat-users.xml" -follow -maxdepth 0 \( -perm /o+rwx,g+rwx,u+x -o ! user tomcat_admin -o ! -group tomcat \) -ls >> $OUTPUT_FILE

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "4.14 Restrict access to Tomcat web.xml" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
find "$CATALINA_HOME/conf/web.xml" -follow -maxdepth 0 \( -perm /o+rwx,g+rwx,u+wx -o ! -user tomcat_admin -o ! -group tomcat \) -ls >> $OUTPUT_FILE

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "4.15 Restrict access to jaspic-providers.xml" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
find "$CATALINA_HOME/conf/jaspic-providers.xml" -follow -maxdepth 0 \( -perm /o+rwx,g+rwx,u+x -o ! -user tomcat_admin -o ! -group tomcat \) -ls >> $OUTPUT_FILE

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "5.1 Use secure Realms" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
grep -H "Realm className" "$SERVER_XML" | grep -H "MemoryRealm" >> $OUTPUT_FILE
grep -H "Realm className" "$SERVER_XML" | grep -H "JDBCRealm" >> $OUTPUT_FILE
grep -H "Realm className" "$SERVER_XML" | grep -H "UserDatabaseRealm" >> $OUTPUT_FILE
grep -H "Realm className" "$SERVER_XML" | grep -H "JAASReal" >> $OUTPUT_FILE

echo ""
echo "==========================================================================================" >> $OUTPUT_FILE
echo "5.2 Use LockOut Realms" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
grep -H "LockOutRealm" "$SERVER_XML" >> $OUTPUT_FILE

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "6. Connector Security" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "Manual Test Required" >> $OUTPUT_FILE

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "7.1 Application specific logging" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
LOGGING_PROPERTIES_FILE=$CATALINA_BASE/webapps/$APP/WEB-INF/classes/logging.properties
if [[ -f "$LOGGING_PROPERTIES_FILE" ]]; then
  echo "$LOGGING_PROPERTIES_FILE exist" >> $OUTPUT_FILE
else
  echo "$LOGGING_PROPERTIES_FILE not found" >> $OUTPUT_FILE
fi

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "7.2 Specify file handler in logging.properties files" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
if [[ -f "$LOGGING_PROPERTIES_FILE" ]]; then
  grep -H "handlers" "$CATALINA_BASE/webapps/$APP/WEB-INF/classes/logging.properties" >> $OUTPUT_FILE
else
  grep -H "handlers" "$CATALINA_BASE/conf/logging.properties" >> $OUTPUT_FILE
fi

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "7.3 Ensure className is set correctly in context.xml" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
grep -H "org.apache.catalina.valves.AccessLogValve" "$CONTEXT_XML" >> $OUTPUT_FILE

echo "==========================================================================================" >> $OUTPUT_FILE
echo "7.4 Ensure directory in context.xml is a secure location" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
location=$(grep "directory" "$CONTEXT_XML" | cut -d "=" -f 2 | tr -d '"')
if [[ -n "$location" ]]; then
	ls -ld "$location" >> $OUTPUT_FILE
fi

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "7.5 Ensure pattern in context.xml is correct" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
grep -H "pattern" "$CONTEXT_XML" >> $OUTPUT_FILE

echo "==========================================================================================" >> $OUTPUT_FILE
echo "7.6 Ensure directory in logging.properties is a secure location" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
if [[ -f "$LOGGING_PROPERTIES_FILE" ]]; then
	location=$(grep "directory" $LOGGING_PROPERTIES_FILE | cut -d "=" -f 2 | tr -d '"')
	if [[ -n "$location" ]]; then
	  ls -ld "$location" >> $OUTPUT_FILE
	else
	  location=$(grep "directory" "$CATALINA_BASE/conf/logging.properties" | cut -d "=" -f 2 | tr -d '"')
	  ls -ld $location >> $OUTPUT_FILE
	fi
else
	location=$(grep "directory" "$CATALINA_BASE/conf/logging.properties" | cut -d "=" -f 2 | tr -d '"')
	ls -ld $location >> $OUTPUT_FILE
fi

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "8.1 Restrict runtime access to sensitive packages" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "Manual Test Required" >> $OUTPUT_FILE

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "9.1 Starting Tomcat with Security Manager" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "Manual Test Required" >> $OUTPUT_FILE

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "9.2 Disabling auto deployment of applications" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
grep -H "autoDeploy" "$SERVER_XML" >> $OUTPUT_FILE

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "9.3 Disable deploy on startup of applications" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
grep -H "deployOnStartup" "$SERVER_XML" >> $OUTPUT_FILE

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "10.1 Ensure Web content directory is on a separate partition from the Tomcat system files" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
df "$CATALINA_HOME/webapps" >> $OUTPUT_FILE
df "$CATALINA_HOME/webapps" >> $OUTPUT_FILE
df "$CATALINA_HOME" >> $OUTPUT_FILE

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "10.2 Restrict access to the web administration application" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
grep -H "^<Valve className=\"org.apache.catalina.valves.RemoteAddrValve\" allow=\"127" "$SERVER_XML" >> $OUTPUT_FILE

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "10.3 Restrict manager application" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
if [[ -f "$CATALINA_BASE/conf/$ENGINE_NAME/$HOSTNAME/manager.xml" ]]; then
	grep -H "^<Valve className=\"org.apache.catalina.valves.RemoteAddrValve\" allow=\"127" "$CATALINA_BASE/conf/$ENGINE_NAME/$HOSTNAME/manager.xml" >> $OUTPUT_FILE
else
	echo "GOOD: $CATALINA_BASE/conf/$ENGINE_NAME/$HOSTNAME/manager.xml do not exist" >> $OUTPUT_FILE
fi

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "10.4 Force SSL when accessing the manager application" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
if [[ -f "$CATALINA_HOME/webapps/manager/WEB-INF/web.xml" ]]; then
	grep -H "transport-guarantee" "$CATALINA_HOME/webapps/manager/WEB-INF/web.xml" >> $OUTPUT_FILE
else
	echo "Skip: File not found: $CATALINA_HOME/webapps/manager/WEB-INF/web.xml" >> $OUTPUT_FILE
fi

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "10.5 Rename the manager application" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE

FILE=$CATALINA_HOME/conf/Catalina/localhost/manager.xml
if [[ -f "$FILE" ]]; then
	echo "BAD: file $FILE exist" >> $OUTPUT_FILE
else
	echo "GOOD: file not found $FILE" >> $OUTPUT_FILE
fi

FILE=$CATALINA_HOME/webapps/host-manager/manager.xml
if [[ -f "$FILE" ]]; then
	echo "BAD: file $FILE exist" >> $OUTPUT_FILE
else
	echo "GOOD: file not found $FILE" >> $OUTPUT_FILE
fi

FILE=$CATALINA_HOME/webapps/manager
if [[ -f "$FILE" ]]; then
	echo "BAD: folder $FILE exist" >> $OUTPUT_FILE
else
	echo "GOOD: folder not found $FILE" >> $OUTPUT_FILE
fi

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "10.6 Enable strict servlet Compliance" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
grep -H "Dorg.apache.catalina.STRICT_SERVLET_COMPLIANCE=true" "$CATALINA_HOME/bin/catalina.sh" >> $OUTPUT_FILE

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "10.7 Turn off session facade recycling" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
grep -H "Dorg.apache.catalina.connector.RECYCLE_FACADES=true" "$CATALINA_HOME/bin/catalina.sh" >> $OUTPUT_FILE

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "10.8 Do not allow additional path delimiters" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
grep -H "Dorg.apache.catalina.connector.CoyoteAdapter.ALLOW_BACKSLASH=false" "$CATALINA_HOME/bin/catalina.sh" >> $OUTPUT_FILE
grep -H "Dorg.apache.tomcat.util.buf.UDecoder.ALLOW_ENCODED_SLASH=false" "$CATALINA_HOME/bin/catalina.sh" >> $OUTPUT_FILE

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "10.9 Configure connectionTimeout" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
grep -H "connectionTimeout" "$SERVER_XML" >> $OUTPUT_FILE

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "10.10 Configure maxHttpHeaderSize" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
grep -H "maxHttpHeaderSize" "$SERVER_XML" >> $OUTPUT_FILE

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "10.11 Force SSL for all applications" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
grep -H "transport-guarantee" "$CATALINA_HOME/conf/web.xml" >> $OUTPUT_FILE

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "10.12 Do not allow symbolic linking" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
find $CATALINA_BASE -name "context.xml" | xargs grep -H "allowLinking" >> $OUTPUT_FILE
find $CATALINA_HOME -name "context.xml" | xargs grep -H "allowLinking" >> $OUTPUT_FILE

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "10.13 Do not run applications as privileged" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
find $CATALINA_BASE -name "context.xml" | xargs grep -H "privileged" >> $OUTPUT_FILE
find $CATALINA_HOME -name "context.xml" | xargs grep -H "privileged" >> $OUTPUT_FILE

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "10.14 Do not allow cross context requests" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
find $CATALINA_BASE -name "context.xml" | xargs grep -H "crossContext" >> $OUTPUT_FILE
find $CATALINA_HOME -name "context.xml" | xargs grep -H "crossContext" >> $OUTPUT_FILE

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "10.15 Do not resolve hosts on logging valves" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
grep -H "enableLookups" $SERVER_XML >> $OUTPUT_FILE

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "10.16 Enable memory leak listener" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
grep -H "^<Listener className=\"org.apache.catalina.core.JreMemoryLeakPreventionListener" "$SERVER_XML" >> $OUTPUT_FILE

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "10.17 Setting Security Lifecycle Listener" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "Manual Test Required" >> $OUTPUT_FILE

echo "" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
echo "10.18 Use the logEffectiveWebXml and metadata-complete settings for deploying applications in production" >> $OUTPUT_FILE
echo "==========================================================================================" >> $OUTPUT_FILE
grep -H "metadata-complete=\"true\"" "$WEB_XML" >> $OUTPUT_FILE
grep -H "logEffectiveWebXml=\"true\"" "$CONTEXT_XML" >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

echo ""
echo "Security benchmark test completed. Find all results in: $OUTPUT_FILE"
echo ""