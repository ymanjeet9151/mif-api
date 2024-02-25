import sys
from utils.datagen import *
from brand.brand import *
from customKeywords import *


def main():

    number_of_records = 1
    use_faker = True

    # Check for the -n or --number argument
    if '-n' in sys.argv or '--number' in sys.argv:
        try:
            index = sys.argv.index('-n') if '-n' in sys.argv else sys.argv.index('--number')
            number_of_records = int(sys.argv[index + 1])
        except (ValueError, IndexError):
            print("Please provide a valid integer for the number of records.")
            sys.exit(1)

# Check for the --faker argument
    if '--faker' in sys.argv or '-f' in sys.argv:
        try:
            findex = sys.argv.index('-f') if '-f' in sys.argv else sys.argv.index('--faker')
            use_faker = sys.argv[findex + 1].lower() == 'true'
        except Exception as e:
            print(e)
            sys.exit(1)

    if use_faker:
        for _ in range(number_of_records):
            response = create_application(generate_brand_payload("brand"), "brand")
            write_content_into_file(response, "brand")
    else:
        data, len = read_content_from_file("brand")
        for _ in range(len):
            response=create_application(data[_], "brand")
            write_content_into_file(response, "brand")

if __name__ == "__main__":
    main()
