#!/bin/bash
export WRKDIR=$(pwd)
export PKG_DIR="lambda_zip/"



sudo rm -rf ${WRKDIR}/${PKG_DIR}
mkdir -p ${WRKDIR}/${PKG_DIR}
mkdir -p ${WRKDIR}/packages/

sudo pip install  -r ${WRKDIR}/requirements.txt --no-deps -t ${WRKDIR}/${PKG_DIR}

sudo rm -rf ${WRKDIR}/packages/Python-package.zip

# zip -r packages/Python-package.zip ${PKG_DIR}

