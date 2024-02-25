import sys
import json
import requests
from utils.datagen import *
from config import config


def generate_contract_payload(filename, advertiserId, productId):
    with open(f"{config.filepath}/{filename}/payload.json", 'r') as file:
        data = json.load(file)

    starting_date=generate_current_unix_time_milisec()
    ending_date=generate_next_year_unix_timestamp_millisec()
    data[0]["advertiserId"]= advertiserId
    data[0]["contract_start_date"]= starting_date
    data[0]["contract_end_date"]= ending_date
    data[0]["name"]= generate_contract_name()
    data[0]["description"]= generate_contract_description()
    data[0]["contract_products"][0]["product_id"]= productId
    data[0]["contract_products"][0]["start_date"]= starting_date
    data[0]["contract_products"][0]["end_date"]= ending_date

    return data[0]

def get_save_contract_payload(endpoint, advertiserId, contractId):
    url = f"{config.host}{getattr(config, endpoint)}/{advertiserId}/{endpoint}/{contractId}"
    headers = {"Content-Type": "application/json",
               'Authorization': f'Bearer {config.token}'}

    try:
        response = requests.get(url, headers=headers)
        data = response.json()
        data['is_save_and_confirm'] = "true"
        print(data)
        return data
    except Exception as e:
        print(e)