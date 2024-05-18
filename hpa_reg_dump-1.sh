#!/bin/bash

systemctl stop sync-net-mon

echo  > ./dump_1512_6321_reg.log

gpiocli --shadow MDC_SW_BMC_SEL_N  set-direction out


gpiocli --shadow MDC_SW_BMC_SEL_N set-value 0
echo "dump ... 6321" >> ./dump_1512_6321_reg.log
# Port[0x10] dump...
mdio-util -m 1 -p 0x10 -r 0x0 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x1 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x2 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x3 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x4 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x5 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x6 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x7 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x8 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x9 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0xa >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0xb >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0xc >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0xd >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0xe >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0xf >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x10 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x11 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x12 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x13 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x14 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x15 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x16 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x17 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x18 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x19 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x1a >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x1b >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x1c >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x1d >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x1e >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x1f >> ./dump_1512_6321_reg.log



gpiocli --shadow MDC_SW_BMC_SEL_N set-value 1
echo "dump ... 1512" >> ./dump_1512_6321_reg.log
# Port[0x0] dump...
mdio-util -m 1 -p 0x0 -r 0x0 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x0 -r 0x1 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x0 -r 0x2 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x0 -r 0x3 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x0 -r 0x4 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x0 -r 0x5 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x0 -r 0x6 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x0 -r 0x7 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x0 -r 0x8 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x0 -r 0x9 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x0 -r 0xa >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x0 -r 0xb >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x0 -r 0xc >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x0 -r 0xd >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x0 -r 0xe >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x0 -r 0xf >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x0 -r 0x10 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x0 -r 0x11 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x0 -r 0x12 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x0 -r 0x13 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x0 -r 0x14 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x0 -r 0x15 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x0 -r 0x16 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x0 -r 0x17 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x0 -r 0x18 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x0 -r 0x19 >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x0 -r 0x1a >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x0 -r 0x1b >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x0 -r 0x1c >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x0 -r 0x1d >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x0 -r 0x1e >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x0 -r 0x1f >> ./dump_1512_6321_reg.log