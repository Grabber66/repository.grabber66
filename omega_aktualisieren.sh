#!/bin/bash
# Author: L0RE
# This Script Generates a new Inventory for a new Version or New Plugin
REPO=/root/repository.grabber66

if [ ! -f "$REPO/addons/omega/addons.xml" ]
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


cd $REPO/../addons/omega
echo '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' >$REPO/addons/omega/addons.xml
echo '<addons>' >> $REPO/addons/omega/addons.xml
for name in *; do
   VERSION=`cat $name/addon.xml|grep \<addon|grep $name |sed 's/.*version="\([^"]*\)"*.*/\1/g'`
     if [ ! -d "$REPO/addons/omega/$name/" ]; then
	mkdir $REPO/addons/omega/$name
     fi
     if [ ! -f "$REPO/addons/omega/$name/$name-$VERSION.zip" ]; then
       zip -r --exclude=*.git* $REPO/addons/omega/$name/$name-$VERSION.zip $name -x \*.zip
     fi
   cat $name/addon.xml|grep -v "<?xml " >> $REPO/addons/omega/addons.xml
   echo "" >> $REPO/addons/omega/addons.xml
echo $name
done
 echo "</addons>" >> $REPO/addons/omega/addons.xml
 echo "<dir>" >> $REPO/addons/omega/addons.xml
 echo "   <info compressed="false">https://raw.githubusercontent.com/Gujal00/smrzips/master/addons.xml</info>" >> $REPO/addons/omega/addons.xml
 echo "   <checksum>https://raw.githubusercontent.com/Gujal00/smrzips/master/addons.xml.md5</checksum>" >> $REPO/addons/omega/addons.xml
 echo "   <datadir zip="true">https://raw.githubusercontent.com/Gujal00/smrzips/master/zips/</datadir>" >> $REPO/addons/omega/addons.xml
 echo "</dir>" >> $REPO/addons/omega/addons.xml
 echo "<dir minversion="21.0.0">" >> $REPO/addons/omega/addons.xml
 echo "   <info compressed="true">https://repo.kodinerds.net/addons/omega/addons.xml</info>" >> $REPO/addons/omega/addons.xml
 echo "   <checksum>https://repo.kodinerds.net/addons/omega/addons.xml.md5</checksum>" >> $REPO/addons/omega/addons.xml
 echo "   <datadir zip="true">https://repo.kodinerds.net/addons/omaga/zip/</datadir>" >> $REPO/addons/omega/addons.xml
 echo "   <hashes>false</hashes>" >> $REPO/addons/omega/addons.xml
 echo "</dir>" >> $REPO/addons/omega/addons.xml
md5sum  $REPO/addons/omega/addons.xml > $REPO/addons/omega/addons.xml.md5
