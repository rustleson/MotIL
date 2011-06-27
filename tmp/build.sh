#!/bin/sh
SDK_PATH=$HOME/install/flex4 # your Flex SDK absolute path
#JRE_PATH=$HOME/install/jre1.6.0_03 # your Java Runtime Environment absolute path 

OPTS=-use-network=true
#PATH=$SDK_PATH:$JRE_PATH/bin:$PATH
$SDK_PATH/bin/mxmlc $OPTS -output phy_test.swf Main.as
$SDK_PATH/bin/flashplayerdebugger phy_test.swf
