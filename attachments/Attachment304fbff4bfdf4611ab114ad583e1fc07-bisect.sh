
# git bisect start HEAD xl-release-7.6.0 --
# git bisect run ../bisect.sh
# git bisect reset

# preparing
cd /Users/pvanderende/xl/git/xl-release
rm -rf package/build/distributions/xl-release-7.6.1-SNAPSHOT-server

# run the build or in case of a commit that can not be build, exit with code 125 that indicates to bisect to skip this commit
./gradlew clean buildServerDistribution || exit 125

# unzip and copy license
cd package/build/distributions
unzip -q xl-release-7.6.1-SNAPSHOT-server.zip
cd xl-release-7.6.1-SNAPSHOT-server
cp ~/xl/xl-release-license.lic conf

# unattended install of XLR and start the server in the background
bin/run.sh -setup -reinitialize -force -setup-defaults ~/xl/git/xl-release-server.conf
bin/run.sh &

echo "WAITING FOR SERVER TO START"
while ! nc -z localhost 5516; do
  sleep 1
done
echo "SERVER IS RUNNING"

# Here is the logic that decides if the current commit is good or bad. In our case just a curl command that either passes or failed. Make sure to pass --fail to set curl exit code properly
curl -u admin:admin 'http://localhost:5516/settings/smtp/checkConfig' -H 'Content-Type: application/json' -H 'Accept: application/json, text/plain, */*' --data-binary '{"host":"localhost","port":25,"tls":false,"fromAddress":"xl-release@domain.tld","username":"xl-release@domain.tld","password":"testpass","testAddress":"xl-release@domain.tld","type":"xlrelease.SmtpServer","id":"Configuration/mail/SmtpServer"}' --compressed --fail

# Save the exit code of curl to make this script exit with a zero or non zero exit code to indicate to bisect if this is a good or bad commit
exitcode=$?
echo "CURL EXIT CODE: $exitcode"

curl -u admin:admin -X POST 'http://localhost:5516/server/shutdown'

exit $exitcode
