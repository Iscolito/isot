# -*- coding = utf-8 -*-
# @Time : 2022/10/21 16:21
# @Author : Iscolito
# @File : test.py
# @Software : PyCharm
import itertools
from nltk.tokenize import TweetTokenizer
from nltk.stem.isri import ISRIStemmer
import sys
import re

# 单句分词


class cut_ar:
    def __init__(self):
        pass

    def tokenize(self, foo):
        TATWEEL = u"\u0640"
        stemmer = ISRIStemmer()
        tknzr = TweetTokenizer()
        text = tknzr.tokenize(foo)
        result = []
        for word in text:
            if word.startswith(('@', '#')):
                continue
            word = word.lower()
            word = ''.join([i for i in word if not i.isdigit()])
            word = re.sub(r"http\S+", "", word)
            word = stemmer.norm(word, num=1)
            word = re.sub(r'[^\w\s]', '', word)
            word = word.replace(TATWEEL, '')
            word = ''.join(i for i, _ in itertools.groupby(word))
            if word:
                result.append(word)
        return ' '.join(result)

    def preprocess(self, line):
        return self.tokenize(line)


if __name__ == '__main__':
    text = 'وإذ يثني على جهود منظمة الوحدة اﻻفريقية وأجهزتها وكذلك جهود الطرف التيسيري التنزاني، في توفير الدعم الدبلوماسي والسياسي واﻻنساني الﻻزم لتنفيذ قرارات المجلس ذات الصلة،'
    print(text)
    cut = cut_ar()
    cut.preprocess(text)
    print(cut.preprocess(text))


