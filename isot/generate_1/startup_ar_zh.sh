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
wait
	
#训练
CUDA_VISIBLE_DEVICES=0 nohup fairseq-train $orig/data-bin --arch transformer \
	--source-lang ${src} --target-lang ${tgt}  \
    --optimizer adam  --lr 0.001 --adam-betas '(0.9, 0.98)' \
    --lr-scheduler inverse_sqrt --max-tokens 4096  --dropout 0.3 \
    --criterion label_smoothed_cross_entropy  --label-smoothing 0.1 \
    --max-update 200000  --warmup-updates 4000 --warmup-init-lr '1e-07' \
    --keep-last-epochs 10 --num-workers 8 \
	--max-epoch 49 \
	--patience 8 \
	--save-dir ${model_dir}/checkpoints & 
tail -f nohup.out
wait


