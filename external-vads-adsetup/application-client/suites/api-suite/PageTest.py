import os

from utils.BaseTest import *
from ApiConstants import *
# from LocalConstants import _here
import subprocess
from modules.custom_keywords import *
from utils.generic_keywords import move_png_files

_here = os.path.dirname(__file__)

def merge_files(path, file, files_to_merge):
    command = f'rebot --outputdir {path} --merge --output {file}_output.xml -l {file}_log.html -r {file}_report.html {files_to_merge}'
    print(subprocess.run([command], shell=True))


def merge_all_tests_results():
    """
    The function is used to save the generated output files on local_files['generated_path'].
    It also merges the generated '-output.xml' files wrt to all running tests and stores the merged result in dir
    local_files["final_result"]["output_path"].
    """
    local_files = load_input_data(_here[:_here.index("application-client")] + get_local_files_path())
    generated_files_name = os.listdir(_here[:_here.index("application-client")] + local_files['generated_path'])
    files_to_merge = ""
    for file in generated_files_name:
        if file.endswith("-output.xml"):
            files_to_merge += local_files['generated_path'] + file + " "

    merge_files(local_files["final_result"]["output_path"],
                local_files["final_result"]["file_name"], files_to_merge)
    move_png_files(r".", r"./././application-client/output/generated")


class PageTest:
    def __init__(self):
        super().__init__()
        self.baseClass = BaseTest()

    def run_test(self, test_name, arguments, use_local_data=False):
        """
        This function is used to create and run the given test_name
        Args:
            test_name: Name of the test
            arguments: Arguments passed to command-line as extra attributes, ex: browser:safari
            use_local_data: ture if you want to execute the cases with local json, false to use AWS json files.
        """
        data = load_input_data(_here[:_here.index("application-client")] + get_path_input_json(test_name, use_local_data))
        local_files = load_input_data(_here[:_here.index("application-client")] + get_local_files_path())
        suite = self.baseClass.create_suite(data['name'], local_files[test_name]['dependent_module'],
                                            local_files[test_name]['dependent_library'])
        self.extra_setup(suite, local_files, "suite", test_name)
        for test in data['testList']:
            if test['testRunEnabled']:
                test_case = self.baseClass.create_test(test['test_name'])
                if 'keywords' in test:
                    for keyword in test['keywords']:
                        create_keyword(test_case, keyword['name'], keyword['args'])
                self.extra_setup(test_case, local_files, "testcase", test_name)
        output_file_path = local_files['generated_path'] + local_files[test_name]['output_path_prefix'] + local_files[
            'generated_path_prefix']
        self.baseClass.throw_output_with_arguments(arguments, output_file_path)

    def extra_setup(self, element, local_files, element_type, test_name):
        """The function "extra_setup" calls the "setup" and "teardown" functions with the given parameters.
        """
        self.setup(element, local_files, element_type, test_name)
        self.teardown(element, local_files, element_type, test_name)

    def setup(self, element, local_files, element_type, test_name):
        """
        This function sets up the name and arguments for a given element based on its type and local files.
        :param element: It is an object representing a test suite or a test case
        :param local_files: A dictionary containing information about local files, specifically test setups.
        It is expected to have keys 'test_setups', 'suite_setup', and 'test_setup'. The values for
        'suite_setup' and 'test_setup' should be dictionaries containing 'name' and 'args' keys, which
        represent the
        :param element_type: The type of the element being set up, which can be either "suite" or "testcase"
        """
        setup_name = ''
        args = ''
        local_files = local_files[test_name]['test_setups']
        if element_type == "suite":
            setup_name = local_files['suite_setup']['name']
            args = local_files['suite_setup']['args']
        elif element_type == "testcase":
            setup_name = local_files['test_setup']['name']
            args = local_files['test_setup']['args']

        element.setup.name = setup_name
        element.setup.args = args

    def teardown(self, element, local_files, element_type, test_name):
        """
        This function sets the teardown name and arguments for a given element based on its type.
        :param element: The element parameter is an object representing a test suite or a test case. It is
        used to set the teardown name and arguments for the element
        :param local_files: A dictionary containing information about local files related to test setups
        :param element_type: The type of the element being passed in, which can be either "suite" or
        "testcase"
        """
        setup_name = ''
        args = ''
        local_files = local_files[test_name]['test_setups']
        if element_type == "suite":
            setup_name = local_files['suite_teardown']['name']
            args = local_files['suite_teardown']['args']
        elif element_type == "testcase":
            setup_name = local_files['test_teardown']['name']
            args = local_files['test_teardown']['args']

        element.teardown.name = setup_name
        element.teardown.args = args
