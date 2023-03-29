#!/bin/bash
# Author: L0RE
# This Script Generates a new Inventory for a new Version or New Plugin
REPO=/root/repository.grabber66

if [ "$1" != "" ]
then
    REPO="$1"
fi
if [ -f "$(pwd)/addons.xml" ]
then
    REPO="$(pwd)"
fi
if [ ! -f "$REPO/addons.xml" ]
then
    echo "repo path nicht korrekt"
    exit 0
fi
ZIP="$(command -v zip)"
if [ "$ZIP" = "" ]
then
    echo "zip fehlt. eg: apt-get install zip"
    exit 0
fi


cd $REPO/../addons
echo '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' >$REPO/addons.xml
echo '<addons>' >> $REPO/addons.xml
for name in *; do
   VERSION=`cat $name/addon.xml|grep \<addon|grep $name |sed 's/.*version="\([^"]*\)"*.*/\1/g'`
     if [ ! -d "$REPO/addons/nexus/$name/" ]; then
	mkdir $REPO/addons/nexus/$name
     fi
     if [ ! -f "$REPO/addons/nexus/$name/$name-$VERSION.zip" ]; then
       zip -r --exclude=*.git* $REPO/addons/nexus/$name/$name-$VERSION.zip $name -x \*.zip
     fi
   cat $name/addon.xml|grep -v "<?xml " >> $REPO/addons.xml
   echo "" >> $REPO/addons.xml
echo $name
done
 echo "</addons>" >> $REPO/addons.xml
 echo "<dir>" >> $REPO/addons.xml
 echo "   <info compressed="false">https://raw.githubusercontent.com/Gujal00/smrzips/master/addons.xml</info>" >> $REPO/addons.xml
 echo "   <checksum>https://raw.githubusercontent.com/Gujal00/smrzips/master/addons.xml.md5</checksum>" >> $REPO/addons.xml
 echo "   <datadir zip="true">https://raw.githubusercontent.com/Gujal00/smrzips/master/zips/</datadir>" >> $REPO/addons.xml
 echo "</dir>" >> $REPO/addons.xml
 echo "<dir minversion="19.9.9">" >> $REPO/addons.xml
echo "   <info compressed="true">https://repo.kodinerds.net/addons/nexus/addons.xml</info>" >> $REPO/addons.xml
echo "   <checksum>https://repo.kodinerds.net/addons/nexus/addons.xml.md5</checksum>" >> $REPO/addons.xml
echo "   <datadir zip="true">https://repo.kodinerds.net/addons/nexus/zip/</datadir>" >> $REPO/addons.xml
echo "   <hashes>false</hashes>" >> $REPO/addons.xml
echo "</dir>" >> $REPO/addons.xml
md5sum  $REPO/addons.xml > $REPO/addons.xml.md5
