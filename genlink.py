#!/usr/bin/env python
import os

file_name="spx_info.log"
folder="workspace2/source"
cmd="rm -rf "+folder
os.system(cmd)
cmd="mkdir -p "+folder
os.system(cmd)
with open(file_name,'r') as file_to_read:
	while True:
		lines = file_to_read.readline()
		if not lines:
			break
			pass
		#print lines
		rawpath,withvername=lines.strip().split(" : ")
		#print rawpath
		#print withvername
                withvername=withvername.replace(r".spx","")
		#print withvername
		cmd="ln -sf " + os.getcwd() + "/" + rawpath + " "+ folder + "/" + withvername
		#print cmd
		os.system(cmd)
'''
#FIX ME
removeObj = [
"spx_src/core/common/packages/libcrc32c-src/libcrc32c-src",
"spx_src/core/common/packages/sys_libsqlite3-src/sys_libsqlite3-src",
"spx_src/core/common/packages/sys_python_argparse-src/sys_python_argparse-src",
"spx_src/featurepack/fp1/packages/fp1-wolf-platform/packages/amithermalconfig-ARM-AST2500-WolfPass-src/amithermalconfig-ARM-AST2500-WolfPass-src",
"spx_src/technologypack/nvme/packages/mctp/packages/MCTP_Support-ANY/MCTP_Support-ANY",
"spx_src/technologypack/nvme/packages/mctp/packages/libmctp-src/libmctp-src",
"spx_src/technologypack/nvme/packages/mctp/packages/mctp_dev-src/mctp_dev-src",
"spx_src/technologypack/nvme/packages/mctp/packages/mctpapp-src/mctpapp-src",
"spx_src/technologypack/nvme/packages/mctp/packages/mctpmain-src/mctpmain-src",
"spx_src/technologypack/nvme/packages/mctpi2c/packages/libmctpi2c-src/libmctpi2c-src",
"spx_src/technologypack/nvme/packages/smbus/packages/libsmb-src/libsmb-src",
"spx_src/technologypack/nvme/packages/smbus/packages/smbapp-src/smbapp-src"
]

for obj in removeObj:
	cmd = "unlink " + os.getcwd() + "/" + obj
	#print cmd
	#os.system(cmd)
'''

basepath=""
process = os.popen("repo status 2>/dev/null")
for line in process.readlines():
	if line.strip().startswith('project spx_src') == True:
		basepath=line.strip().split()[1]
	if line.strip().startswith('--') == True:
		subpath = line.strip().split()[1]
		if basepath == "":
			continue
		else:
			fullpath = basepath + subpath
			cmd = "unlink " + os.getcwd() + "/" + fullpath
			#print cmd
			os.system(cmd)

os.system("repo status 2>/dev/null")
# remove unused link
os.system("ls -1 workspace/source/ > w_s_dirlist.txt")
os.system("ls -1 workspace2/source/ > w2_s_dirlist.txt")
os.system("diff w_s_dirlist.txt w2_s_dirlist.txt | grep '^>' | sed 's/> //g' > needunlink.txt")

with open("needunlink.txt",'r') as file_to_read:
	while True:
		lines = file_to_read.readline()
		if not lines:
			break
			pass
		foldername=lines.strip()
		cmd="unlink " + os.getcwd() + "/workspace2/source/" + foldername
		#print cmd
		os.system(cmd)

os.system("rm w_s_dirlist.txt w2_s_dirlist.txt needunlink.txt")
