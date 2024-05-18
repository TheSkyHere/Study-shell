#!/bin/bash
echo "******开始对当前目录下的所有C代码格式整理...******"
for file in `find . -type f \( -name "*.c" -o -name "*.h" \)`
do
    sed -i '/^$/{N;/\n$/D};'  $file
    sed -i '${/^$/d}' $file
    sed -i 's/if(/if (/g' $file
    sed -i 's/ ;/;/g' $file
    sed -i 's/for(/for (/g' $file
    sed -i 's/switch(/switch (/g' $file
    sed -i 's/while(/while (/g' $file
    sed -i 's/}while/} while/g' $file
    sed -i 's/do{/do {/g' $file
    sed -i 's/( /(/g' $file
    sed -i 's/ )/)/g' $file
    #astyle --mode=c --style=allman --suffix=none --indent-switches $file
done

for file in `find -name "Makefile"`
do
    sed -i '/^$/{N;/\n$/D};'  $file
    sed -i '${/^$/d}' $file
done
echo "******C代码格式整理完成******"
echo ""


echo "******开始对当前目录下的所有Python代码格式整理...******"
autopep8 --in-place --max-line-length 120 --aggressive --recursive .
echo "******Python代码格式整理完成******"