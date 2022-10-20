#!/usr/bin/env bash
#in ./configure...make..make install (autotools) philosophy
#only the last step must be done in root (or sudo)
#in docker image contruction is done as root so it can make with dependencies
#and accessible path ( it differs between standard account and root)
# so this script will temporary create this standard account

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. ${SCRIPT_DIR}/credits_service_account.conf

groupadd ${app_group}
mkdir /lochome
useradd -s /bin/bash -d ${app_home} -m -g ${app_group} ${app_user}



