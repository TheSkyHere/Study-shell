#!/bin/sh
date  >> ./dump_1512_6321_reg.log
echo "6321 port0 reg data"  >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x01    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x02    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x03    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x04    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x05    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x06    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x07    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x08    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x09    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x0a    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x0b    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x0c    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x0d    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x0e    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x0f    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x11    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x12    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x13    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x14    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x15    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x16    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x17    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x18    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x19    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x1a    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x1b    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x1c    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x1d    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x1e    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x1f    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x21    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x22    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x23    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x24    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x25    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x26    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x27    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x28    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x29    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x2a    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x2b    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x2c    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x2d    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x2e    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x10 -r 0x2f    >> ./dump_1512_6321_reg.log

echo "1512 reg data"  >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -w 0x19 -d 0x0000    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb416    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb800    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb801    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb802    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb803    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19    >> ./dump_1512_6321_reg.log

mdio-util -m 1 -p 0x1c -w 0x19 -d 0x0001    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb416    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb800    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb801    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb802    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb803    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19    >> ./dump_1512_6321_reg.log


mdio-util -m 1 -p 0x1c -w 0x19 -d 0x0012    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb416    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb814    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -r 0x19    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -w 0x19 -d 0x0000    >> ./dump_1512_6321_reg.log
mdio-util -m 1 -p 0x1c -w 0x18 -d 0xb416    >> ./dump_1512_6321_reg.log


