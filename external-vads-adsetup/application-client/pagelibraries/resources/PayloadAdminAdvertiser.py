from utils.datagen import *

def create_admin_advertiser(data):
    """ This function creates the admin advertiser data
    """
    data["user_first_name"]= generate_first_name()
    data["user_last_name"]= generate_last_name()
    data["advertiser_name"]= generate_advertiser_name()
    data["company_address"]["address_1"]= generate_address()
    data["company_address"]["address_2"]= generate_secondary_address()
    data["company_address"]["city"]= generate_city()
    data["company_address"]["zipcode"]= generate_zip_code()
    data["company_address"]["state"]= generate_state()
    data["user_email"]= generate_email()
    data["site_url"]= generate_url()
    return data

def modify_admin_advertiser(data,field_name,TC_action):
    """ This function creates the admin advertiser data
    """
    if TC_action == "create" :
        if field_name == "duplicate":
            pass
        elif field_name == "incorrect field data":
            data["advertiser_name"]= generate_random_name_with_special_symbol()
            data["user_first_name"]= generate_first_name()
            data["user_last_name"]= generate_last_name()
            data["user_email"]= generate_email()
            data["site_url"]= generate_url()
        elif field_name=="removing mandatory field":
            del data["advertiser_name"]
            data["user_first_name"]= generate_first_name()
            data["user_last_name"]= generate_last_name()
            data["user_email"]= generate_email()
            data["site_url"]= generate_url()
    elif TC_action == "update" :
        if field_name == "duplicate":
            pass
        elif field_name == "incorrect field data":
            data["advertiser_name"]= generate_random_name_with_special_symbol()
        elif field_name == "removing mandatory field":
            del data["advertiser_name"]
    print(data)
    
    return data

def create_admin_advertiser_update(data):
    """ This function creates the admin advertiser data
    """
    data["advertiser_name"]= generate_advertiser_name()
    return data

def create_admin_advertiser_contract(data,product_id):
    """The function creates an admin advertiser contract by generating various data fields such as contract
    start and end dates, name, description, company address, and product start and end dates.
    """
    starting_date=generate_current_unix_time_milisec()
    ending_date=generate_next_year_unix_timestamp_millisec()
    data["contract_start_date"]= starting_date
    data["contract_end_date"]= ending_date
    data["name"]= generate_contract_name()
    data["description"]= generate_contract_description()
    data["contract_products"][0]["product_id"]= product_id
    data["contract_products"][0]["start_date"]= starting_date
    data["contract_products"][0]["end_date"]= ending_date
    return data

def modify_admin_advertiser_contract(data,field_name,TC_action):
    """The function creates an admin advertiser contract by generating various data fields such as contract
    start and end dates, name, description, company address, and product start and end dates.
    """    
    if TC_action == "create" :
        if field_name == "duplicate":
            pass
        elif field_name == "incorrect field data":
            input_name="contract_name"
            data["name"]= generate_random_name_with_special_symbol(input_name)
            starting_date=generate_current_unix_time_milisec()
            ending_date=generate_next_year_unix_timestamp_millisec()
            data["contract_start_date"]= starting_date
            data["contract_end_date"]= ending_date
            data["contract_products"][0]["start_date"]= starting_date
            data["contract_products"][0]["end_date"]= ending_date
        elif field_name=="removing mandatory field":
            del data["name"]
            starting_date=generate_current_unix_time_milisec()
            ending_date=generate_next_year_unix_timestamp_millisec()
            data["contract_start_date"]= starting_date
            data["contract_end_date"]= ending_date
            data["contract_products"][0]["start_date"]= starting_date
            data["contract_products"][0]["end_date"]= ending_date
        else:
            print("field_name error")
    elif TC_action == "update" :
        if field_name == "duplicate":
            pass
        elif field_name == "incorrect field data":
            data["advertiser_name"]= generate_random_name_with_special_symbol()
        elif field_name == "removing mandatory field":
            del data["advertiser_name"]
        else:
            print("field_name error")
    print(data)

    return data

def create_admin_advertiser_contract_update(data):
    """The function creates an admin advertiser contract by generating various data fields such as contract
    start and end dates, name, description, company address, and product start and end dates.
    """
    data["name"]= generate_contract_name()
    return data

def modify_admin_advertiser_contract_save_and_confirm(data,field_name):
    """The function creates an admin advertiser contract by generating various data fields such as contract
    start and end dates, name, description, company address, and product start and end dates.
    """
    if field_name == "duplicate":
        pass
    elif field_name == "incorrect field data":
        input_name="contract_name"
        data["name"]= generate_random_name_with_special_symbol(input_name)
    elif field_name == "removing mandatory field":
        del data["name"]
    print(data)

    return data

