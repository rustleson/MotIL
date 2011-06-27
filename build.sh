#!/bin/sh
SDK_PATH=$HOME/install/flex4 # your Flex SDK absolute path
#JRE_PATH=$HOME/install/jre1.6.0_03 # your Java Runtime Environment absolute path 

OPTS=-debug=true
#PATH=$SDK_PATH:$JRE_PATH/bin:$PATH
$SDK_PATH/bin/mxmlc $OPTS -output build/web/MotIL.swf -source-path=src src/Main.as
$SDK_PATH/bin/flashplayer build/web/MotIL.swf
