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

tcl_v=8.6.15
tcl_mv=8.6
v=3.2.10
gw_v=1.5.6

env_stage "Verifying prerequisites"
if [ ! -d "${flight_ENV_ROOT}"/share/modules/${v} ]; then
  if [ ! -d ${flight_ENV_ROOT}/share/tcl/${tcl_v} ]; then
    if [ ! -f tcl${tcl_v}-src.tar.gz ]; then
      env_stage "Fetching prerequisite (tcl)"
      wget https://prdownloads.sourceforge.net/tcl/tcl${tcl_v}-src.tar.gz
    fi
    env_stage "Extracting prerequisite (tcl)"
    tar xzf tcl${tcl_v}-src.tar.gz
    env_stage "Building prerequisite (tcl)"
    cd tcl${tcl_v}/unix
    ./configure --prefix=${flight_ENV_ROOT}/share/tcl/${tcl_v}
    make
    env_stage "Installing prerequisite (tcl)"
    make install
    ln -s ${flight_ENV_ROOT}/share/tcl/${tcl_v}/bin/tclsh${tcl_mv} ${flight_ENV_ROOT}/share/tcl/${tcl_v}/bin/tclsh
    cd ../..
  fi
  tcl_params="--with-tcl=${flight_ENV_ROOT}/share/tcl/${tcl_v}/lib --with-tcl-ver=${tcl_mv} --without-tclx --with-tclx-ver=${tcl_mv}"
  if [ ! -f modules-${v}.tar.gz ]; then
    env_stage "Fetching prerequisite (modules)"
    wget https://sourceforge.net/projects/modules/files/Modules/modules-${v}/modules-${v}.tar.gz
  fi
  env_stage "Extracting prerequisite (modules)"
  tar xvf modules-${v}.tar.gz
  env_stage "Building prerequisite (modules)"
  cd modules-${v}
  CPPFLAGS="-DUSE_INTERP_ERRORLINE" ./configure \
          --disable-versioning \
          --prefix=${flight_ENV_ROOT}/share/modules/${v} $tcl_params
  make
  env_stage "Installing prerequisite (modules)"
  make install
  cd ..
  rm -f ${flight_ENV_ROOT}/share/modules/${v}/Modules/init/.modulespath
  touch ${flight_ENV_ROOT}/share/modules/${v}/Modules/init/.modulespath
fi