def admin_advertiser_contract_final_approve(data,field_name):
    """The function creates an admin advertiser contract by generating various data fields such as contract
    start and end dates, name, description, company address, and product start and end dates.
    """
    if field_name == "duplicate":
        pass
    elif field_name == "incorrect field data":
        data["status"]= generate_random_name_with_special_symbol("contract_status")
    elif field_name == "removing mandatory field":
        del data["status"]
    print(data)

    return data

def create_admin_advertiser_contract_product_add(data):
    """The function creates an admin advertiser contract product and adds it to the data.
    """
    data["offer_logo_name"]= generate_fake_logo_name()
    return data

def create_admin_advertiser_product(data):
    """The function creates an admin advertiser product by generating a name, related tags, and a tagline
    for the product.
    """
    data["name"]= generate_product_name()
    data["related_tags"]= generate_tag_name()
    data["tagline"]= generate_fake_tagline()
    return data

def modify_admin_advertiser_product(data,field_name,TC_action):
    """The function creates an admin advertiser product by generating a name, related tags, and a tagline
    for the product.
    """  
    if TC_action == "create" :
        if field_name == "duplicate":
            pass
        elif field_name == "incorrect field data":
            data["name"]= generate_random_name_with_special_symbol()
            data["related_tags"]= generate_tag_name()
            data["tagline"]= generate_fake_tagline()
        elif field_name=="removing mandatory field":
            del data["name"]
            data["related_tags"]= generate_tag_name()
            data["tagline"]= generate_fake_tagline()
        else:
            print("field_name error")
    elif TC_action == "update" :
        if field_name == "duplicate":
            pass
        elif field_name == "incorrect field data":
            data["name"]= generate_random_name_with_special_symbol()
        elif field_name == "removing mandatory field":
            del data["name"]
        else:
            print("field_name error")
    print("TC_action error")
    print(data)

    return data

def create_admin_advertiser_product_update(data):
    """The function creates an admin advertiser product update by generating a product name and updating
    the data dictionary.
    """
    data["name"]= generate_product_name()
    return data


def create_admin_advertiser_product_ads(data,id,product_id,offerasset_id_logo,offerasset_id_img):
    """The function creates admin advertiser product ads by generating an advertiser name and advertising
    description for the given data.
    """
    data["advertiserId"]=id
    data["product_id"]=product_id
    data["offer_assets"]=[offerasset_id_logo,offerasset_id_img]
    data["ads_offer_name"]= generate_advertiser_name()
    data["ads_offer_desc"]= generate_advertising_description()
    return data

def create_admin_advertiser_product_ads_update(data):
    """ The function creates an admin advertiser product ads update by adding an ads offer name to the given
    data.
    """
    data["ads_offer_name"]= generate_advertiser_name()
    return data

def create_admin_advertiser_contract_product_offerasset(data,advertiser_id):
    """ The function creates an admin advertiser contract product offer asset by generating a fake logo name
    and email offer text.
    """
    data["advertiserId"]=advertiser_id
    data["offer_logo_name"]= generate_fake_logo_name()
    # data["email_offer_text"]= generate_email_offer_text()
    return data

def modify_admin_advertiser_contract_product_offerasset(data,field_name,TC_action):
    """ The function creates an admin advertiser contract product offer asset by generating a fake logo name
    and email offer text.
    """
    if field_name == "duplicate":
        pass
    elif field_name == "incorrect field data":
        data["status"]= generate_random_name_with_special_symbol("contract_status")
    elif field_name == "removing mandatory field":
        del data["status"]
        
    return data

def create_admin_advertiser_contract_product_offerasset_update(data):
    """The function creates an admin advertiser contract product offer asset and updates the offer logo
    name.
    """
    data["offer_logo_name"]= generate_fake_logo_name()
    return data


def create_admin_advertiser_campagin(data,contract_start_date,contract_end_date):
    """ The function creates an admin advertiser campaign by generating a name and description for the
    campaign.
    """
    data["name"]= generate_campaign_name()
    data["start_date"]=contract_start_date
    data["end_date"]=contract_end_date
    data["description"]= generate_campaign_description()
    # data["total_budget_amt"]=generate_total_budget_amt()
    data["number_of_periods"]=generate_no_of_period()
    return data


def create_admin_advertiser_campagin_update(data):
    """ The function creates an admin advertiser campaign update by generating a campaign name, start date,
    end date, and description.
    """
    data["name"]= generate_campaign_name()
    return data

def create_add_the_product_admin_advertiser_campagin(data,campaign_id,id,product_id,campagin_start_date,campagin_end_date,active_offer_id):
    """
    """
    data["campaign_id"]=campaign_id
    data["advertiserId"]=id
    data["products"][0]["product_id"]=product_id
    data["products"][0]["start_date"]=campagin_start_date
    data["products"][0]["end_date"]=campagin_end_date
    data["products"][0]["active_offer_id"]=active_offer_id
    return data