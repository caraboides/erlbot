#! /bin/sh

# JBot, a robot for RealTimeBattle
# written in Java, author:
# Ingo Beckmann, Dec. 1999,
# email: brain@nnTec.de

#GameOptions:
SEND_SIGNAL=0
SEND_ROTATION_REACHED=1
SIGNAL=2
USE_NON_BLOCKING=3

RTB_PATH=/home/christian/dev/rtb/ebin 
RobotName=martinMax
SLEEP=1

echo RobotOption $SEND_SIGNAL 0
echo RobotOption $SEND_ROTATION_REACHED 1
echo RobotOption $SIGNAL 0



# program options: 1=SLEEP in [ms], 2=Robot Name
exec erl -setcookie hansa1965 -noshell -pa $RTB_PATH -sname $RobotName -s main go 

