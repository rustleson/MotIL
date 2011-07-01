#!/bin/sh
SDK_PATH=$HOME/install/flex4 # your Flex SDK absolute path
$SDK_PATH/bin/mxmlc -static-link-runtime-shared-libraries=true -debug=true -output build/web/MotIL.swf -source-path=src src/Main.as
$SDK_PATH/bin/flashplayer build/web/MotIL.swf
