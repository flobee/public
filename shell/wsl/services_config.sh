#!/bin/bash

# This is the place for the maintainer config ('services_config.sh')
#
# Don't touch.
#
# This file will not change or make services available except for
# documentation.
#
# Your config: "services_config_custom.sh" will init and overwrite values of
# this file and is ignored for git.
#
# Create a copy of "services_config_custom.sh-dist" to "services_config_custom.sh"
# and setup your config
#
#
# shellcheck disable=SC2034
declare -a SERVICES_LIST_START;
_IDX=-1;
