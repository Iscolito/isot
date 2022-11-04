#!/bin/sh
pre=process_1
gen=generate_1
orig=resources
res=results
ex=extends
reset=reset.sh
src=src
trans=trans.sh

until
		echo =-=-=-=-=选择进行的操作=-=-=-=-=
		echo "1.检查扩展语料"
		echo "2.检查资源/输出文件夹"
		echo "3.重置模型构建文件夹"
		echo "4.重置预处理文件夹"
		echo "5.预处理结果转移"
		echo "6.阿译中资源准备"
		echo "7.阿译中预处理"
		echo "8.中译阿资源准备"
		echo "9.中译阿预处理"
		echo "10.清除缓存"
		echo "11.退出菜单"
		echo ---------------------------------
		echo	      mod by Iscolito
		echo =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		read input
		test $input = 11
		do
			case $input in
			1)ls $pre/$ex
			  echo;;
			  
			2)echo $pre/$orig:
			  ls $pre/$orig
			  echo $pre/$res:
			  ls $pre/$res
			  echo $gen/$orig:
			  ls $gen/$orig
			  echo $gen/$res:
			  ls $gen/$res;;
				
			3)rm -rf $gen/$orig/*
			  rm -rf $gen/$res/*
		      echo 已重置文件夹;;

			4)rm -rf $pre/$orig/*
			  rm -rf $pre/$res/*
		      echo 已重置文件夹;;
			
			5)cp -r $pre/$res/* $gen/$orig;;
			
			6)cp $src/ar_zh.ar $pre/$orig/valid.ar_zh.ar
			  cp $src/ar_zh.zh $pre/$orig/valid.ar_zh.zh
			  cp $pre/$ex/ar_zh_ex.ar.res $pre/$orig/train.ar_zh.ar
			  cp $pre/$ex/ar_zh_ex.zh.res $pre/$orig/train.ar_zh.zh
			  echo 资源准备完毕
			  echo 阿语训练集句数为:
			  wc -l $pre/$orig/train.ar_zh.ar
			  echo 中文训练集句数为:
			  wc -l $pre/$orig/train.ar_zh.zh;;
			
			7)cd $pre
			  bash pre_run_ar_zh.sh
			  cd ..;;
			  
			8)cp $src/zh_ar.ar $pre/$orig/valid.zh_ar.ar
			  cp $src/zh_ar.zh $pre/$orig/valid.zh_ar.zh
			  cp $pre/$ex/ar_zh_ex.ar.res $pre/$orig/train.zh_ar.ar
			  cp $sre/$ex/ar_zh_ex.zh.res $pre/$orig/train.zh_ar.zh
			  echo 资源准备完毕
			  echo 阿语训练集句数为:
			  wc -l $pre/$orig/train.zh_ar.ar
			  echo 中文训练集句数为:
			  wc -l $pre/$orig/train.zh_ar.zh;;
			
			9)cd $pre
			  bash pre_run_zh_ar.sh
			  cd ..;;
			
			10)rm -rf $pre/$res/tmp;;
			
			11)echo "请输入选择（1-11）"
			esac
			done
