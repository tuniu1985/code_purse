#!/bin/env python
# coding=utf-8
import json
import sys
from elasticsearch import Elasticsearch
import time
from excel2json import Excel2Json

reload(sys)
sys.setdefaultencoding('utf8')

api_url = 'https://elastic:jKGPVyyNxD0F0D0lY9gakcTs@99844eb7c3b54321bda9353e8624896a.ap-northeast-1.aws.found.io:9243/'

if __name__ == '__main__':
    es = Elasticsearch([api_url])
    # res = es.search(index="megacorp", body={"query": {"match_all": {}}})
    # es.index(index='megacorp', doc_type='employee', body=json.dumps(employee))
    j = Excel2Json('/Users/hbjava1985/Downloads/2016.xls')
    childrens = j['children'.encode('unicode_escape')]
    for child in childrens:
        print json.dumps(child)
        es.index(index='sexonfire', doc_type='all2016', body=json.dumps(child), request_timeout=99)
