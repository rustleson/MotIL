#!/bin/sh
SDK_PATH=$HOME/install/flex4 # your Flex SDK absolute path
$SDK_PATH/bin/mxmlc -static-link-runtime-shared-libraries=true -debug=false -compiler.omit-trace-statements=true -output build/downloads/MotIL/MotIL.swf -source-path=src src/Main.as
$SDK_PATH/bin/flashplayer build/downloads/MotIL/MotIL.swf
