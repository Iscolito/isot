src=ar
tgt=zh
lang=ar_zh_ex
prep=results
tmp=$prep/tmp
orig=extends
wash=pre_ar/pre_extends.py
mkdir -p $tmp $prep
#此处下载扩展语料库
#wget -P $orig https://object.pouta.csc.fi/OPUS-UNPC/v1.0/moses/ar-zh.txt.zip 
#tar -xzvf $orig/ar-zh.txt.zip
#mv UNPC.ar-zh.zh ar_zh_ex.zh
#mv UNPC.ar-zh.ar ar_zh_ex.ar
python $wash $orig/$lang.ar $orig/$lang.zh