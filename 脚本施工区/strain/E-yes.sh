#!/bin/bash
#欢迎使用者根据自身使用情况进行更改
#建议使用vscode对该脚本进行编辑
#使用前，一定要先把所有的sbatch后面的脚本名改成你自己的！！！！！！！
#使用前，一定先把注释里面自定义相关的都好好看看！！！！！、
#本脚本默认你在当前文件夹使用vaspkit生成了所有相关的文件与目录
#本脚本需要你的任务提交脚本在当前目录
#作者 DaMin93381 Lanzhou University   联系方式: damin7512476@gmail.com  b站主页：https://space.bilibili.com/39538868   
a1="lalala.txt"             #squeue暂存文件名
b1="vasp-DM"                #读取你的任务在squeue中输出的关键词，很重要！！！！
bbb="vasp-DM.sh"            #你的提交脚本的全称，很重要！！！！
interval1=10                #重新读取squeue的运行间隔，秒为单位，根据你任务跑的快慢灵活调整，比较重要！！
num1=2                      #控制你当前脚本名称下同时提交的任务数量
for j in $(find . -type d -name "C*")         #遍历所有C开头的目录，计算前建议检查当前目录下是否有其它C开头的无关文件！！！   循环(1begin)
do
cd $j                                         #进入Cxx目录
for i in $(find . -type d -name "strain*")       #对除了未应变的文件夹之外的进行循环，注意检查！！！！                      循环(2begin) 
do
cd $i                                            #进入strain文件夹
sbatch ../../$bbb                                #提交任务
squeue > ../lalala.txt                           #输出当前任务列表信息到Cxx目录中暂存文件中
cd ..                                            #返回上一目录
mc=$(grep -c "$b1" "$a1")                        #读取任务列表中你的任务个数，并将其存储在mc变量中
until [ "$mc" -lt "$num1"  ]                        #这步控制你最多提交两个任务                                            循环(3begin)
do
squeue > lalala.txt                                 #将squeue输出信息导入暂存文件夹中                                       
mc=$(grep -c "$b1" "$a1")                           #读取任务列表中你的任务个数，并将其存储在mc变量中                          
sleep $interval1                                    #这里控制你重新输出squeue信息到暂存文件中的时间间隔         
done #                                                                                                                   循环(3end)
done                                             #一个Cxx算完了！！                                                       循环(2end)
rm lalala.txt                                 #把暂存squeue信息的文本文件删掉
cd ..                                         #返回Cxx所在目录
done #                                                                                                                   循环(1end)

exit 1

#written by vscode 2023年12月9日16:50:03
#幽雅に咲かせ、墨染の桜!
