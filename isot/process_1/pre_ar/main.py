# -*- coding = utf-8 -*-
# @Time : 2022/10/21 14:39
# @Author : Iscolito
# @File : main.py
# @Software : PyCharm
import itertools
from nltk.tokenize import TweetTokenizer
from nltk.stem.isri import ISRIStemmer
import sys
import re

# 文件分词


class cut_ar:
    def __init__(self, filepath):
        self.filepath = filepath

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

    def preprocess(self):
        with open(self.filepath, "r", encoding='utf-8',
                  errors="ignore") as test_file:
            with open(self.filepath+'.tok', "w", encoding='utf-8',
                      errors="ignore") as aim_file:
                while True:
                    line = test_file.readline()
                    if line:
                        line = self.tokenize(line)
                        aim_file.write("{}\n".format(line))
                    else:
                        break


if __name__ == '__main__':
    cut = cut_ar(sys.argv[1])
    cut.preprocess()
