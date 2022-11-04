 # -*- coding = utf-8 -*-
# @Time : 2022/11/3 22:45
# @Author : Iscolito
# @File : pre_extends.py
# @Software : PyCharm
from __future__ import unicode_literals
import sys
import subprocess
import re
from hazm import *

class pre_extends:
    def __init__(self, filepath):
        self.filepath = filepath
        self.normalizer = Normalizer()

    def scan_right(self, line, lan):
        if lan == "zh":
            if len(line) <= 5:
                return False
            for char in line:
                if '\u4e00' <= char <= '\u9fff':
                    return True
            return False
        elif lan == "ar":
            count = 0
            for char in line:
                if char == ' ':
                    count += 1
            if count <= 3:
                return False
            for char in line:
                if '\u0600' <= char <= '\u06FF':
                    return True
            return False
        else:
            return False


    def count_line(self, file_path):
        out = subprocess.getoutput("wc -l %s" % file_path)
        return int(out.split()[0])

    def progress_bar(self, pos):
        print("\r", end="")
        print("Cleaning progress: {}%: ".format(pos), "▋" * (pos // 2), end="")
        sys.stdout.flush()

    def line_process(self, line, lan):
        line = line.replace('&nbsp', '')
        line = line.replace('&quot', '')
        line = re.sub(u"\\(.*?\\)|\\{.*?\\}|\\[.*?\\]|\\<.*?\\>|\\（.*?\\）", "", line)
        line = re.sub("[A-Za-z]", "", line)
        if lan == 'zh':
            line = line.replace(' ', '')
            line = line.replace('*', '')
        if lan == 'ar':
            line = line.replace(':: ', '')
            line = self.normalizer.normalize(line)
        return line

    def select(self):
        f_ar = open(self.filepath[1], "r", encoding='utf-8', errors="ignore")
        f_zh = open(self.filepath[2], "r", encoding='utf-8', errors="ignore")
        f_ar_res = open(self.filepath[1]+'.res', "w", encoding='utf-8', errors="ignore")
        f_zh_res = open(self.filepath[2]+'.res', "w", encoding='utf-8', errors="ignore")
        print("Computing the size of two files")
        count_ar = self.count_line(self.filepath[1])
        print("size of ar is {}".format(count_ar))
        count_zh = self.count_line(self.filepath[2])
        print("size of zh is {}".format(count_zh))
        if count_ar != count_zh:
            print("num of lines incorrect")
            return
        count = count_ar
        print('num of lines correct')
        i = 0
        while True:
            line_ar = f_ar.readline()
            line_zh = f_zh.readline()
            i += 1
            self.progress_bar(int(100 * i / count))
            if line_ar:
                scan_lan = self.scan_right(line_zh, 'zh') and self.scan_right(line_ar, 'ar')
                ap = scan_lan
                if ap:
                    line_ar = self.line_process(line_ar, 'ar')
                    line_zh = self.line_process(line_zh, 'zh')
                    re_scan = self.scan_right(line_zh, 'zh') and self.scan_right(line_ar, 'ar')
                    if re_scan:
                        f_ar_res.write("{}".format(line_ar))
                        f_zh_res.write("{}".format(line_zh))
            else:
                print("\n")
                print("ar output size:"+str(self.count_line(self.filepath[1]+'.res')))
                print("zh output size:" + str(self.count_line(self.filepath[2] + '.res')))
                break


if __name__ == '__main__':
    wash = pre_extends(sys.argv)
    wash.select()

