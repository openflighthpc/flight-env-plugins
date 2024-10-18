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
export flight_ENV_orig_LD_LIBRARY_PATH="$LD_LIBRARY_PATH"
export flight_ENV_orig_BASH_ENV="$BASH_ENV"

export LD_LIBRARY_PATH=/opt/apps/flight/env/share/tcl/8.6.9/lib:$LD_LIBRARY_PATH

source /opt/apps/flight/env/share/modules/5.4.0/init/bash
source "${flight_ENV_dir}"/modules/modules.bash.rc
