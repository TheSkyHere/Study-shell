#!/bin/sh

echo "日期=$1======================================="
antiword $1* |grep "|D" |grep -i "轻型"   | grep -v "|       |       |       |      |      |       |" |awk -F '|' '{print $2}' |awk
echo "心率=$1========================================"
antiword $1* |grep "|D" |grep -i "轻型"   | grep -v "|       |       |       |      |      |       |" |awk -F '|' '{print $3}' 
echo "呼吸=$1========================================"
antiword $1* |grep "|D" |grep -i "轻型"   | grep -v "|       |       |       |      |      |       |" |awk -F '|' '{print $4}'
echo "体温=$1========================================"
antiword $1* |grep "|D" |grep -i "轻型"   | grep -v "|       |       |       |      |      |       |" |awk -F '|' '{print $6}'
echo "收缩压=$1========================================"
antiword $1* |grep "|D" |grep -i "轻型"   | grep -v "|       |       |       |      |      |       |" |awk -F '|' '{print $5}' |awk -F '/' '{print $1}' 
echo "舒张压=$1========================================"
antiword $1* |grep "|D" |grep -i "轻型"   | grep -v "|       |       |       |      |      |       |" |awk -F '|' '{print $5}' |awk -F '/' '{print $2}' 
echo "原始数据=$1========================================"
antiword $1* |grep "|D" |grep -i "轻型"   | grep -v "|       |       |       |      |      |       |"
echo "over=$1========================================"

