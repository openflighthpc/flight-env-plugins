#!/bin/bash
# =============================================================================
# Copyright (C) 2019-present Alces Flight Ltd.
#
# This file is part of Flight Environment.
#
# This program and the accompanying materials are made available under
# the terms of the Eclipse Public License 2.0 which is available at
# <https://www.eclipse.org/legal/epl-2.0>, or alternative license
# terms made available by Alces Flight Ltd - please direct inquiries
# about licensing to licensing@alces-flight.com.
#
# Flight Environment is distributed in the hope that it will be useful, but
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR
# IMPLIED INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OR CONDITIONS
# OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY OR FITNESS FOR A
# PARTICULAR PURPOSE. See the Eclipse Public License 2.0 for more
# details.
#
# You should have received a copy of the Eclipse Public License 2.0
# along with Flight Environment. If not, see:
#
#  https://opensource.org/licenses/EPL-2.0
#
# For more information on Flight Environment, please visit:
# https://github.com/openflighthpc/flight-env
# ==============================================================================
set -e

flight_ENV_ROOT=${flight_ENV_ROOT:-${flight_ROOT}/var/lib/env}
flight_ENV_CACHE=${flight_ENV_CACHE:-${flight_ROOT}/var/cache/env}
flight_ENV_BUILD_CACHE=${flight_ENV_BUILD_CACHE:-${flight_ROOT}/var/cache/env/build}
name=$1

if [ -z "$name" ]; then
  echo "error: environment name not supplied"
  exit 1
fi

# create directory structure
mkdir -p ${flight_ENV_CACHE} ${flight_ENV_BUILD_CACHE} ${flight_ENV_ROOT}
cd ${flight_ENV_BUILD_CACHE}

v=0.22.2

env_stage "Verifying prerequisites"
if [ ! -f spack-v${v}.tar.gz ]; then
  env_stage "Fetching prerequisite (spack)"
  wget https://github.com/spack/spack/archive/v${v}.tar.gz -O spack-v${v}.tar.gz
fi

mkdir -p ${flight_ENV_ROOT}/${name}/spack
env_stage "Installing Spack hierarchy in environment: ${name}"
tar -C ${flight_ENV_ROOT}/${name}/spack -xzf spack-v${v}.tar.gz --strip-components=1
cd ${flight_ENV_ROOT}/${name}/spack
env_stage "Bootstrapping Spack environment"
if ! which python &>/dev/null; then
  sed -i -e 's,#!/usr/bin/env python$,#!/usr/bin/env python3,g' bin/spack
fi
bin/spack clean -m
bin/spack spec zlib
