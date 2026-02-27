# ZyXEL supervisor password calculator #

This is a stripped down bare bones version of the QEMU image found at
https://mega.nz/file/uMhTAJhB#hblDygWOM7ki3JBq2p36O0w05gbM0COgn8fLYRzLkNA

Thanks and all credits go to the users andreacos92, maximuz and
bovirus of the hwupgrade.it forum. Ref
https://www.hwupgrade.it/forum/showpost.php?p=45932456&postcount=2

The original documentation is included as README.original

This version contains only the necessary library files and a modified
getpassword binary, allowing it to be run outside a chroot or virtual
machine.  The binary was modified as follows:

	sed -i -e 's,/lib/ld-uClibc.so.0,\.////ld-uClibc.so.0,' getpassword 

pointing to the current directory for the loader, whichout changing the
path length.  This would not have been necessary if ld-uClibc.so.0 was
built with LDSO_STANDALONE_SUPPORT enabled.  But it usually isn't. and
this solution seemed easiest...

## Prerequisites ##

This depends on qemu-arm-static, which on Debian is part of the
qemu-user-static package.  Or it can run unter qemu-arm from the RHEL
qemu-user package.

## Usage ##

	./getsupervisor.sh serial

Example

	./getsupervisor.sh S2000G1234567
	58993e8c

The output is the default supervisor/root password for devices using
ZyXELs "Old algorithm".  See the source of the shell script if you
need other types of passwords for your device.


## Source ##

I have been unable to locate the source of the getpassword and libhook.so
binaries.  Please let me know if you have these.

Most of the other libraries are only available in binary form from ZyXEL.
These copies are collected from a VMG8825-B50B image, which uses a
Broadcom ARM based SoC.  The generated passwords are however valid on
other ZyXEL devices, like the NR7101 using a Mediatek MIPS based SoC.


## Contact ##

Responsible fo this file and repackaging only:
Bjørn Mork <bjorn@mork.no>
