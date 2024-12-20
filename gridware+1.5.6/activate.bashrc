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

export LD_LIBRARY_PATH="${flight_ENV_ROOT}"/share/tcl/8.6.9/lib:$LD_LIBRARY_PATH
export MODULERCFILE="${flight_ENV_ROOT}"/share/gridware/1.5.6/etc/modulerc
export MODULES_ALCES_TCL="${flight_ENV_ROOT}"/share/gridware/1.5.6/etc/modules-alces.tcl
export flight_GRIDWARE_root="${flight_ENV_ROOT}"/share/gridware/1.5.6
export cw_COLOUR=1
export cw_MODULES_VERBOSE=1
export MODULESROOT="${flight_ENV_ROOT}"/share/modules/3.2.10/Modules

source "${flight_ENV_ROOT}"/share/modules/3.2.10/Modules/init/bash
source "${flight_ENV_dir}"/gridware/gridware.bash.rc

gridware() {
  (
        export FLIGHT_CWD="$(pwd)"
        cd "${flight_ENV_ROOT}/share/gridware/1.5.6"
        if [ -x /opt/flight/bin/flexec ]; then
          /opt/flight/bin/flexec ruby bin/gridware "$@"
        else
          ruby bin/gridware "$@"
        fi
  )
}
export -f gridware

gr() {
  gridware "$@"
}
export -f gr

_colorize() {
  local flight_MODULES_colour=${flight_MODULES_colour:-1}
  local flight_MODULES_theme_prim=${flight_MODULES_theme_prim:-67}
  local flight_MODULES_theme_sec1=${flight_MODULES_theme_sec1:-68}
  local flight_MODULES_theme_sec2=${flight_MODULES_theme_sec2:-172}
  local flight_MODULES_theme_mid=${flight_MODULES_theme_mid:-127}
  local flight_MODULES_theme_comp=${flight_MODULES_theme_comp:-136}
  local l
  while read l; do
    case $l in
      *:)
        if [ "$flight_MODULES_colour" == "1" ]; then
          echo "--- [0;47;30m `echo $l | rev | cut -c2- | rev` [0m ---"
        else
          echo "---  `echo $l | rev | cut -c2- | rev`  ---"
        fi
        ;;
      *)
        if [ -z "$l" ]; then
          echo ""
        else
          i=0
          full=$l
          unset parts
          while true; do
            part=${l%%/*}
            l=${l#*/}
            parts[i++]=$part
            if [ "$l" = "$part" ]; then
              break
            fi
          done
          if [ "${parts[i-1]%%(default)}" == "${parts[i-1]}" ]; then
            default=0
          else
            default=1
            parts[i-1]=${parts[i-1]%%(default)}
          fi
          version_default=0
          c=0
          for part in "${parts[@]}"; do
            if [ "$flight_MODULES_colour" == "1" ]; then
              case $c in
                0)
                  echo -n "  [38;5;${flight_MODULES_theme_mid}m"
                  ;;
                1)
                  echo -n "/[38;5;${flight_MODULES_theme_sec2}m"
                  ;;
                2)
                  echo -n "/[38;5;${flight_MODULES_theme_prim}m"
                  ;;
                *)
                  echo -n "/[38;5;${flight_MODULES_theme_sec1}m"
                  ;;
              esac
              echo -n $part
              echo -n "[0m"
            else
              case $c in
                0)
                  echo -n "  $part"
                  ;;
                *)
                  echo -n "/$part"
                  ;;
              esac
            fi
            c=$(($c+1))
          done
          if [ $version_default == 1 -a $default == 1 ]; then
            if [ "$flight_MODULES_colour" == "1" ]; then
              echo -n " *[0;45;30mdefault[0m*"
            else
              echo -n " *default*"
            fi
          elif [ $version_default == 1 ]; then
            if [ "$flight_MODULES_colour" == "1" ]; then
              echo -n " *[0;46;30mdefault[0m*"
            else
              echo -n " *default*"
            fi
          elif [ $default == 1 ]; then
            if [ "$flight_MODULES_colour" == "1" ]; then
              echo -n " *[0;42;30mdefault[0m*"
            else
              echo -n " *default*"
            fi
          fi
          echo ""
        fi
        ;;
    esac
  done 1>&2
}
export -f _colorize

eval "$(echo "orig_module()"; declare -f module | tail -n +2)"
export -f orig_module

module() {
  case $1 in
    av*)
      shift
      for a in "$@"; do
        case $a in
          --human|-h|--long|-l|--terse|-t)
            orig_module avail "$@"
            return $?
            ;;
        esac
      done
      orig_module avail -t "$@" 2>&1 | _colorize
    ;;
    *)
      orig_module "$@"
    ;;
  esac
}

mod() {
  module "$@"
}
export -f mod
