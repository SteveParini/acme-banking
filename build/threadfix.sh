# Set up Threadfix cli
java -jar /var/lib/jenkins/threadfix/tfcli.jar --set url https://threadfix.pscpd.net/rest/latest
java -jar /var/lib/jenkins/threadfix/tfcli.jar --set key ${THREADFIX_API_KEY}

# Input the scan reports
java -jar /var/lib/jenkins/threadfix/tfcli.jar -u 1 ${WORKSPACE}/reports/zap/${BUILD_TAG}.xml
java -jar /var/lib/jenkins/threadfix/tfcli.jar -u 1 ${WORKSPACE}/reports/owasp-dependency-check/dependency-check-report.xml
