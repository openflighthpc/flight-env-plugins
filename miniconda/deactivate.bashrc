# =============================================================================
# Copyright (C) 2024-present Alces Flight Ltd.
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
flight_ENV_vars=(__add_sys_prefix_to_path _CE_CONDA _CE_M conda __conda_activate CONDA_DEFAULT_ENV CONDA_EXE __conda_hashr CONDA_PREFIX CONDA_PROMPT_MODIFIER CONDA_PYTHON_EXE __conda_reactivate CONDA_SHLVL OLDPATH SYSP)
for flight_ENV_iter in "${flight_ENV_vars[@]}"; do
  unset $flight_ENV_iter
done
unset flight_ENV_iter flight_ENV_vars

PATH="${flight_ENV_orig_PATH}"
unset flight_ENV_orig_PATH
