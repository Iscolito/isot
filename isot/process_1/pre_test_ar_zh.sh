#!/bin/sh

echo 正在对测试集进行预处理工作，使用和训练集相同的BPE CODE

SCRIPTS=mosesdecoder/scripts
TOKENIZER=$SCRIPTS/tokenizer/tokenizer.perl
LC=$SCRIPTS/tokenizer/lowercase.perl
CLEAN=$SCRIPTS/training/clean-corpus-n.perl
BPEROOT=subword-nmt/subword_nmt
NORM_PUNC=$SCRIPTS/tokenizer/normalize-punctuation.perl
BPE_TOKENS=10000
AR_CUT=pre_ar

src=ar
tgt=zh
lang=ar_zh
orig=tests
prep=$orig/results
tmp=$prep/tmp
mkdir -p $prep $tmp 


#此处tokennizer将语言划分为标准形式需要对tokenizer.perl传参使用的语言
#可用语言库在mosesdecoder/scripts/share/nonbreaking_prefixes/
#使用http://www.loc.gov/standards/iso639-2/php/code_list.php以查看可用后缀

#分词处理
	#阿拉伯语采用nltk来进行分词，会将原词变为词根，暂不使用
	#python $AR_CUT/main.py $orig/$itype.$lang.ar
	#mv $orig/$itype.$lang.ar.tok $tmp/$itype.$lang.tok.ar
	#for l in zh; do
f=$lang.test
tok=$lang.tok.test
cat $orig/$f | \
perl $TOKENIZER -threads 8 -l $l > $tmp/$tok
echo ""
	
#perl $CLEAN -ratio 1.5 $tmp/$itype.$lang.tok $src $tgt $tmp/$itype.$lang.clean 1 175
#不使用clean
for l in $src $tgt; do
	perl $LC < $tmp/$lang.tok.test > $tmp/$lang.test
done


BPE_CODE=results/code


echo "apply_bpe.py to test..."
python $BPEROOT/apply_bpe.py -c $BPE_CODE < $tmp/$lang.test > $prep/$lang.test

