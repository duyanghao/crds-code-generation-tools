#!/bin/bash

# initialization
initialize() {
    # sets colors for use in output
    GREEN='\e[32m'
    BLUE='\e[34m'
    YELLOW='\e[0;33m'
    RED='\e[31m'
    BOLD='\e[1m'
    CLEAR='\e[0m'
    # pre-configure ok, warning, and error output
    OK="[${GREEN}OK${CLEAR}]"
    INFO="[${BLUE}INFO${CLEAR}]"
    NOTICE="[${YELLOW}!!${CLEAR}]"
    ERROR="[${RED}ERROR${CLEAR}]"
}

clear_envs() {
    rm -rf pkg artifacts
    rm hack/update-codegen.sh
}

generate_crds() {
    # generate CRDs
    cp -r templates templates_tmp
    find templates_tmp -type f -name '*.tmpl' -exec sh -c 'mv -- "$0" "${0%%.tmpl}"' {} \;
    grep -rl "{GroupName}" ./templates_tmp | xargs sed -i '' "s/{GroupName}/${GroupName}/g"
    grep -rl "{GroupPackage}" ./templates_tmp | xargs sed -i '' "s/{GroupPackage}/${GroupPackage}/g"
    grep -rl "{Version}" ./templates_tmp | xargs sed -i '' "s/{Version}/${Version}/g"
    grep -rl "{Kind}" ./templates_tmp | xargs sed -i '' "s/{Kind}/${Kind}/g"
    grep -rl "{Plural}" ./templates_tmp | xargs sed -i '' "s/{Plural}/${Plural}/g"
    mkdir -p pkg/apis/${GroupPackage}/${Version} artifacts
    mv templates_tmp/* pkg/apis/${GroupPackage}/${Version}/
    mv pkg/apis/${GroupPackage}/${Version}/group_register.go pkg/apis/${GroupPackage}/register.go
    mv pkg/apis/${GroupPackage}/${Version}/update-codegen.sh hack/update-codegen.sh
    mv pkg/apis/${GroupPackage}/${Version}/crd.yaml artifacts/crd.yaml
    rmdir templates_tmp
}

main () {
    initialize

    if [ "$1" == "-h" ] || [ $# -ne 5 ]; then
        echo -e "${NOTICE} Usage:"
        echo -e "${NOTICE} $0, GroupName GroupPackage Version Kind Plural(eg: duyanghao.example.com duyanghao v1 Project projects)"
        exit 0
    fi

    GroupName=$1
    GroupPackage=$2
    Version=$3
    Kind=$4
    Plural=$5

    echo -e "${INFO} Start to clear CRDs environments ..."
    clear_envs
    echo -e "${OK} Clear CRDs environments done"

    echo -e "${INFO} Start to generate CRDs ..."
    generate_crds
    echo -e "${OK} Generate CRDs done"
}

main "$@"
