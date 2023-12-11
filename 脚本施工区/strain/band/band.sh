#!/bin/bash



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
mkdir band
cp CHGCAR POTCAR CONTCAR band/
cd band
cp CONTCAR POSCAR
vaspkit -task 303    #使用vaspkit生成能带计算高对称点
cp KPATH.in KPOINTS
vaspkit <incar.in              #生成INCAR文件
sed -i "3s/.*/ISPIN  = 2/" INCAR
sed -i "4s/.*/ICHARG =  11/" INCAR
sed -i "6s/.*/ENCUT  =  700/" INCAR
sed -i "8s/.*/LWAVE  = .FALSE./" INCAR
sed -i "12s/.*/LVHAR  = .TRUE./" INCAR
sed -i "27s/.*/NELM   =  90/" INCAR
sbatch ../../../$bbb                                #提交任务
squeue > ../../lalala.txt                           #输出当前任务列表信息到Cxx目录中暂存文件中
cd ../../                                           #返回上一目录
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
