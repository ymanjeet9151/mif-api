from utils.datagen import *

def create_admin_report(output_resp_dict,payload_name):
    """ The `create_admin_report` function takes in an `output_resp_dict` and `payload_name` as parameters,
    and based on the `payload_name`, selects a list of keys. It then randomly selects a key and index
    from the list, retrieves the corresponding value from the `output_resp_dict`, and adds it to a
    payload dictionary with a timezone.
    
    :param output_resp_dict: A dictionary containing the response data
    :param payload_name: The `payload_name` parameter is a string that determines the type of report to
    be created. It can have one of the following values: 'campaigns_products_offers',
    'publisher_models', 'publisher_models_email_status', or 'publisher_models_ads_schedule'
    :return: a payload dictionary containing information related to the specified payload name. If the
    random key chosen from the key list is found in the output response dictionary, the corresponding
    value is added to the payload dictionary. If the random key is not found in the output response, the
    function returns a message stating that the picked random key was not found in the output response.
    """
    if payload_name == 'campaigns_products_offers':
        key_list = ['campaign_start_date','campaign_end_date','advertiser_name','product_offer_ads_name',
                'product_name','contract_name','campaign_name','campaign_status','product_status']
    elif payload_name == 'publisher_models':
        key_list = ['publisherName','modalStatus','productNames','campaignNames','contentUrl','contentTitle']
    elif payload_name == 'publisher_models_email_status':
        key_list = ['publisherName','modalStatus','modalAcceptDate','modalDisplayTime','productName',
                     'campaignName','advertiserName','ssoUserId','productOfferAdsName']
    elif payload_name == 'publisher_models_ads_schedule':
        key_list = ['campaignName','advertiserName','productOfferAdsName','productName',
                    'campaignStartDate','campaignEndDate']

    payload = {
                "timeZone": "IST"
            }
    index_list = [0,1]
    random_key = random.choice(key_list)
    random_index = random.choice(index_list)
    print('random_key & random_index :', random_key, random_index)

    output_resp= output_resp_dict[random_index]
    print(output_resp)
    if random_key in output_resp:
        random_value = output_resp[random_key]
        payload[random_key] = random_value
        print(payload)
        return payload
    else:
        return 'picked random_key not found in the output_resp'
