KDIR:=/lib/modules/$(shell  uname -r)/build/ 

DEBIAN_VERSION_FILE:=/etc/debian_version
DEBIAN_DISTRO:=$(wildcard $(DEBIAN_VERSION_FILE))
CURRENT=$(shell uname -r)
MAJORVERSION=$(shell uname -r | cut -d '.' -f 1)
MINORVERSION=$(shell uname -r | cut -d '.' -f 2)
SUBLEVEL=$(shell uname -r | cut -d '.' -f 3)


ifeq ($(MAJORVERSION),4)
MDIR=drivers/tty/serial
else
ifeq ($(MAJORVERSION),3)
MDIR=drivers/tty/serial
else
ifeq ($(MAJORVERSION),2)
ifneq (,$(filter $(SUBLEVEL),38 39))
MDIR=drivers/tty/serial
else
MDIR=drivers/serial
endif
else
MDIR=drivers/serial
endif
endif
endif

obj-m +=99xx.o

default:
	$(RM) *.mod.c *.o *.ko .*.cmd *.symvers
	$(MAKE) -C $(KDIR) SUBDIRS=${PWD} modules
	gcc -pthread select_BR.c -o select_BR
	gcc -pthread advanced_BR.c -o advanced_BR
	gcc -pthread gpio_99xx.c -o gpio_99xx

install:
	sudo mkdir -p /lib/modules/$(shell uname -r)/kernel/$(MDIR)
	sudo cp 99xx.ko  /lib/modules/$(shell uname -r)/kernel/$(MDIR)
	sudo depmod -A
	chmod +x mcs99xx
	sudo cp mcs99xx /etc/init.d/
	sudo update-rc.d mcs99xx defaults
	sudo ./mcs99xx

uninstall:
	sudo modprobe -r 99xx
	sudo rm -f /lib/modules/$(shell uname -r)/kernel/$(MDIR)/99xx.*
	sudo depmod -A
	sudo rm -f /etc/init.d/mcs99xx
	sudo update-rc.d -f mcs99xx remove

clean:
	$(RM) *.mod.c *.o *.ko .*.cmd *.symvers
	rm -rf .tmp_version* *~
	rm -rf Module.markers modules.*
	rm -f select_BR advanced_BR gpio_99xx
