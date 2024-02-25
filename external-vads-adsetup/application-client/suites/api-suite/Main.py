import sys
from PageTest import *

print(f"Run with arguments: " + str(sys.argv))

use_local_data = True

# PageTest().run_test("BrandAPI", sys.argv, use_local_data)
# PageTest().run_test("UserManagement", sys.argv, use_local_data)
PageTest().run_test("AdminAdvertiser", sys.argv, use_local_data)
# PageTest().run_test("AdminPublisher", sys.argv, use_local_data)
# PageTest().run_test("AdminReports", sys.argv, use_local_data)

# Merge all the results
merge_all_tests_results()
