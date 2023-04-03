#!/bin/bash

function usage() {
  echo "Usage: ./bump_version.sh [major|minor|patch] [push]"
  echo "Bump the version number in the scripts and create a new git tag."
}

function update_version_string() {
  local OLD_VERSION=$1
  local NEW_VERSION=$2
  local FILE=$3

  sed -i "s/VERSION=\"${OLD_VERSION}\"/VERSION=\"${NEW_VERSION}\"/" $FILE
}

if [ $# -gt 2 ]; then
  usage
  exit 1
fi

INCREMENT_TYPE="$1"
PUSH_TAG="$2"

if [ "$INCREMENT_TYPE" == "push" ]; then
  PUSH_TAG="$INCREMENT_TYPE"
  INCREMENT_TYPE=""
fi

if [ ! -z "$INCREMENT_TYPE" ]; then
  VERSION_REGEX="([0-9]+)\.([0-9]+)\.([0-9]+)"

  LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null)
  if [ $? -ne 0 ]; then
    LATEST_TAG="v0.0.0"
  fi

  LATEST_VERSION=${LATEST_TAG#v}
  IFS='.' read -ra VERSION_PARTS <<< "$LATEST_VERSION"

  case "$INCREMENT_TYPE" in
    major)
      VERSION_PARTS[0]=$((VERSION_PARTS[0] + 1))
      VERSION_PARTS[1]=0
      VERSION_PARTS[2]=0
      ;;
    minor)
      VERSION_PARTS[1]=$((VERSION_PARTS[1] + 1))
      VERSION_PARTS[2]=0
      ;;
    patch)
      VERSION_PARTS[2]=$((VERSION_PARTS[2] + 1))
      ;;
    *)
      usage
      exit 1
      ;;
  esac

  NEW_VERSION="${VERSION_PARTS[0]}.${VERSION_PARTS[1]}.${VERSION_PARTS[2]}"
  NEW_TAG="v${NEW_VERSION}"

  update_version_string $LATEST_VERSION $NEW_VERSION transfer_glacier_deep_archive.sh
  update_version_string $LATEST_VERSION $NEW_VERSION delete_objects_and_remove_permissions.sh

  git add transfer_glacier_deep_archive.sh delete_objects_and_remove_permissions.sh
  git commit -m "Bump version to ${NEW_VERSION}"
  git tag $NEW_TAG
fi

if [ "$PUSH_TAG" == "push" ]; then
  git push origin --tags
  git push
fi
