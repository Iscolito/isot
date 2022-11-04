#!/bin/sh
src=zh
tgt=ar
lang=zh_ar
prep=results
orig=resources
model_dir=models
test_dir=tests

if [[ $src == zh ]]
then
	#中文分词
	python -m jieba -d " " $test_dir/$lang.test > $test_dir/temp.txt
	mv $test_dir/temp.txt  $test_dir/$lang.test
fi

fairseq-interactive $orig/data-bin \
	--input $test_dir/$lang.test \
	--path $model_dir/checkpoints/checkpoint_best.pt \
	--remove-bpe >$prep/$lang.txt
wait
if [[ $tgt == zh ]]
then
	grep ^H $prep/$lang.txt | sort -n -k 2 -t '-' | cut -f 3 | sed -e 's/[[:space:]]//g' > $prep/temp.txt
fi
if [[ $tgt == ar ]]
then
	grep ^H $prep/$lang.txt | sort -n -k 2 -t '-' | cut -f 3 > $prep/temp.txt
fi
mv $prep/temp.txt $prep/$lang.rst
rm $prep/$lang.txt
