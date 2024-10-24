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

flight_ENV_vars=(BASH_ENV clearMT EASYBUILD_INSTALLPATH EASYBUILD_MODULES_TOOL LMOD_CMD LMOD_DIR LMOD_PKG __LMOD_REF_COUNT_MODULEPATH LMOD_SETTARG_FULL_SUPPORT LMOD_sys LMOD_VERSION MANPATH _ml ml _module module _module_avail _module_describe _module_dir _module_disable _module_loaded_modules _module_loaded_modules_negated _module_long_arg_list _module_mcc _module_not_yet_loaded MODULEPATH MODULEPATH_ROOT _module_savelist MODULESHOME _module_spider _ModuleTable001_ _ModuleTable002_ _ModuleTable_Sz_ xSetTitleLmod)
for flight_ENV_iter in "${flight_ENV_vars[@]}"; do
  unset $flight_ENV_iter
done
unset flight_ENV_iter flight_ENV_vars
