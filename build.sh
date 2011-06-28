#!/bin/sh
SDK_PATH=$HOME/install/flex4 # your Flex SDK absolute path

OPTS=-debug=true
$SDK_PATH/bin/mxmlc $OPTS -output build/web/MotIL.swf -source-path=src src/Main.as
$SDK_PATH/bin/flashplayer build/web/MotIL.swf