if [ ! -d "${flight_ENV_ROOT}/share/gridware/${gw_v}" ]; then
  if [ ! -f gridware-legacy-${gw_v}.tar.gz ]; then
    env_stage "Fetching prerequisite (gridware)"
    wget https://github.com/alces-flight/gridware-legacy/archive/stable.tar.gz -O gridware-legacy-${gw_v}.tar.gz
  fi
  env_stage "Extracting prerequisite (gridware)"
  tar xvf gridware-legacy-${gw_v}.tar.gz
  env_stage "Installing prerequisite (gridware)"
  mkdir -p "${flight_ENV_ROOT}/share/gridware/${gw_v}"
  cp -R gridware-legacy-stable/* "${flight_ENV_ROOT}/share/gridware/${gw_v}"
  cd ${flight_ENV_ROOT}/share/gridware/${gw_v}
  export PKG_CONFIG_PATH="${flight_ROOT}"/opt/runway/embedded/lib/pkgconfig:/usr/lib64/pkgconfig
  if [ -x ${flight_ROOT}/bin/flexec ]; then
    ${flight_ROOT}/bin/flexec bundle install --path=vendor --without=development --without=test --local
  else
    bundle install --path=vendor --without=development --without=test --local
  fi
fi

if [ ! -d "${flight_ENV_ROOT}/share/gridware/repos/main" ]; then
  env_stage "Configuring repo: main"
  mkdir -p "${flight_ENV_ROOT}/share/gridware/repos/main"
  cat <<EOF > "${flight_ENV_ROOT}/share/gridware/repos/main/repo.yml"
################################################################################
##
## Gridware repository configuration
## Copyright (c) 2019-present Alces Flight Ltd
##
################################################################################
---
:source: https://github.com/alces-software/gridware-packages-main.git
:schema: 2
EOF
fi

binary_placeholder="${flight_ENV_gridware_binary_placeholder:-/opt/apps/flight/env/u}"
if [ -d "${binary_placeholder}" ]; then
  if [ "$(echo -n "${binary_placeholder}" | wc -c)" != "22" ]; then
    binary_enabled=false
  else
    binary_enabled=true
  fi
else
  binary_enabled=false
fi

env_stage "Installing Gridware in environment: ${name}"
mkdir -p ${flight_ENV_ROOT}/${name}/gridware/depots
mkdir -p ${flight_ENV_ROOT}/${name}/gridware/etc
mkdir -p ${flight_ENV_CACHE}/gridware/logs/${name}
mkdir -p ${flight_ENV_CACHE}/gridware/archives
mkdir -p ${flight_ENV_CACHE}/gridware/src
cat <<EOF > ${flight_ENV_ROOT}/${name}/gridware/gridware.bash.rc
module use ${flight_ENV_ROOT}/${name}/gridware/local/el7/etc/modules
export ALCES_CONFIG_PATH="${flight_ENV_ROOT}/${name}/gridware/etc"
export cw_DIST=el7
export flight_GRIDWARE_binary_enabled=${binary_enabled}
EOF
cat <<EOF > ${flight_ENV_ROOT}/${name}/gridware/gridware.tcsh.rc
module use ${flight_ENV_ROOT}/${name}/gridware/local/el7/etc/modules
setenv ALCES_CONFIG_PATH "${flight_ENV_ROOT}/${name}/gridware/etc"
setenv cw_DIST el7
setenv flight_GRIDWARE_binary_enabled ${binary_enabled}
EOF
cat <<EOF > ${flight_ENV_ROOT}/${name}/gridware/etc/gridware.yml
################################################################################
##
## Alces Gridware - Gridware packager configuration
## Copyright (c) 2012-2016 Alces Software Ltd
## Copyright (c) 2016-2023 Alces Flight Ltd
##
################################################################################
---
:log_root: ${flight_ENV_CACHE}/gridware/logs/${name}
:repo_paths:
 - ${flight_ENV_ROOT}/share/gridware/repos/main
# - ${flight_ENV_ROOT}/share/gridware/repos/local
:depotroot: ${flight_ENV_ROOT}/${name}/gridware
:default_depot: local
:archives_dir: ${flight_ENV_CACHE}/gridware/archives
:buildroot: ${flight_ENV_CACHE}/gridware/src
:fallback_package_url: https://s3-eu-west-1.amazonaws.com/alces-gridware-eu-west-1/upstream
:default_binary_url: https://s3-eu-west-1.amazonaws.com/alces-gridware-eu-west-1/dist
:fetch_timeout: 10
:prefer_binary: ${binary_enabled}
:use_default_params: false
:update_period: 3
:last_update_filename: .last_update
#:user_email: someone@example.com
EOF
cat <<EOF > ${flight_ENV_ROOT}/${name}/gridware/etc/params.yml
'apps/example':
  :optimize: true
'apps/example/1.0.1':
  :optimize: false
EOF
cat <<EOF > ${flight_ENV_ROOT}/${name}/gridware/etc/whitelist.yml
---
:users: []
:packages: []
:repos: []
EOF
depot="$(echo "${flight_ENV_ROOT}/${name}/gridware/depots/$(uuid -v4 | cut -f1 -d'-')")"
dname="local"
cd ${flight_ENV_ROOT}/${name}/gridware
ln -snf "${depot}" "${dname}"
mkdir -p "${depot}/el7/pkg" "${depot}/el7/etc"
cp -R ${flight_ENV_ROOT}/share/gridware/${gw_v}/etc/depotskel/* "${depot}/el7/etc"

if [ "${binary_enabled}" == "true" ]; then
   udepot="$(echo ${binary_placeholder}/$(uuid -v4 | cut -c1-6))"
   ln -snf "${udepot}" "${depot}"/.gridware-userspace
   ln -snf "${depot}" "${udepot}"
fi

export HOME=${HOME:-$(eval echo "~$(whoami)")}
export ALCES_CONFIG_PATH="${flight_ENV_ROOT}/${name}/gridware/etc"
export cw_DIST=el7
if [ -x "${flight_ROOT}"/bin/ruby ]; then
  RUBY="${flight_ROOT}"/bin/ruby
else
  RUBY="$(which ruby &>/dev/null)"
fi
cat <<RUBY | "${RUBY}"
ENV['BUNDLE_GEMFILE'] ||= "${flight_ENV_ROOT}/share/gridware/${gw_v}/Gemfile"
\$: << "${flight_ENV_ROOT}/share/gridware/${gw_v}/lib"

require 'rubygems'
require 'bundler'
Bundler.setup(:default)

require 'alces/packager/package'

system_gcc_opts = {
  type: 'compilers',
  name: 'gcc',
  version: \`/usr/bin/gcc -dumpversion\`.chomp,
  default: true,
  path: 'compilers/gcc/system'
}

DataMapper.repository(:'${dname}') do
  Alces::Packager::Package.create!(system_gcc_opts)
end
RUBY
