#!/bin/bash

# NOTE: REGISTRY_URL is used to specify where to push the built images...must have trailing '/'
source ./util/logging.sh

BASE="base"
HELP="help"

header "Docker Build Utility"

function usage() {
    echo "Usage: $0 [-v ver1 ver2 ...] [-p] -- (${BASE} | ${HELP})"
    echo -e "\t${BASE} - if you would like to build the base compose docker image"
    echo -e "\t${HELP} - to see this message"
    echo "Options:"
    echo -e "\t-v - What versions to tag the images as"
    echo -e "\t-p - Pass this option if you want to push to the REGISTRY...MUST HAVE -v IF USING THIS OPTION"
    note "Make sure you  pass the '--' if you use any of the above options (-v parsing causes this)"
    exit 1
}

function build_failed() {
    error_exit "Build of $1 failed"
}

function build_base() {
    info "Building ${BASE} docker image"

    if ! docker build -t ${BASE} ./${BASE}; then
        build_failed ${BASE}
    fi
    success "Completed building ${BASE} docker image"
}

function tag_images() {
    info "Tagging docker images as: [ ${IMAGE_VERSIONS[*]} ]"
    for v in "${IMAGE_VERSIONS[@]}"; do
        docker tag "${BASE}" "${REGISTRY_URL}${BASE}:$v" || error_exit "Failed to tag ${REGISTRY_URL}${BASE}:$v"
    done
    success "Completed tagging docker images"
}

function push_images() {
    info "Pushing docker images"
    for v in "${IMAGE_VERSIONS[@]}"; do
        docker push "${REGISTRY_URL}${BASE}:$v" || error_exit "Failed to push ${REGISTRY_URL}${BASE}:$v"
    done
    success "Completed pushing docker images"
}

while getopts 'v:p' opt
do
    case "${opt}" in
        v )
            IMAGE_VERSIONS+=("$OPTARG")
            while [ "$OPTIND" -le "$#" ] && [ "${!OPTIND:0:1}" != "-" ]; do
                IMAGE_VERSIONS+=("${!OPTIND}")
                OPTIND="$(( OPTIND + 1 ))"
            done
            ;;
        p )
            PUSH="true"
            ;;
        ? )
            usage
            ;;
        * )
            usage
            ;;
    esac
done
shift $(( OPTIND - 1 ))

if [[ "${PUSH}" == "true" && -z ${IMAGE_VERSIONS[*]} ]]; then
    error_exit "The push (-p) option must be paired with tag versions (-v)"
fi

case $1 in
    ${BASE} )
        build_base
        ;;
    ${HELP} )
        usage
        ;;
    * )
        usage
        ;;
esac

if [[ -n ${IMAGE_VERSIONS[*]} ]]; then
    tag_images
fi

if [[ "${PUSH}" == "true" ]]; then
    push_images
fi
