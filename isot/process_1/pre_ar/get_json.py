# -*- coding = utf-8 -*-
# @Time : 2022/11/9 22:47
# @Author : Iscolito
# @File : get_json.py
# @Software : PyCharm
import json


class readJson:
    def __init__(self, filepath):
        self.filepath = filepath

    def write(self):
        jsonfile = open(self.filepath, 'r', encoding='utf-8')
        arfile = open(self.filepath+'.ar', 'w', encoding='utf-8')
        zhfile = open(self.filepath + '.zh', 'w', encoding='utf-8')
        while True:
            line = jsonfile.readline()
            if line:
                line = json.loads(line)
                arfile.write(line["tgt"]+'\n')
                zhfile.write(line["src"]+'\n')
            else:
                break


if __name__ == "__main__":
    reader = readJson("../../extends/washed/zh-ar.json")
    reader.write()


