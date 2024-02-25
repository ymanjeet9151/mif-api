import sys
import json
import requests
from utils.datagen import *
from config import config


def generate_product_payload(filename, brandId, categoryId):
    print(brandId)
    with open(f"{config.filepath}/{filename}/payload.json", 'r') as file:
        data = json.load(file)
    data[0]["name"]= generate_product_name()
    data[0]["brand_id"] = brandId
    data[0]["produt_category_id"] = categoryId
    data[0]["tagline"]= generate_tag_name()
    data[0]["related_tags"]= generate_tag_name()

    print(data[0])
    return data[0]