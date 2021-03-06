#!/usr/bin/env bash

# Copyright 2020 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o nounset
set -o pipefail

# Ensure the go tool exists and is a viable version.
verify_go_version() {
  if [[ -z "$(command -v go)" ]]; then
    cat >&2 <<EOF
Can't find 'go' in PATH, please fix and retry.
See http://golang.org/doc/install for installation instructions.
EOF
    return 2
  fi

  if [[ -z "${MINIMUM_GO_VERSION:-}" ]]; then
    return 0
  fi

  local go_version
  IFS=" " read -ra go_version <<< "$(go version)"
  if [[ "${MINIMUM_GO_VERSION}" != $(echo -e "${MINIMUM_GO_VERSION}\n${go_version[2]}" | sort -s -t. -k 1,1 -k 2,2n -k 3,3n | head -n1) && "${go_version[2]}" != "devel" ]]; then
    cat >&2 <<EOF
Detected go version: ${go_version[*]}.
Boskos requires ${MINIMUM_GO_VERSION} or greater.
Please install ${MINIMUM_GO_VERSION} or later.
EOF
    return 2
  fi
}

verify_go_version