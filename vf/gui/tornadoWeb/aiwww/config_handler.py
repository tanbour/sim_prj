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
        ##cfg_path = self.get_body_argument("cfgPath")
        cfg_path = os.path.join(os.path.dirname(__file__), "../data/")
        ##read_path = os.path.join(os.path.dirname(__file__), "../data/public.json")
        read_path = os.path.join(cfg_path , "public.json")
        public_parm = readJSON(read_path)
        read_path = os.path.join(cfg_path , "private.json")
#        read_path = os.path.join(os.path.dirname(__file__), "../data/private.json")
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
            cfg_path = self.get_body_argument("cfgPath")
            #print cfg_path
            pattern_begin = re.compile('^\[')
            pattern_end = re.compile(']$')
            data = self.get_body_argument("sim")
            data = re.sub(pattern_begin,'',data)
            data = re.sub(pattern_end,'',data)
            data = data.replace('",','\r\n')
            data = data.replace('"','')
            ##print isinstance(data,basestring)
            ##print isinstance(data,int)
            ##print isinstance(data,list)
            ##print isinstance(data,dict)
            ##print isinstance(data,float)
            ##print isinstance(data,tuple)
            write_path = self.get_body_argument("filePath")
            print write_path
            fp = open(write_path,'w')
            fp.write(data)
            fp.close()

            write_path = self.get_body_argument("cfgPath")+"public.json"
            ##write_path = os.path.join(os.path.dirname(__file__), "../data/public.json")
            print write_path
            json_public_data = self.get_body_argument("jsonPublic")
            writeJSON(write_path, json_public_data)

            write_path = self.get_body_argument("cfgPath")+"private.json"
            ##write_path = os.path.join(os.path.dirname(__file__), "../data/private.json")
            print write_path
            json_private_data = self.get_body_argument("jsonPrivate")
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
