#!/bin/bash

# Check whether we are inside the Jeniks environment or not
[ -z "${WORKSPACE}" ] && echo 'WORKSPACE is not defined.' && exit

mkdir -p "${WORKSPACE}/reports/owasp-dependency-check"
chmod -R 777 "${WORKSPACE}/reports/owasp-dependency-check"

mkdir -p "${WORKSPACE}/OWASP-Dependency-Check/data"
chmod -R 777 "${WORKSPACE}/OWASP-Dependency-Check/data"


# Run OWASP Dependency Check Dockerfile
docker ps
docker pull owasp/dependency-check
docker run --rm --volume ${WORKSPACE}:/src --volume "${WORKSPACE}/OWASP-Dependency-Check/data":/usr/share/dependency-check/data --volume "${WORKSPACE}/reports/owasp-dependency-check":/report owasp/dependency-check --scan /src/package.json --format "XML" --project "acme-banking" -o /report -n
