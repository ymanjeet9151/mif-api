from utils.datagen import *

def create_admin_add_user(data):
    """ This function creates the admin add user data
    """
    data["user_email"]= generate_email()
    data["user_first_name"]= generate_first_name()
    data["user_last_name"]= generate_last_name()
    return data

def create_brand(data):
    """ This function creates the admin add user data
    """
    name= generate_product_name()
    data["name"]= name
    data["tagline"]= generate_tag_name()
    data["identity_logo_url"]= generate_fake_logo_name()
    data["parent_company_name"]= name
    data["related_tags"]= generate_tag_name()
    return data

def update_brand(data):
    """ This function creates the admin add user data
    """
    data["name"]= generate_product_name()
    return data