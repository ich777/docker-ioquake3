#!/bin/bash
killpid="$(pgrep ioq3ded.x86_64)"
while true
do
	tail --pid=$killpid -f /dev/null
	kill $(pidof tail)
exit 0
done