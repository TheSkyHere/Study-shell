#!/bin/bash


parameter_str="all, bmc, cmm, fcb1, fcb2, psu1, psu2, psu3, psu4, lc1, lc2, lc3, lc4, lc5, lc6, lc7, lc8, come1, come2, come3, come4, come5, come6, come7, come8"
parameter_r_arr=(${parameter_str//,/ })

echo "MT------- ${parameter_r_arr[@]}"

parameter_r_arr[-1]="status"

echo "MT------- ${parameter_r_arr[@]}"

parameter_r_arr[-3]="status"

echo "MT------- ${parameter_r_arr[@]}"
echo "MT-------[0] ${parameter_r_arr[0]}"
echo "MT-------[-1] ${parameter_r_arr[-1]}"
echo "MT-------[-2] ${parameter_r_arr[-2]}"




parameter_w_arr=("${parameter_r_arr[@]}")
echo "MT------- ${parameter_w_arr[@]}"
unset parameter_w_arr[0]
unset parameter_w_arr[-1]
echo "MT------- ${parameter_w_arr[@]}"
echo "MT-------[0] ${parameter_w_arr[0]}"
echo "MT-------[-1] ${parameter_w_arr[-1]}"
echo "MT-------[-2] ${parameter_w_arr[-2]}"