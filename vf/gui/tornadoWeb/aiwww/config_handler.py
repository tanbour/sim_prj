#!/usr/bin/env python
# -*- coding: UTF-8 -*-
# encoding=utf8  
import sys 
reload(sys)
sys.setdefaultencoding('utf8')
from concurrent.futures import ThreadPoolExecutor
from tornado import gen
from tornado.web import RequestHandler
from tornado.concurrent import run_on_executor
from .utils import *
from .errorcode import *
import json
import os
import re
import numpy as np


logger = get_logger()


class ConfigRequestHandler(RequestHandler):

    def get(self):
        read_path = os.path.join(os.path.dirname(__file__), "../data/public.json")
        public_parm = readJSON(read_path)
        read_path = os.path.join(os.path.dirname(__file__), "../data/private.json")
        private_parm = readJSON(read_path)
        message = {}
        message["ethPublicPckTable"] = public_parm 
        message["ethPrivatePckTable"] = private_parm 
        self.write({
            "errorcode": SUCCESS,
            "message": message
        })
        return

    @gen.coroutine
    def post(self):
        try:
            #data = json.loads(self.request.body.decode('utf-8'))
            #data = self.request.body
            pattern_begin = re.compile('^\[')
            pattern_end = re.compile(']$')
            data = self.get_body_argument("name")
            data = re.sub(pattern_begin,'',data)
            data = re.sub(pattern_end,'',data)
            data = data.replace('",','\r\n')
            data = data.replace('"','')
            write_path = self.get_body_argument("path")
            json_public_data = self.get_body_argument("jsonPublic")
            json_private_data = self.get_body_argument("jsonPrivate")
            ##print json_public_data
            ##print isinstance(data,basestring)
            ##print isinstance(data,int)
            ##print isinstance(data,list)
            ##print isinstance(data,dict)
            ##print isinstance(data,float)
            ##print isinstance(data,tuple)
            # write_path = os.path.join(os.path.dirname(__file__), "../data/data.json")
            ##print data
            print write_path
            fp = open(write_path,'w')
            fp.write(data)
            fp.close()

            write_path = os.path.join(os.path.dirname(__file__), "../data/public.json")
            writeJSON(write_path, json_public_data)
            write_path = os.path.join(os.path.dirname(__file__), "../data/private.json")
            writeJSON(write_path, json_private_data)
            self.write({
                "errorcode": SUCCESS,
                "message":{}
            })

        except Exception as e:
            logger.error(str(e))
            self.write({
                "errorcode": ERRORCODE_SYSTEM,
                "message":str(e)
            })
