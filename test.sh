#!/usr/bin/bash


# = 与 == 在 [ ] 中表示判断(字符串比较)时是等价的，例如：
# 在 (( )) 中 = 表示赋值， == 表示判断(整数比较)，它们不等价，比如

printf_test(){
   local val
   local mask
   local status
    echo "printf_test"
}


val=0xff
mask=0x04
#statu=$($mask & $val)
statu=$(($val & $mask))
echo "$statu"
echo "$val"
echo "$mask"
if (($statu == 0x5)); then
    echo "true"
else
    echo "fail"
fi

if [ $statu == '0x4' ]; then
    echo "true"
else
    echo "fail"
fi