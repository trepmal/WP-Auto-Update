#!/bin/bash

# self-update wp-cli
wp --allow-root cli update --major --minor --patch --yes --quiet

if [ -z $1 ]; then
	path='';
else
	path=`readlink -f $1`
	path=" --path=$path"
fi

flags="$path --allow-root"

blogname=`wp $flags option get blogname`
bloghome=`wp $flags option get home`

logger "[WPAutoUpdate] $blogname | $bloghome"


 ####   ####  #####  ######
#    # #    # #    # #
#      #    # #    # #####
#      #    # #####  #
#    # #    # #   #  #
 ####   ####  #    # ######

checkupd=`wp $flags core check-update --format=yaml | grep 'version: ' | tr -d ' '`
if [ ! -z $checkupd ]; then
	updateto=${checkupd/version:/}

	coreupdate=`wp $flags core update --no-color | grep "^Success:" | tr -d '\n'`
	coreupdate=${coreupdate/Success: /}
	coreupdate=${coreupdate%.}

	logger "[WPAutoUpdate] Core update: ${coreupdate} to ${updateto}"

	dbupdate=`wp $flags core update-db --no-color | grep "^Success:" | tr -d '\n'`
	dbupdate=${dbupdate/Success: /}
	logger "[WPAutoUpdate] DB update: ${dbupdate}"

else
	logger "[WPAutoUpdate] Core update: WordPress has no pending updates"
fi


#####  #      #    #  ####  # #    #  ####
#    # #      #    # #    # # ##   # #
#    # #      #    # #      # # #  #  ####
#####  #      #    # #  ### # #  # #      #
#      #      #    # #    # # #   ## #    #
#      ######  ####   ####  # #    #  ####

pluginupdate=`wp $flags plugin update --all --dry-run --format=summary | grep "from version"`
pluginlist=''

if [ -z "$pluginupdate" ]; then
	pluginlist='No plugins updated';
else
	while read -r plugin; do
		pluginlist=$pluginlist"${plugin/ update from*/}, "
	done <<< "$pluginupdate"
fi

logger "[WPAutoUpdate] Plugin updates: ${pluginlist%, }"


##### #    # ###### #    # ######  ####
  #   #    # #      ##  ## #      #
  #   ###### #####  # ## # #####   ####
  #   #    # #      #    # #           #
  #   #    # #      #    # #      #    #
  #   #    # ###### #    # ######  ####

themeupdate=`wp $flags theme update --all --format=summary | grep "from version"`
themelist=''

if [ -z "$themeupdate" ]; then
	themelist='No themes updated';
else
	while read -r theme; do
		themelist=$themelist"${theme/ updated successfully*/}, "
	done <<< "$themeupdate"
fi

logger "[WPAutoUpdate] Theme updates: ${themelist%, }"


 ####  #      ######   ##   #    #    #    # #####
#    # #      #       #  #  ##   #    #    # #    #
#      #      #####  #    # # #  #    #    # #    #
#      #      #      ###### #  # #    #    # #####
#    # #      #      #    # #   ##    #    # #
 ####  ###### ###### #    # #    #     ####  #

logger "[WPAutoUpdate] `wp $flags cache flush`"
