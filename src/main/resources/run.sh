#!/bin/bash
##############################################################################
# Made with all the love in the world
# by scireum in Remshalden, Germany
#
# Copyright by scireum GmbH
# http://www.scireum.de - info@scireum.de
##############################################################################

echo ""
echo "SIRIUS Launch Utility"
echo "====================="
echo ""
if [ -z "$JAVA_XMX" ]; then
    echo "No JAVA_XMX present - using defaults..."
    JAVA_XMX="1024m"
fi

if [ -z "$JAVA_OPTS" ]; then
    echo "No JAVA_OPTS present - using defaults..."
    JAVA_OPTS="-server -Xmx$JAVA_XMX -Djava.net.preferIPv4Stack=true"
fi

echo "JAVA_OPTS:     $JAVA_OPTS"
echo ""
java $JAVA_OPTS IPL
