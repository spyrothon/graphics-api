# This script is manually placed on production servers to execute a deploy. It
# is versioned here for convenience, but no workflows or other automations will
# pick up changes to this file.

set -e
set -o nounset

###
# Config
###

# Name of the application being deployed
APP_NAME=graphics_api

# `GITHUB_SHA` is expected to be set by the script that invokes this script
# (e.g., Github Actions). It defines the release that this script will unpack
# and deploy as the current version.
VERSION=$GITHUB_SHA

# Directory used for symlinking the current release
CURRENT_DIR="/opt/$APP_NAME/current"

# Location where artifacts bundles are prepared
ARTIFACTS_DIR="~/artifacts/$APP_NAME"
# Name of the tarball containing the release, relative to the artifact itself
# e.g., '~/artifacts/graphics_api/<commitsha>/the.tar' -> './the.tar'
ARTIFACT_NAME="./$APP_NAME.tar.gz"

# Path to the binary for invoking the service
BINARY="./release/bin/$APP_NAME"
# File containing environment variable configuration
ENV_FILE="/opt/$APP_NAME/prod.env"
# Name of the file to redirect logs to
# Using a relative path will keep logs per-release
LOG_FILE="./server-$(date -u +"%Y%m%d%H%M%S").log"


###
# Script
###

# Extract the specified release
echo "> Extracting $ARTIFACT_NAME from $VERSION"
NEW_RELEASE_DIR="$ARTIFACTS_DIR/$VERSION"
cd $NEW_RELEASE_DIR
tar xf $ARTIFACT_NAME

# Load new environment configuration
echo "> Loading environment config from $(realpath $ENV_FILE)"
if [[ -f "$ENV_FILE" ]]; then
    export $(cat $ENV_FILE | xargs)
    # Test usage of the necessary environment variables for running the app
    echo "> -- Testing environment configuration"
    A=$PORT
    A=$RELEASE_COOKIE
    A=$API_DATABASE_URL
    A=$TWITCH_BROADCASTER_ID
    A=$TWITCH_CLIENT_ID
    A=$TWITCH_CLIENT_SECRET
else
    echo "> -- $(realpath $ENV_FILE) does not exist, aborting deployment"
    exit 1
fi


# Stop the previous deployment's process
echo "> Stopping previous deployment"
# This has to rely on exit codes to check if the old process has been killed yet.
cd $CURRENT_DIR
if [ -e $BINARY ]; then
    set +e
    # Request that the application stop
    $BINARY stop 2>/dev/null
    echo -n "> -- Waiting for process to stop."
    # Check if the pid exists
    $BINARY pid > /dev/null 2>&1
    while [ $? -ne 1 ]; do
        echo -n "."
        $BINARY pid > /dev/null 2>&1
    done
    echo ""
    set -e
else
    echo "> -- No existing release binary found, assuming no process is running."
fi

# Symlink this release as the current release
echo "> Linking $VERSION as the current release"
if [[ -e $CURRENT_DIR ]]; then
    echo "> -- Unlinking existing files from $CURRENT_DIR"
    rm -rf $CURRENT_DIR/*
fi
echo "> -- Creating links from $NEW_RELEASE_DIR to $CURRENT_DIR"
# This is a hardlink so that the system treats all releases like "the same set
# of files", rather than resolving them to versioned directories (which would
# endlessly spawn epmd daemons).
cp -rl $NEW_RELEASE_DIR/* $CURRENT_DIR

# Start the new deployment in the background.
echo "> Starting application version $VERSION"
cd $CURRENT_DIR
nohup $BINARY start > $LOG_FILE 2>&1 &
echo "> -- Logs are going to $(realpath $LOG_FILE)"


echo -e "\n\nRelease deployed successfully"
