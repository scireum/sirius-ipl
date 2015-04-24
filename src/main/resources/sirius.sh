#!/bin/bash
##############################################################################
# Made with all the love in the world
# by scireum in Remshalden, Germany
#
# Copyright by scireum GmbH
# http://www.scireum.de - info@scireum.de
##############################################################################
#
# Start / Stop script for SIRIUS applications
#
# Can be used to start or stop sirius based applications. This is compatible
# with SYSTEM V init.d
#
# A custom configuration can be provided via config.sh as this file should
# not be modified, since it's part of the release.
#
##############################################################################
### BEGIN INIT INFO
# Provides:          sirius
# Required-Start:    $remote_fs $syslog $network
# Required-Stop:     $remote_fs $syslog $network
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Starts the sirius application at boot time.
# Description:       Enables the sirius application provided in this directory.
### END INIT INFO

echo ""
echo "SIRIUS Launch Utility"
echo "====================="
echo ""

# Contains the java command to execute in order to start the system.
# By default, we assume that java is present in the PATH and can therefore
# be directly started.
JAVA_CMD="java"
CMD_SUFFIX=""

# Shutdown port used to signal the application to shut down. Used different
# ports for different apps or disaster will strike !
SHUTDOWN_PORT="9191"

# File used to pipe all stdout and stderr output to
STDOUT="logs/stdout.txt"

# Enable authbind so that apps can use ports < 1024
# To enabled port 80:
# cd /etc/authbind/byport
# touch 80
# chown USER:USER
# chmod 700 80
LD_PRELOAD="/usr/lib/authbind/libauthbind.so.1"

if [ -z "$SIRIUS_HOME" ]; then
    SIRIUS_HOME="$(dirname "$(readlink -f "$0")")"
fi
cd $SIRIUS_HOME

if [ -f config.sh ]; then
	echo "Loading config.sh..."
	source config.sh
else
	echo "Use a custom config.sh to override the settings listed below"
fi

if [ -z "$JAVA_XMX" ]; then
    JAVA_XMX="1024m"
fi

if [ -z "$JAVA_OPTS" ]; then
    JAVA_OPTS="-server -Xmx$JAVA_XMX -Djava.net.preferIPv4Stack=true"
fi

echo ""
echo "SERVICE:       $SERVICE"
echo "SIRIUS_HOME:   $SIRIUS_HOME"
echo "JAVA_CMD:      $JAVA_CMD"
echo "JAVA_OPTS:     $JAVA_OPTS"
echo "SHUTDOWN_PORT: $SHUTDOWN_PORT"
echo "STDOUT:        $STDOUT"
echo "USER_ID:       $USER_ID"
echo ""

case "$1" in
stop|restart|patch)
    echo "Stopping Application..."
	$JAVA_CMD -Dkill=true -Dport=$SHUTDOWN_PORT IPL
    ;;

esac

case "$1" in
patch)
    if [ -z "$ARTIFACT" ]; then
        echo "Please fill ARTIFACT in config.sh"
        exit 1
    fi
    $JAVA_CMD SDS pull $ARTIFACT
    ;;

esac

case "$1" in
start|restart|patch)
	echo "Starting Application..."
   	$JAVA_CMD $JAVA_OPTS -Dport=$SHUTDOWN_PORT IPL &> $STDOUT $CMD_SUFFIX &
    ;;

show)
    ps -AF | grep IPL | grep -v grep
    ;;

logs)
    less $SIRIUS_HOME/logs/application.log
    ;;

install)
    if [ -z "$SERVICE" ]; then
        echo "Please fill SERVICE in config.sh"
        exit 1
    fi

    echo "Installing as service $SERVICE"
    sudo ln -s $SIRIUS_HOME/sirius.sh /etc/init.d/$SERVICE
    echo "Installing as utility $SERVICE"
    sudo ln -s $SIRIUS_HOME/sirius.sh /usr/local/bin/$SERVICE
    echo "Updating rc.d scripts for autostart"
    sudo update-rc.d $SERVICE defaults
    ;;

uninstall)
    if [ -z "$SERVICE" ]; then
        echo "Please fill SERVICE in config.sh"
        exit 1
    fi

    echo "Removing service $SERVICE"
    sudo unlink /etc/init.d/$SERVICE
    echo "Removing utility $SERVICE"
    sudo unlink /usr/local/bin/$SERVICE
    echo "Removing autostart"
    sudo update-rc.d $SERVICE remove
    ;;

stop)
    ;;

*)
    echo "Usage: sirius.sh start|stop|restart|show|logs|install|uninstall|patch"
    exit 1
    ;;

esac
