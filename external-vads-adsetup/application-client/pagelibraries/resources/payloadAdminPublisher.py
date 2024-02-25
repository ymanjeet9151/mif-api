from utils.datagen import *

def create_admin_publisher(data):
    """ This function creates the admin advertiser data
    """
    generate_secondary_address_var= generate_secondary_address()
    generate_email_var= generate_email()
    generate_first_name_var= generate_first_name()
    data["user_first_name"]= generate_first_name_var
    data["user_last_name"]= generate_last_name()
    data["site_url"]= generate_url()
    data["publisher_name"]= generate_advertiser_name()
    data["primary_contact_address"]["address_1"]= generate_address()
    data["primary_contact_address"]["address_2"]= generate_secondary_address_var
    data["primary_contact_address"]["city"]= generate_city()
    data["primary_contact_address"]["zipcode"]= generate_zip_code()
    data["primary_contact_address"]["state"]= generate_state()
    data["primary_contact_address"]["province"]= generate_secondary_address_var
    data["primary_contact_name"]= generate_first_name_var
    data["primary_contact_email"]= generate_email_var
    data["primary_contact_phone"]= generate_phone()
    data["user_email"]= generate_email_var
    return data

def create_admin_publisher_update(data):
    """ This function creates the admin publisher data
    """
    data["publisher_name"]= generate_advertiser_name()
    return data

def create_admin_publisher_contact(data,pub_id):
    """
    """
    data["publisher_id"]= pub_id
    data["contract_effective_date"]= generate_current_unix_time_milisec()
    data["contract_end_date"]= generate_next_year_unix_timestamp_millisec()
    data["name"]= generate_contract_name()
    data["description"]= generate_contract_description()
    data["publication_name"]= generate_advertiser_name()
    return data
    
def create_admin_publisher_contact_update(data):
    """
    """
    data["name"]= generate_contract_name()
    return data

def create_admin_publisher_content(data,pub_id):
    """
    """
    data["publisher_id"]= pub_id
    data["publisher_content_id"]= generate_content_id()
    data["content_url"]= generate_url()
    data["title"]= generate_product_name()
    data["description"]= generate_contract_description()
    data["author"]= generate_first_name()
    data["publication_start_date"]= generate_current_unix_time_milisec()
    data["publication_end_date"]= generate_next_year_unix_timestamp_millisec()
    return data

def create_admin_publisher_content_update(data):
    """
    """
    data["title"]= generate_product_name()
    return data

def create_admin_publisher_Sandbox_Key(data,pub_id):
    """
    """
    data["publisherId"]=pub_id
    data["site_url"]=generate_url()
    return data
    
def create_admin_publisher_sso_setup(data,contract_id,sandbox_url,sandbox_start_date,livesite_url,livesite_start_date):
    """
    """
    data["contract_id"]=contract_id
    data["sandbox_site_integration_url"]=sandbox_url
    data["sandbox_site_integration_start_date"]=sandbox_start_date
    data["live_site_url"]=livesite_url
    data["live_site_integration_start_date"]=livesite_start_date
    data["header"]=generate_popup_text()
    data["text"]=generate_popup_text()
    return data

def create_admin_publisher_sso_setup_update(data):
    """
    """
    data["sandbox_site_integration_url"]=generate_url()
    return data