# -*- coding = utf-8 -*-
# @Time : 2022/11/7 12:59
# @Author : Iscolito
# @File : dict_test.py
# @Software : PyCharm
import subprocess
import sys
import test


class dict_test:
    def __init__(self, filepath):
        self.filepath = filepath
        self.testdict = dict()
        self.lists = list()
        self.traindict = dict()
        # self.cutter = test.cut_ar()

    def count_line(self, file_path):
        out = subprocess.getoutput("wc -l %s" % file_path)
        return int(out.split()[0])

    def progress_bar(self, pos, headline):
        print("\r", end="")
        print("{}: {}%: ".format(headline, pos), "▋" * (pos // 2), end="")
        sys.stdout.flush()

    def read_test(self):
        testfile = open(self.filepath, "r", encoding='utf-8', errors="ignore")
        while True:
            line = testfile.readline()
            if line:
                # line = self.cutter.preprocess(line)
                line = line.split()
                for item in line:
                    if item in self.testdict:
                        self.testdict[item] += 1
                    else:
                        self.testdict[item] = 1
            else:
                self.lists = self.testdict.items()
                self.lists = sorted(self.lists, key=lambda x: self.testdict[x[0]])
                break

    def print_dict(self, lists, name):
        dictfile = open('../dicts/'+name, "w", encoding='utf-8', errors="ignore")
        for item in lists:
            dictfile.write(str(item))
            dictfile.write('\n')

    def examine(self, trainpath):
        trainfile = open(trainpath, "r", encoding='utf-8', errors="ignore")
        self.traindict = dict()
        while True:
            line = trainfile.readline()
            if line:
                line = line.split()
                for item in line:
                    if item in self.testdict:
                        if item in self.traindict:
                            self.traindict[item] += 1
                        else:
                            self.traindict[item] = 1
            else:
                return sorted(self.traindict.items(), key=lambda x: self.traindict[x[0]])

    def select(self, extendpath_ori, extendpath_tar):
        extendfile_ar = open(extendpath_ori, "r", encoding='utf-8', errors="ignore")
        extendfile_zh = open(extendpath_tar, "r", encoding='utf-8', errors="ignore")
        quafile_ar = open(extendpath_ori + ".qua", "w", encoding='utf-8', errors="ignore")
        quafile_zh = open(extendpath_tar + ".qua", "w", encoding='utf-8', errors="ignore")
        line_num = 0
        count = 0
        while True:
            line_ar = extendfile_ar.readline()
            line_zh = extendfile_zh.readline()
            if line_ar:
                line_num += 1
                if count > 1000000:
                    break
                self.progress_bar(int(100 * count / 1000000), "正在扩增训练集")
                line_ar = line_ar.split()
                if len(line_ar) <= 10:
                    for item in line_ar:
                        if item in self.traindict and self.testdict[item] <= 10:
                            line_ar = ' '.join(line_ar)
                            quafile_ar.write(line_ar + '\n')
                            quafile_zh.write(line_zh)
                            count += 1
                            break
            else:
                break
        extendfile_ar = open(extendpath_ori, "r", encoding='utf-8', errors="ignore")
        extendfile_zh = open(extendpath_tar, "r", encoding='utf-8', errors="ignore")
        line_num = 0
        count = 0
        while True:
            line_ar = extendfile_ar.readline()
            line_zh = extendfile_zh.readline()
            if line_ar:
                line_num += 1
                if count > 700:
                    break
                self.progress_bar(int(100 * count / 700), "正在扩增目标字典")
                line_ar = line_ar.split()
                if len(line_ar) <= 10:
                    for item in line_ar:
                        if item in self.testdict and self.testdict[item] <= 10 and item not in self.traindict:
                            line_ar = ' '.join(line_ar)
                            quafile_ar.write(line_ar + '\n')
                            quafile_zh.write(line_zh)
                            self.traindict[item] = 1
                            count += 1
                            break
            else:
                break


if __name__ == '__main__':
    # td = dict_test(sys.argv[1])
    td = dict_test("../tests/ar_zh.test")
    td.read_test()

    td.print_dict(td.lists, "testdict.txt")
    # td.print_dict(td.examine("../../extends/washed/zh-ar.json"), "washed.txt")
    # td.print_dict(td.examine("../../extends/ted/TED2020.ar-zh.ar"), "extend2dict.txt")
    # td.print_dict(td.examine("../../src/ar_zh.ar"), "traindict.txt")
    # td.print_dict(td.examine("../extends/ar_zh_ex.ar.res"), "extenddict.txt")
    # td.select("../extends/ar_zh_ex.ar.res", "../extends/ar_zh_ex.zh.res")
    td.print_dict(td.examine("../../mix.ar"), "mix.ar")


