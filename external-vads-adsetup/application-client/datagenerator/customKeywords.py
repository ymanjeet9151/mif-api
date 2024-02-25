import json
import sys 
import requests
from config import config
import random


def read_content_from_file(filename):
    try:
        # print(config.filepath + "payload.json")
        with open(config.filepath + f"/{filename}/payload.json", 'r') as file:
            data = json.load(file)
            
        return data, len(data)
    except (FileNotFoundError, json.JSONDecodeError) as e:
        print(f"Error reading data from file: {e}")
        sys.exit(1)

def write_content_into_file(response, filename):
    try:
        with open(config.filepath + f"/{filename}/{filename}", 'a+') as f:
            f.write(response['id'] + "\n")
    except Exception as e:
        print(f"Error reading data from file: {e}")
        sys.exit(1)

def create_application(payload, endpoint, advertiser_id=None):
    
    api_url = f"{config.host}{getattr(config, endpoint)}"
    if endpoint == "product" or endpoint == "contract":
        api_url = api_url + f'/{advertiser_id}/{endpoint}'
    # print(api_url)
    headers = {"Content-Type": "application/json",
               'Authorization': f'Bearer {config.token}'}

    try:
        response = requests.post(api_url, headers=headers, json=payload)
        print(response.json())
        return response.json()
    except Exception as e:
        print(e)

def get_id(app):
    with open(config.filepath + f"/{app}/{app}", 'r') as file:
        data = file.read().split("\n")
    data = [item for item in data if item]
    print(data)
    return random.choice(data)


# update_application(payload, "contract", advertiserId,  response['id'])
def update_application(payload, endpoint, advertiserId, contractId):
    api_url = f"{config.host}{getattr(config, endpoint)}"
    if endpoint == "product" or endpoint == "contract":
        api_url = api_url + f'/{advertiserId}/{endpoint}/'
    # print(api_url)
    headers = {"Content-Type": "application/json",
               'Authorization': f'Bearer {config.token}'}

    try:
        response = requests.post(api_url, headers=headers, json=payload)
        print(response.json())
        return response.json()
    except Exception as e:
        print(e)