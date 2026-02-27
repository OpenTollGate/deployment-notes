#!/bin/sh
#
# Prints the "Old algorithm supervisor password" for the
# given ZyXEL serial number.  This is the default root
# and supervisor password for e.g the ZyXEL NR7101

usage() {
	echo "Usage: $0 <serialnumber>" >&2
	echo "" >&2
	echo "Requires qemu-arm-static or qemu-arm in PATH. On Debian:" >&2
	echo "  apt install qemu-user-static" >&2
	echo "On Redhat:" >&2
	echo "  yum install qemu-user" >&2
	exit 1
}

QEMUBIN=qemu-arm-static
type $QEMUBIN >/dev/null 2>&1 || QEMUBIN=qemu-arm


[ -n "$1" ] && type $QEMUBIN >/dev/null 2>&1 || usage
(
 cd $(dirname $0)
 $QEMUBIN -E SERIAL=$1 -E LD_PRELOAD=./libhook.so ./getpassword|sed -ne 's/^Old algorithm super.*\.//p'
)

