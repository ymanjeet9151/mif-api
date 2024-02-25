import sys
import json
import requests
from utils.datagen import *
from config import config


def generate_brand_payload(filename):
    with open(f"{config.filepath}/{filename}/payload.json", 'r') as file:
        data = json.load(file)

    data[0]["name"]= generate_product_name()
    data[0]["tagline"]= generate_tag_name()
    data[0]["identity_logo_url"]= generate_fake_logo_name()
    data[0]["parent_company_name"]= generate_product_name()
    data[0]["related_tags"]= generate_tag_name()

    return data[0]