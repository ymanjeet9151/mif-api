import os, sys

class Config(object):
    def __init__(self):
        _here = os.path.dirname(__file__)
        self.filepath = _here[:_here.index("datagenerator")] + "datagenerator/"
        sys.path.insert(0, os.path.abspath(os.path.join(_here, "..", "..")))
        sys.path.insert(0, os.path.abspath(os.path.join(_here)))
        self.host = "https://dev-adsetup.mifadnetwork.com"
        self.advertiser = "/v1/admin/advertiser/add"
        self.brand = "/v1/cms/brand"
        self.product = "/v1/admin/advertiser"
        self.contract = "/v1/admin/advertiser"
        self.token = "$2a$10$z7aNF34ORVIAu3hd5M/k3e2wby3m.bxF2Hvm96iCtNxUNzIS3tY8G"

config = Config()