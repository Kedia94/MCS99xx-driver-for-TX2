# MCS99xx-driver-for-TX2

It is specialized for 4 Ports Serial PCIe adapter (MCS9904)

If you use different number of serial ports, you can apply to your device easily by modifying 'mcs99xx' file 

- In my case, I have to unbind '0000:01:00.0' to '0000:01:00.3'
- You have to check '/sys/bus/pci/drivers/serial' and change it.

```sh
#/bin/sh

sh -c "echo 0000:01:00.0 > /sys/bus/pci/drivers/serial/unbind"
sh -c "echo 0000:01:00.1 > /sys/bus/pci/drivers/serial/unbind"
sh -c "echo 0000:01:00.2 > /sys/bus/pci/drivers/serial/unbind"
sh -c "echo 0000:01:00.3 > /sys/bus/pci/drivers/serial/unbind"
modprobe 99xx

exit 0
```



Original driver

- https://www.asix.com.tw/download.php?sub=driverdetail&PItemID=119
- Download: https://www.asix.com.tw/FrootAttach/driver/MCS99xx_LINUX_Driver_v3.1.0_Source.tar.gz
