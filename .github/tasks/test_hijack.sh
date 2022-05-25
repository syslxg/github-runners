#!/bin/bash
set -x
echo step 1
export lvar3=foobar
source $GITHUB_WORKSPACE/.github/tasks/tmate_helper.sh
hijack
echo step2
