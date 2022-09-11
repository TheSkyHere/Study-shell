#!/bin/sh


# echo "日期========================================"
# for((i = 63; i < 123; i++))
# do
#     if (($i == 67)); then
#         i=$[$i+1]
#     fi
#     if (($i == 76)); then
#         i=$[$i+1]
#     fi
#     if (($i == 79)); then
#         i=$[$i+1]
#     fi
#     if (($i == 113)); then
#         i=$[$i+1]
#     fi
#     if (($i == 115)); then
#         i=$[$i+1]
#     fi
#     antiword $i* |grep "|D" |grep -i "轻型"   | grep -v "|       |       |       |      |      |       |" |awk -F '|' '{print $2}' |awk -F 'D' '{print $2}'
# done

# echo "心率========================================="
# for((i = 63; i < 123; i++))
# do
#     if (($i == 67)); then
#         i=$[$i+1]
#     fi
#     if (($i == 76)); then
#         i=$[$i+1]
#     fi
#     if (($i == 79)); then
#         i=$[$i+1]
#     fi
#     if (($i == 113)); then
#         i=$[$i+1]
#     fi
#     if (($i == 115)); then
#         i=$[$i+1]
#     fi
#     antiword $i* |grep "|D" |grep -i "轻型"   | grep -v "|       |       |       |      |      |       |" |awk -F '|' '{print $3}' 
# done



# echo "呼吸========================================="
# for((i = 63; i < 123; i++))
# do
#     if (($i == 67)); then
#         i=$[$i+1]
#     fi
#     if (($i == 76)); then
#         i=$[$i+1]
#     fi
#     if (($i == 79)); then
#         i=$[$i+1]
#     fi
#     if (($i == 113)); then
#         i=$[$i+1]
#     fi
#     if (($i == 115)); then
#         i=$[$i+1]
#     fi
#     antiword $i* |grep "|D" |grep -i "轻型"   | grep -v "|       |       |       |      |      |       |" |awk -F '|' '{print $4}'
# done



# echo "收缩压========================================="
# for((i = 63; i < 123; i++))
# do
#     if (($i == 67)); then
#         i=$[$i+1]
#     fi
#     if (($i == 76)); then
#         i=$[$i+1]
#     fi
#     if (($i == 79)); then
#         i=$[$i+1]
#     fi
#     if (($i == 113)); then
#         i=$[$i+1]
#     fi
#     if (($i == 115)); then
#         i=$[$i+1]
#     fi
#     antiword $i* |grep "|D" |grep -i "轻型"   | grep -v "|       |       |       |      |      |       |" |awk -F '|' '{print $5}' |awk -F '/' '{print $1}' 
# done



# echo "舒张压========================================="
# for((i = 63; i < 123; i++))
# do
#     if (($i == 67)); then
#         i=$[$i+1]
#     fi
#     if (($i == 76)); then
#         i=$[$i+1]
#     fi
#     if (($i == 79)); then
#         i=$[$i+1]
#     fi
#     if (($i == 113)); then
#         i=$[$i+1]
#     fi
#     if (($i == 115)); then
#         i=$[$i+1]
#     fi
#     antiword $i* |grep "|D" |grep -i "轻型"   | grep -v "|       |       |       |      |      |       |" |awk -F '|' '{print $5}' |awk -F '/' '{print $2}'
# done


 
# echo "体温========================================="
# for((i = 63; i < 123; i++))
# do
#     if (($i == 67)); then
#         i=$[$i+1]
#     fi
#     if (($i == 76)); then
#         i=$[$i+1]
#     fi
#     if (($i == 79)); then
#         i=$[$i+1]
#     fi
#     if (($i == 113)); then
#         i=$[$i+1]
#     fi
#     if (($i == 115)); then
#         i=$[$i+1]
#     fi
#     antiword $i* |grep "|D" |grep -i "轻型"   | grep -v "|       |       |       |      |      |       |" |awk -F '|' '{print $6}'
# done



# echo "SPO2========================================="
# for((i = 63; i < 123; i++))
# do
#     if (($i == 67)); then
#         i=$[$i+1]
#     fi
#     if (($i == 76)); then
#         i=$[$i+1]
#     fi
#     if (($i == 79)); then
#         i=$[$i+1]
#     fi
#     if (($i == 113)); then
#         i=$[$i+1]
#     fi
#     if (($i == 115)); then
#         i=$[$i+1]
#     fi
#     antiword $i* |grep "|D" |grep -i "轻型"   | grep -v "|       |       |       |      |      |       |" |awk -F '|' '{print $7}' |awk -F '%' '{print $1}'
# done


 
# echo "尿量========================================="
# for((i = 63; i < 123; i++))
# do
#     if (($i == 67)); then
#         i=$[$i+1]
#     fi
#     if (($i == 76)); then
#         i=$[$i+1]
#     fi
#     if (($i == 79)); then
#         i=$[$i+1]
#     fi
#     if (($i == 113)); then
#         i=$[$i+1]
#     fi
#     if (($i == 115)); then
#         i=$[$i+1]
#     fi
#     antiword $i* |grep "|D" |grep -i "轻型"   | grep -v "|       |       |       |      |      |       |" |awk -F '|' '{print $8}'
# done



# echo "SOFA========================================="
# for((i = 63; i < 123; i++))
# do
#     if (($i == 67)); then
#         i=$[$i+1]
#     fi
#     if (($i == 76)); then
#         i=$[$i+1]
#     fi
#     if (($i == 79)); then
#         i=$[$i+1]
#     fi
#     if (($i == 113)); then
#         i=$[$i+1]
#     fi
#     if (($i == 115)); then
#         i=$[$i+1]
#     fi
#     antiword $i* |grep "|D" |grep -i "轻型"   | grep -v "|       |       |       |      |      |       |" |awk -F '|' '{print $9}'
# done




# echo "原始数据========================================="
# for((i = 63; i < 123; i++))
# do
#     echo "mato---$i"
#     if (($i == 67)); then
#         i=$[$i+1]
#     fi
#     if (($i == 76)); then
#         i=$[$i+1]
#     fi
#     if (($i == 79)); then
#         i=$[$i+1]
#     fi
#     if (($i == 113)); then
#         i=$[$i+1]
#     fi
#     if (($i == 115)); then
#         i=$[$i+1]
#     fi
#     antiword $i* |grep "|D" |grep -i "轻型"   | grep -v "|       |       |       |      |      |       |" 
# done



echo "test========================================="
for((i = 63; i < 123; i++))
do
    echo "mato---$i"
    if (($i == 67)); then
        i=$[$i+1]
    fi
    if (($i == 76)); then
        i=$[$i+1]
    fi
    if (($i == 79)); then
        i=$[$i+1]
    fi
    if (($i == 113)); then
        i=$[$i+1]
    fi
    if (($i == 115)); then
        i=$[$i+1]
    fi
    antiword 74* |grep -i  "□√鼻咽" 
done


echo "over=$1========================================"
