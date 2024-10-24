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
module purge

flight_ENV_vars=(module LOADEDMODULES _module module _module_avail _module_comgen_words_and_files _module_long_arg_list _module_not_yet_loaded MODULEPATH_modshare MODULEPATH _module_raw _module_savelist MODULES_CMD MODULESHOME switchml ENV BASH_ENV)
for flight_ENV_iter in "${flight_ENV_vars[@]}"; do
  unset $flight_ENV_iter
done
unset flight_ENV_iter flight_ENV_vars

PATH="${flight_ENV_orig_PATH}"
unset flight_ENV_orig_PATH
LD_LIBRARY_PATH="${flight_ENV_orig_LD_LIBRARY_PATH}"
unset flight_ENV_orig_LD_LIBRARY_PATH
BASH_ENV="${flight_ENV_orig_BASH_ENV}"
unset flight_ENV_orig_BASH_ENV
