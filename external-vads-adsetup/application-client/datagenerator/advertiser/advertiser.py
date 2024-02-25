import sys
import json
import requests
from utils.datagen import *
from config import config


def generate_advertiser_payload(filename):
    with open(f"{config.filepath}/{filename}/payload.json", 'r') as file:
        data = json.load(file)
    data[0]["user_first_name"] = generate_first_name()
    data[0]["user_last_name"] = generate_last_name()
    data[0]["advertiser_name"] = generate_advertiser_name()
    data[0]["company_address"]["address_1"] = generate_address()
    data[0]["company_address"]["address_2"] = generate_secondary_address()
    data[0]["company_address"]["city"] = generate_city()
    data[0]["company_address"]["zipcode"] = generate_zip_code()
    data[0]["company_address"]["state"] = generate_state()
    # data["company_address"]["province"]
    # data["company_address"]["country"]
    data[0]["user_email"] = generate_email()
    data[0]["site_url"] = generate_url()
    return data[0]