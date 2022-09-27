#! /usr/bin/env bash

set -x

: "${GITHUB_EVENT_PATH:-''}"

function main() {
  local issue_body
  #issue_body="$(jq -r '.issue.body' "${GITHUB_EVENT_PATH}")"
  issue_body="(https://docs.google.com/forms/d/1Bbl4jvNbKLPym6ePh1zxi85u9yHZ0i3i1B8p7mGO6QY/viewform?edit_requested=true)._

- [x] 3.0
- [x] 2.13 (N)
- [ ] 2.12
- [ ] 2.11
- [ ] 2.10
- [x] 2.7

### What code changes need to get pulled in?"

  local state_of_development
  if grep -i "\[x\] Yes, it is ready to go into the next train" <<< "${issue_body}" > /dev/null; then
    state_of_development=true
  else
    state_of_development=false
  fi

  local type_of_change
  if grep -i "\[x\] Feature (the change introduces a new feature)" <<< "${issue_body}" > /dev/null; then
    type_of_change='Feature'
  elif grep -i "\[x\] Feature Improvement (the change expands an existing feature)" <<< "${issue_body}" > /dev/null; then
    type_of_change='Feature Improvement'
  elif grep -i "\[x\] Bug Fix (the change addresses a defect)" <<< "${issue_body}" > /dev/null; then
    type_of_change='Bug Fix'
  elif grep -i "\[x\] Security Fix (the change has security implications)" <<< "${issue_body}" > /dev/null; then
    type_of_change='Security Fix'
  elif grep -i "\[x\] None (the change should not be included in the release notes)" <<< "${issue_body}" > /dev/null; then
    type_of_change='None'
  fi

  local breaking_change
  if grep -i "\[x\] Yes: This is a breaking change." <<< "${issue_body}" > /dev/null; then
    breaking_change=true
  else
    breaking_change=false
  fi

  local tiles
  if grep -i "\[x\] TAS/SF-TAS - Tanzu Application Service and Small Footprint TAS" <<< "${issue_body}" > /dev/null; then
    tiles=$tiles"tas,"
  fi
  if grep -i "\[x\] IST - Isolation Segment" <<< "${issue_body}" > /dev/null; then
    tiles=$tiles"ist,"
  fi
  if grep -i "\[x\] TASW - Tanzu Application Service for Windows" <<< "${issue_body}" > /dev/null; then
    tiles=$tiles"tasw,"
  fi
  tiles=$(echo $tiles | sed 's/,$//')

echo $issue_body
egrep -i "\[x\] [0-9]+\.[0-9]+" <<< "${issue_body}"
egrep -i "\[x\] [0-9]\.[0-9]" <<< "${issue_body}"
grep -i "\[x\] [0-9]\.[0-9]" <<< "${issue_body}"
grep -i "\[x\] [0-9].[0-9]" <<< "${issue_body}"
grep -i "\[x\] 2." <<< "${issue_body}"

  local product_versions versions_checked
  if egrep -i "\[x\] \d+\.\d+" <<< "${issue_body}" > /dev/null; then
    versions_checked=$(egrep -i "\[x\] \d+\.\d+" <<< "${issue_body}")
  fi
  if [[ -n $versions_checked ]]; then
    versions_checked=$(echo $versions_checked | tr -d '\n' | tr -d '\-\[xX\](N)' | tr -d '\r')
    IFS=' ' read -r -a arr_version <<< "$versions_checked"
    for version in "${arr_version[@]}"
    do
        product_versions+="$version,"
    done
    product_versions=$(echo $product_versions | sed 's/,$//')
  fi

  echo "State of Development: $state_of_development"
  echo "Type of Change: $type_of_change"
  echo "Breaking Change?: $breaking_change"
  echo "Tiles: $tiles"
  echo "Versions: $product_versions"

  local labels
  if [[ -z $tiles || -z $product_versions ]]; then
    labels="labels-pending"
  else
    labels=$tiles","$product_versions
  fi

  echo "Printing labels..."
  echo $labels
  echo "::set-output name=labels::$labels"
}

main "${PWD}"