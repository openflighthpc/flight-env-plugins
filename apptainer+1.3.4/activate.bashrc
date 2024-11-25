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
export flight_ENV_orig_PATH="$PATH"

APPTAINER_VER=1.3.4
SQUASHFS_VER=4.6.1
PATH="${flight_ENV_ROOT}"/share/apptainer/${APPTAINER_VER}/bin:"${flight_ENV_ROOT}"/share/squashfs/${SQUASHFS_VER}/bin:$PATH
export APPTAINER_CACHEDIR="${flight_ENV_dir}"/apptainer/cache

mkdir -p $APPTAINER_CACHEDIR

if [ ! -u "${flight_ENV_ROOT}/share/apptainer/${APPTAINER_VER}/libexec/apptainer/bin/starter-suid" ]; then
  mun=$(sysctl -n user.max_user_namespaces)
  if [ "$mun" == "0" ]; then
    red=$(tput setaf 1)
    bold=$(tput bold)
    reset=$(tput sgr0)
    cat <<EOF
${red}${bold}==========
 WARNING!
==========${reset}${bold}

/proc/sys/user/max_user_namespaces is set to 0.  It must be set to a
non-zero value to allow user-level access to Apptainer container
instance execution.

Please refer to '<%= Env::CLI::PROGRAM_NAME %> info apptainer' for more details.
${reset}
EOF
    unset red bold reset
  fi
  unset mun
fi
unset APPTAINER_VER SQUASHFS_VER
