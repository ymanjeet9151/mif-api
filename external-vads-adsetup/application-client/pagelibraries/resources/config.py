import os
import sys


class Config(object):
    """Configuration variables for this test suite
    This creates a variable named CONFIG (${CONFIG} when included
    in a test as a variable file.
    Example:
    *** Settings ***
    | Variable | ../resources/config.py
    *** Test Cases ***
    | Example
    | | log | username: ${CONFIG}.username
    | | log | root url: ${CONFIG}.root_url
    """
    def __init__(self):
        _here = os.path.dirname(__file__)
        self.data_file_path = \
            _here[:_here.index("pagelibraries")] + "testdata/datafiles/"
        sys.path.insert(0, os.path.abspath(os.path.join(_here, "..", "..")))
        sys.path.insert(0, os.path.abspath(os.path.join(_here)))
        self.user_mangmnt_datafile = \
            _here[:_here.index("pagelibraries")] + "testdata/datafiles/sample/UserManagementOutput/"
        self.cms_datafile = \
            _here[:_here.index("pagelibraries")] + "testdata/datafiles/sample/CMSOutput/"
        self.admad_datafile = \
            _here[:_here.index("pagelibraries")] + "testdata/datafiles/sample/AdminAdvertiserOutput/"
        self.admpub_datafile = \
            _here[:_here.index("pagelibraries")] + "testdata/datafiles/sample/AdminPublisherOutput/"
        self.adm_reports_datafile = \
            _here[:_here.index("pagelibraries")] + "testdata/datafiles/sample/AdminReportsOutput/"
        self.root_url = 'about:blank'
        self.url = 'https://rgs4m.com/'
        self.stage_url = 'https://stage-consumer.rgs4m.com/auth/signin'
        self.host = 'rgs4m'
        self.domain = 'stage'
        self.endpoint = 'auth/signin'
        self.aws_url = "https://devotv-stage-automation.s3.us-west-2.amazonaws.com/"
        self.delete_api = f"https://www.rgs4m.com/umgmt/api/v1/umgmt/users/{id}/userdelete"
        self.api_url = "https://dev-adsetup.mifadnetwork.com"

    def __str__(self):
        """
        Used for string representation of an object
        """
        return "<Config: %s>" % str(self.__dict__)


# This creates a variable that robot can see
CONFIG = Config()
