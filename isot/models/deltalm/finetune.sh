#!/bin/sh

#本脚本基于pytorch1.12.0+cu116(包括CUDA Tool Kit 11.6),fairseq 0.12.2,numpy 1.23.4的环境，请保证三者都处于已安装状态

prep=results
orig=resources
model_dir=models
test_dir=tests
PRETRAINED_MODEL=pretrained/model.pt

rm -rf nohup.out
touch nohup.out
#训练
#RTX Geforce 3060 Laptop最多--update-freq 2
CUDA_VISIBLE_DEVICES=0 nohup python train.py $orig/data-bin --arch deltalm_large \
	--pretrained-deltalm-checkpoint $PRETRAINED_MODEL \
    --optimizer adam  --lr 0.001 --adam-betas '(0.9, 0.98)' \
    --lr-scheduler inverse_sqrt --max-tokens 4096  --dropout 0.3 \
    --criterion label_smoothed_cross_entropy  --label-smoothing 0.1 \
    --max-update 200000  --warmup-updates 4000 --warmup-init-lr '1e-07' \
    --keep-last-epochs 3 --num-workers 8 \
    --max-source-positions 512 --max-target-positions 512 \
	--update-freq 8 \
	--max-epoch 200 \
	--fp16 \
	--scoring bleu \
	--patience 50 \
	--save-dir ${model_dir}/checkpoints >/dev/null 2>&1 &
 
tail -f nohup.out
wait



	
