#!/bin/sh


systemctl stop xyz.openbmc_project.dbussensor.service
i2cset -f -y 13 0x70 1
echo "NODE0: $(busctl call xyz.openbmc_project.ssif-host /xyz/openbmc_project/ssifhost xyz.openbmc_project.ssifhost ssif_conn yay 7 7 0xb8 0xa 0x00 0x4c 0xa5 0x02 0x0 | awk -F ' ' '{ print $7 }') W"
i2cset -f -y 13 0x70 2
echo "NODE1: $(busctl call xyz.openbmc_project.ssif-host /xyz/openbmc_project/ssifhost xyz.openbmc_project.ssifhost ssif_conn yay 7 7 0xb8 0xa 0x00 0x4c 0xa5 0x02 0x0 | awk -F ' ' '{ print $7 }') W"
i2cset -f -y 13 0x70 4
echo "NODE2: $(busctl call xyz.openbmc_project.ssif-host /xyz/openbmc_project/ssifhost xyz.openbmc_project.ssifhost ssif_conn yay 7 7 0xb8 0xa 0x00 0x4c 0xa5 0x02 0x0 | awk -F ' ' '{ print $7 }') W"
i2cset -f -y 13 0x70 8
echo "NODE3: $(busctl call xyz.openbmc_project.ssif-host /xyz/openbmc_project/ssifhost xyz.openbmc_project.ssifhost ssif_conn yay 7 7 0xb8 0xa 0x00 0x4c 0xa5 0x02 0x0 | awk -F ' ' '{ print $7 }') W"
systemctl start xyz.openbmc_project.dbussensor.service

sleep 10