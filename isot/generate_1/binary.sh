#!/bin/sh

#本脚本基于pytorch1.12.0+cu116(包括CUDA Tool Kit 11.6),fairseq 0.12.2,numpy 1.23.4的环境，请保证三者都处于已安装状态

src=ar
tgt=zh
lang=ar_zh
prep=results
orig=resources
model_dir=models
test_dir=tests
mkdir -p $prep

#训练预处理，生成的二进制文件保存在data-bin中
fairseq-preprocess --source-lang ${src} --target-lang ${tgt} \
    --trainpref $orig/train --validpref $orig/valid \
    --destdir $orig/data-bin