AUTOMATION_DIRECTORY=`pwd -P`
VERSION=7.2.0-SNAPSHOT

echo "Remove old version..."
if [ -d "$VERSION" ]; then
    rm -rf $VERSION
fi

echo "Prepare Wildfly..."
if [ ! -f wildfly-10.1.0.Final.zip ]; then
    wget http://download.jboss.org/wildfly/10.1.0.Final/wildfly-10.1.0.Final.zip
fi
unzip -q wildfly-10.1.0.Final.zip -d ./
mv wildfly-10.1.0.Final $VERSION

echo "Configure Wildfly..."
cp application-roles.properties ./$VERSION/standalone/configuration
cp application-users.properties ./$VERSION/standalone/configuration
rm ./$VERSION/standalone/configuration/standalone.xml
cp standalone.xml ./$VERSION/standalone/configuration/standalone.xml
cp standalone.conf ./$VERSION/bin/standalone.conf

echo "Download Workbench and KIE Server..."
mvn dependency:get \
  --batch-mode \
  -DremoteRepositories=jbrepo::::https://repository.jboss.org,jbSnapRepo::::http://snapshots.jboss.org \
  -Dtransitive=false \
  -Dartifact=org.kie:kie-wb:$VERSION:war:wildfly10 \
  -Ddest=$AUTOMATION_DIRECTORY/$VERSION/standalone/deployments/business-central.war

mvn dependency:get \
  --batch-mode \
  -DremoteRepositories=jbrepo::::https://repository.jboss.org,jbSnapRepo::::http://snapshots.jboss.org \
  -Dtransitive=false \
  -Dartifact=org.kie.server:kie-server:$VERSION:war:ee7 \
  -Ddest=$AUTOMATION_DIRECTORY/$VERSION/standalone/deployments/kie-server.war
