#!/bin/sh

echo 正在对文本进行预处理工作，本工作基于Moses和Subword NMT以及NLTK进行

echo 'Cloning Moses github repository (for tokenization scripts)...'
git clone https://github.com/moses-smt/mosesdecoder.git

echo 'Cloning Subword NMT repository (for BPE pre-processing)...'
git clone https://github.com/rsennrich/subword-nmt.git

SCRIPTS=mosesdecoder/scripts
TOKENIZER=$SCRIPTS/tokenizer/tokenizer.perl
LC=$SCRIPTS/tokenizer/lowercase.perl
CLEAN=$SCRIPTS/training/clean-corpus-n.perl
BPEROOT=subword-nmt/subword_nmt
NORM_PUNC=$SCRIPTS/tokenizer/normalize-punctuation.perl
BPE_TOKENS=10000
AR_CUT=pre_ar

src=zh
tgt=ar
lang=zh_ar
prep=results
tmp=$prep/tmp
orig=resources
mkdir -p $tmp $prep

echo 正在进行标点符号的初始化
for itype in train valid; do
	perl ${NORM_PUNC} -l zh <$orig/$itype.$lang.zh> $orig/temp.txt
	mv $orig/temp.txt  $orig/$itype.$lang.zh
done


#中文分词
for itype in train valid; do
	python -m jieba -d " " $orig/$itype.$lang.zh > $orig/temp.txt
	mv $orig/temp.txt  $orig/$itype.$lang.zh
done

#划分法，在数据多的时候暂不使用
#echo 正在将数据分割出5000句验证集
#cd $orig
#for l in $src $tgt; do
	#oname=$lang.$l
	#length=$(sed -n '$=' $oname)
	#((length=length*90))
	#((length=length/100))
	#split -l $length -d -a 1 $oname $oname.
	#mv $oname.0 train.$lang.$l
	#mv $oname.1 valid.$lang.$l
#done
#cd ..


#此处tokennizer将语言划分为标准形式需要对tokenizer.perl传参使用的语言
#可用语言库在mosesdecoder/scripts/share/nonbreaking_prefixes/
#使用http://www.loc.gov/standards/iso639-2/php/code_list.php以查看可用后缀
echo 正在进行训练集和验证集的预处理

#分词处理
for itype in train valid; do
	#阿拉伯语采用nltk来进行分词，会将原词变为词根，暂不使用
	#python $AR_CUT/main.py $orig/$itype.$lang.ar
	#mv $orig/$itype.$lang.ar.tok $tmp/$itype.$lang.tok.ar
	#for l in zh; do
	for l in $src $tgt; do
		f=$itype.$lang.$l
		tok=$itype.$lang.tok.$l
		cat $orig/$f | \
		perl $TOKENIZER -threads 8 -l $l > $tmp/$tok
		echo ""
	done
	perl $CLEAN -ratio 1.5 $tmp/$itype.$lang.tok $src $tgt $tmp/$itype.$lang.clean 1 175
	#此处暂不使用clean的结果
	for l in $src $tgt; do
		perl $LC < $tmp/$itype.$lang.tok.$l > $tmp/$itype.$lang.$l
	done
done

echo 正在生成训练集和验证集
for itype in train valid; do
	for l in $src $tgt; do
		awk '{if (NR%23 != 0)  print $0; }' $tmp/$itype.$lang.$l > $tmp/$itype.$l
	done
done

TRAIN=$tmp/train.$lang
BPE_CODE=$prep/code

for l in $src $tgt; do
    cat $tmp/train.$l >> $TRAIN
done

echo 正在BPE化
python $BPEROOT/learn_bpe.py -s $BPE_TOKENS < $TRAIN > $BPE_CODE

for L in $src $tgt; do
    for f in train.$L valid.$L; do
        echo "apply_bpe.py to ${f}..."
        python $BPEROOT/apply_bpe.py -c $BPE_CODE < $tmp/$f > $prep/$f
    done
done
