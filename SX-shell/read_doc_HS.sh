#!/bin/sh

echo "阳========================================="
for((i = 63; i < 123; i++))
do
    # echo "mato---$i"
    if [[ $i -eq 67  || $i -eq 76 || $i -eq 79 || $i -eq 113 || $i -eq 115 ]]; then
        i=$[$i+1]
    fi
    string=$(antiword $i* |grep -i "ORF1ab基因")
    string_date=$(antiword $i* |grep "|D" |grep -i "轻型"   | grep -v "|       |       |       |      |      |       |" |awk -F '|' '{print $2}')

    string_N=$(antiword $i* |grep -i -A 1 "ORF1ab基因")



    for((j = 0; j < 29; j++))
    do 
        string2=$(echo "$string" |grep "D$j ")
        # echo "$string2"

        string_N_1=$(echo "$string_N" |grep -A 1 "D$j " |grep -v "ORF1ab基因" |awk -F '|' '{print $4}')

        if [[ $string2 == *□√阳性* ]]; then 
            BW=2
            HS=1;
        elif [[ $string2 == *□√阴性* ]]; then 
            BW=2
            HS=0;
        else 
            BW=" "
            HS=" ";
        fi

        #抓取ORF1ab
        string3=$(echo "$string2" |grep "D$j " |awk -F '|' '{print $4}' |awk -F 'ORF1ab基因' '{print $2}')
        if [[ $string3 == *";"* ]]; then 
            string3=$(echo "$string3" |awk -F ';' '{print $1}')
        fi

        #抓取N基因
        string_N_1=$(echo "$string_N_1" |awk -F '因' '{print $2}')


        if [[ $string_date == *"D$j "* ]]; then 
            echo "D$j | $BW | $string3 | $string_N_1 | $HS"
        fi
    done
done

echo "over=$1========================================"
