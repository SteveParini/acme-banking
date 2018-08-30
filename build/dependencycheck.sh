#!/bin/sh

# Configurable parameters
OWASP_DC_URL='http://dl.bintray.com/jeremy-long/owasp/dependency-check-3.3.1-release.zip'

# Check if we are running under Jenkins
if [ -z "${WORKSPACE}" ] ; then
  echo 'This script is meant to executed by Jenkins'
  exit 1
fi

# Download OWASP Dependency Check if it's not available in build agent
if [ ! -d "${WORKSPACE}/dependency-check" ] ; then
  echo 'Downloading OWASP Dependency Check'
  wget -O /tmp/owasp-dc.zip "${OWASP_DC_URL}"
  unzip -d "${WORKSPACE}" /tmp/owasp-dc.zip
  rm /tmp/owasp-dc.zip
fi

# Check if output directory exists
if [ ! -d "${WORKSPACE}/reports/owasp-dependency-check" ] ; then
  echo 'Creating OWASP Dependency Check report directory'
  mkdir -p "${WORKSPACE}/reports/owasp-dependency-check"
fi

# Run OWASP Dependency Check Dockerfile
# TODO: Remove hard-coded proxy information, parse it from ${http_proxy}
/bin/sh "${WORKSPACE}/dependency-check/bin/dependency-check.sh" \
  --project ${JOB_NAME} \
  --format ALL \
  --out "${WORKSPACE}/reports/owasp-dependency-check" \
  --scan $(pwd) \
  --proxyserver 172.17.0.1 --proxyport 3128 \
  --disableBundleAudit