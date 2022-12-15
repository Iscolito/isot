#!/bin/sh

#本脚本基于pytorch1.12.0+cu116(包括CUDA Tool Kit 11.6),fairseq 0.12.2,numpy 1.23.4的环境，请保证三者都处于已安装状态

src=ar
tgt=zh
lang=ar_zh
prep=results
orig=resources
model_dir=models
test_dir=tests

rm -rf nohup.out
#训练
#RTX Geforce 3060 Laptop最多--update-freq 2
CUDA_VISIBLE_DEVICES=0 nohup fairseq-train $orig/data-bin --arch transformer \
	--source-lang ${src} --target-lang ${tgt}  \
    --optimizer adam  --lr 0.001 --adam-betas '(0.9, 0.98)' \
    --lr-scheduler inverse_sqrt --max-tokens 4096  --dropout 0.3 \
    --criterion label_smoothed_cross_entropy  --label-smoothing 0.1 \
    --max-update 200000  --warmup-updates 4000 --warmup-init-lr '1e-07' \
    --keep-last-epochs 3 --num-workers 8 \
	--update-freq 2 \
	--max-epoch 200 \
	--fp16 \
	--scoring bleu \
	--patience 50 \
	--tensorboard-logdir Fairseq_Data-transformer \
	--eval-bleu \
    --eval-bleu-args '{"beam": 5, "max_len_a": 1.2, "max_len_b": 10}' \
    --eval-bleu-detok moses \
    --eval-bleu-remove-bpe \
    --eval-bleu-print-samples \
    --best-checkpoint-metric bleu --maximize-best-checkpoint-metric --use-old-adam \
	--save-dir ${model_dir}/checkpoints & 
tail -f nohup.out
wait



	