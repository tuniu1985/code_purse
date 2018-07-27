#!/bin/env python
# coding=utf-8
import json
import sys
from elasticsearch import Elasticsearch
from excel2json import Excel2Json

reload(sys)
sys.setdefaultencoding('utf8')

api_url = 'https://elastic:jKGPVyyNxD0F0D0lY9gakcTs@99844eb7c3b54321bda9353e8624896a.ap-northeast-1.aws.found.io:9243/'

if __name__ == '__main__':
    es = Elasticsearch([api_url])
    # res = es.search(index="megacorp", body={"query": {"match_all": {}}})
    # es.index(index='megacorp', doc_type='employee', body=json.dumps(employee))
    j = Excel2Json('./2016.xls')
    childrens = j['children'.encode('unicode_escape')]
    print 'total:', len(childrens)
    for i in range(len(childrens)):
        print 'count:', str(i + 1)
        print json.dumps(childrens[i])
        es.index(index='sexonfire', doc_type='all2016', body=json.dumps(childrens[i]), request_timeout=999)
