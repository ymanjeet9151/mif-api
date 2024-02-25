
*** Settings ***
| Documentation | DevoTv Generic Keywords
| Library | datadrivenlibrary.CsvLibrary
| Library | Collections
| Library | String
| Library | DateTime
| Library | random
| Variables | ../../pagelibraries/resources/config.py
| Library | ../custom_keywords.py
| Resource | utils/common.robot
| Resource | utils/generic-keywords.robot
| Resource |   utils/api-generic-keyword.robot
| Library | utils.environmentsetup
| Library  | utils/db.py
| Library  | PageObjectLibrary
| Library  | SeleniumLibrary
| Library  | Process
| Library  | RequestsLibrary
| Library  | REST | ${CONFIG.api_url}
| Resource | utils/api-status-and-errors-keyword.robot
| Library | ../../pagelibraries/resources/PayloadAdminAdvertiser.py
| Library | ../../pagelibraries/resources/payloadAdminPublisher.py
| Library | ../../pagelibraries/resources/payloadAdminReport.py
| Library | ../../pagelibraries/resources/payloadUserMngmnt&Brand.py

***Variables***
| ${pathtocsvfile} | ${CONFIG.data_file_path}
| ${user_mangmnt_datafile} | ${CONFIG.user_mangmnt_datafile}
| ${cms_datafile} | ${CONFIG.cms_datafile}
| ${admad_datafile} | ${CONFIG.admad_datafile}
| ${admpub_datafile} | ${CONFIG.admpub_datafile}
| ${adm_report_datafile} | ${CONFIG.adm_reports_datafile}
| ${host} | ${CONFIG.host}
| ${domain} | ${CONFIG.domain}
| ${endpoint} | ${CONFIG.endpoint}
| ${brand_file} | ${pathtocsvfile}/Brand.csv
| ${advertiser_id} | None
| ${admin_advertiser_campagin_id} | None
| ${add_product_admin_advertiser_campagin_resp_body_id} | None
| ${admin_advertiser_product_offer_ads_id} | None
| ${admin_advertiser_contract_product_offerasset_id_logo} | None
| ${admin_advertiser_product_id} | None
| ${admin_contract_id} | None
| ${account_id} | None
| ${adm_pub_publisher_id} | None
| ${admin_pub_contract_id} | None
| ${admin_pub_content_id} | None
| ${admin_pub_sso_id} | None


***Keywords***

| User Login and Get the token
| | [Documentation] | User Expected to Set the Header
| | [Arguments] | ${uri} | ${body} | ${Expected_status_code}=200
| | User Initiate Post call and verify Status Response | ${uri} | ${admad_datafile}login-and-get-the-token.json | ${Expected_status_code} | ${body}
| | ${resp_data} | Output | response body
| | ${headers}= | Concatenate the Two String with | ${resp_data}[token_type] | ${resp_data}[access_token]
| | Set Headers | ${headers}

| User Creates the Payload
| | [Documentation] | User Expected to Create the Payload data
| | [Arguments] | ${payload_data}
| | ${body}= | Return Response Data | ${payload_data}
| | Set Test Variable | ${body}

| User Validate the Expected data
| | [Documentation] | User Expected to hold the data which are been used to compare with response body.
| | [Arguments] | ${data}
| | ${data_variable}= | Return Response Data | ${data}
| | Set Test Variable  | ${data_variable}

| User Validates the Schema
| | [Documentation] | User expected to validate the schema
| | [Arguments] | ${expected} | ${actual}
| | ${API_output} | Get File | ${admad_datafile}${actual}.json
| | ${swagger_file} | Get File | ${admad_datafile}${expected}.json
| | ${API_output} | Evaluate | json.loads('''${API_output}''') | json
| | ${swagger_file} | Evaluate | json.loads('''${swagger_file}''') | json
| | Log | ${swagger_file}
| | Log | ${API_output}[0][schema]
| | Validate the Data with Schema | ${API_output}[0][schema] | ${swagger_file}

# | User Validate Response Data
# | | [Documentation] | User Expected to Validate the Response Data.
# | | [Arguments] | ${data} | ${filename}
# | | ${actual} | Get File | ${admad_datafile}${filename}
# | | ${actual} | Evaluate | json.loads('''${actual}''') | json
# | | Log | ${data}
# | | Log | ${actual}
# | | Log | ${actual}[2][response][body]
# | | Should Be Equal | ${data} | ${actual}[2][response][body]

| User Validates Positive Response
| | [Arguments] | ${content} | ${file_name}
| | ${data} | User get the payload from datafiles | ${file_name}
| | ${data} | Set Variable | ${data}[1]
# | | Should be equal | response body success | ${content}[title]
# | | Should be equal | ${data}[title] | ${content}[title]

| User Validates Negative Response
| | [Arguments] | ${content} | ${file_name} 
| | ${data} | User get the payload from datafiles | ${file_name}
| | ${data} | Set Variable | ${data}[1]
# | | Should be equal | response body title | ${content}[title]
# | | Should be equal | &{data}[failure_code] | ${content}[failure_code]
# | | Should be equal | &{data}[message] | ${content}[message]

| User Creates the Payload from CSV and upload
| | [Documentation] | User Expected to Upload the CSV data to the respected API.
| | [Arguments] | ${payload}
| | ${count} | Get Num of Active Rows CSV | ${brand_file}
| | Log | ${count}
| | FOR | ${i} | IN RANGE | 1 | ${count}
| | &{value} | Read From Csv In Dict | ${brand_file} | ${i}  
| | ${payload} | Return Payload From CSV | ${value}
| | User Creates the Payload | ${payload}
| | ${body} | evaluate | json.dumps(${body}) | json
| | Log | ${body}
| | Run Keyword And Continue On Failure | User Add the new Brand data for advertiser | /v1/cms/brand | 201
| | END

| User get the payload from user management datafiles
| | [Documentation] | User Expected to get payload body
| | [Arguments] | ${file_name}
| | ${data_file} | Get File | ${user_mangmnt_datafile}${file_name}
| | ${data_file} | Evaluate | json.loads('''${data_file}''') | json
| | Log | ${data_file}[-1]
| | ${req_body} | Set Variable | ${data_file}[-1][request][body]
| | ${resp_body} | Set Variable | ${data_file}[-1][response][body]
| | [Return] | ${req_body} | ${resp_body}

| User get the payload from cms datafiles
| | [Documentation] | User Expected to get payload body
| | [Arguments] | ${file_name}
| | ${data_file} | Get File | ${cms_datafile}${file_name}
| | ${data_file} | Evaluate | json.loads('''${data_file}''') | json
| | Log | ${data_file}[-1]
| | ${req_body} | Set Variable | ${data_file}[-1][request][body]
| | ${resp_body} | Set Variable | ${data_file}[-1][response][body]
| | [Return] | ${req_body} | ${resp_body}

| User get the payload from datafiles
| | [Documentation] | User Expected to get payload body
| | [Arguments] | ${file_name}
| | ${data_file} | Get File | ${admad_datafile}${file_name}
| | ${data_file} | Evaluate | json.loads('''${data_file}''') | json
| | Log | ${data_file}[-1]
| | ${req_body} | Set Variable | ${data_file}[-1][request][body]
| | ${resp_body} | Set Variable | ${data_file}[-1][response][body]
| | [Return] | ${req_body} | ${resp_body}

| User get the payload from admin publisher datafiles
| | [Documentation] | User Expected to get payload body
| | [Arguments] | ${file_name}
| | ${data_file} | Get File | ${admpub_datafile}${file_name}
| | ${data_file} | Evaluate | json.loads('''${data_file}''') | json
| | Log | ${data_file}[-1]
| | ${req_body} | Set Variable | ${data_file}[-1][request][body]
| | ${resp_body} | Set Variable | ${data_file}[-1][response][body]
| | [Return] | ${req_body} | ${resp_body}

| User get the payload from admin report datafiles
| | [Documentation] | User Expected to get payload body
| | [Arguments] | ${file_name}
| | ${data_file} | Get File | ${adm_report_datafile}${file_name}
| | ${data_file} | Evaluate | json.loads('''${data_file}''') | json
| | Log | ${data_file}[-1]
| | ${req_body} | Set Variable | ${data_file}[-1][request][body]
| | ${resp_body} | Set Variable | ${data_file}[-1][response][body]
| | [Return] | ${req_body} | ${resp_body}

| User set the Variables for add admin user
| | [Documentation] | User expected to test set the variables for the admin advertiser
| | [Arguments] | ${output_data_file}
| | ${add_admin_user} | User get the payload from user management datafiles | ${output_data_file}
# | | ${add_admin_user_req_body} | Set Variable | ${add_admin_user}[0]
| | ${add_admin_user_resp_body} | Set Variable | ${add_admin_user}[1]
# | | Set Global Variable | ${add_admin_user_req_body}
| | ${add_admin_user_id} | Set Variable | ${add_admin_user_resp_body}[user_id]
| | Set Global Variable | ${add_admin_user_id}

| User set the Variables for brand
| | [Documentation] | User expected to test set the variables for the admin advertiser
| | [Arguments] | ${output_data_file}
| | ${brand_data} | User get the payload from cms datafiles | ${output_data_file}
| | ${brand_req_body} | Set Variable | ${brand_data}[0]
| | ${brand_resp_body} | Set Variable | ${brand_data}[1]
| | Set Global Variable | ${brand_req_body}
| | ${brand_id} | Set Variable | ${brand_resp_body}[id]
| | Set Global Variable | ${brand_id}

| User set the Variables for admin advertiser
| | [Documentation] | User expected to test set the variables for the admin advertiser
| | ${Admin_Advertiser} | User get the payload from datafiles | Creates-Admin-Advertiser.json
| | ${advertiser_req_body} | Set Variable | ${Admin_Advertiser}[0]
| | ${advertiser_resp_body} | Set Variable | ${Admin_Advertiser}[1]
| | Set Global Variable | ${advertiser_req_body}
| | ${advertiser_id} | Set Variable | ${advertiser_resp_body}[id]
| | Set Global Variable | ${advertiser_id}

| User set the variables for Admin advertiser updates
| | [Documentation] | User expected to test set the variables for the admin advertiser
| | ${Admin_Advertiser_update} | User get the payload from datafiles | Admin-advertiser-update.json
| | ${admin_advertiser_update_req_body} | Set Variable | ${Admin_Advertiser_update}[0]
| | Set Global Variable | ${admin_advertiser_update_req_body}

| User set the Variables for admin advertiser contract
| | [Documentation] | User expected to test set the variables for the admin advertiser
| | ${Admin_Advertiser_contract} | User get the payload from datafiles | Creates-Admin-Advertiser-contract.json
| | ${Advertiser_contract_req_body} | Set Variable | ${Admin_Advertiser_contract}[0]
| | ${Advertiser_contract_resp_body} | Set Variable | ${Admin_Advertiser_contract}[1]
| | ${admin_contract_id} | Set Variable | ${Advertiser_contract_resp_body}[id]
| | Set Global Variable | ${Advertiser_contract_req_body}
| | Set Global Variable | ${admin_contract_id}
| | Set To Dictionary | ${Advertiser_contract_req_body} | is_save_and_confirm | ${TRUE}
| | Remove From Dictionary | ${Advertiser_contract_req_body} | company_address
| | ${Advertiser_contract_req_body_approve} | Set Variable | ${Advertiser_contract_req_body}
| | Set Global Variable | ${Advertiser_contract_req_body_approve}
| | ${admin_contract_start_date} | Set Variable | ${Advertiser_contract_resp_body}[contract_start_date]
| | Set Global Variable | ${admin_contract_start_date}
| | ${admin_contract_end_date} | Set Variable | ${Advertiser_contract_resp_body}[contract_end_date]
| | Set Global Variable | ${admin_contract_end_date}

| User set the variables for admin advertiser contract update
| | [Documentation] | User expected to test set the variables for the admin advertiser
| | ${Admin_Advertiser_contract_update} | User get the payload from datafiles | admin-advertiser-contract-update.json
| | ${admin_advertiser_contract_update_req_body} | Set Variable | ${Admin_Advertiser_contract_update}[0]
| | Set Global Variable | ${admin_advertiser_contract_update_req_body}

| User set the variables for Admin Advertiser contract final approval
| | [Documentation] | User expected to test set the variables for the admin advertiser
| | ${Admin_Advertiser_contract_final_approval} | User get the payload from datafiles | approve-final-admin-advertiser-contract.json
| | ${Admin_Advertiser_contract_final_approval_req_body} | Set Variable | ${Admin_Advertiser_contract_final_approval}[0]
| | Set Global Variable | ${Admin_Advertiser_contract_final_approval_req_body}

| User set the Variables for admin advertiser product
| | [Documentation] | User expected to set the Variables for admin advertiser product
| | ${Admin_Advertiser_product} | User get the payload from datafiles | admin-advertiser-product.json
| | ${admin_Advertiser_product_req_body} | Set Variable | ${Admin_Advertiser_product}[0]
| | ${admin_Advertiser_product_resp_body} | Set Variable | ${Admin_Advertiser_product}[1]
| | ${admin_advertiser_product_id} | Set Variable | ${admin_Advertiser_product_resp_body}[id]
| | Set Global Variable | ${admin_advertiser_product_id}
| | Set Global Variable | ${admin_advertiser_product_req_body}

| User set the variables for Admin advertiser product update
| | [Documentation] | User expected to test set the variables for the admin advertiser
| | ${Admin_Advertiser_product_update} | User get the payload from datafiles | admin-advertiser-product-update.json
| | ${Admin_Advertiser_product_update_req_body} | Set Variable | ${Admin_Advertiser_product_update}[0]
| | Set Global Variable | ${Admin_Advertiser_product_update_req_body}

| User set the Variables for admin advertiser contract product offerasset Offer Logo
| | [Documentation] | User expected to set the Variables for admin advertiser contract product offerasset
| | ${admin_advertiser_contract_product_offerasset_logo} | User get the payload from datafiles | Offer-Logo-create-admin-advertiser-contract-product-offerasset.json
| | ${admin_advertiser_contract_product_offerasset_logo_req_body} | Set Variable | ${admin_advertiser_contract_product_offerasset_logo}[0]
| | ${admin_advertiser_contract_product_offerasset_logo_resp_body} | Set Variable | ${admin_advertiser_contract_product_offerasset_logo}[1]
| | ${admin_advertiser_contract_product_offerasset_id_logo} | Set Variable | ${admin_advertiser_contract_product_offerasset_logo_resp_body}[id]
| | Set Global Variable | ${admin_advertiser_contract_product_offerasset_id_logo}
| | Set Global Variable | ${admin_advertiser_contract_product_offerasset_logo_req_body}

| User set the Variables for admin advertiser contract product offerasset Email Offer Image
| | [Documentation] | User expected to set the Variables for admin advertiser contract product offerasset
| | ${admin_advertiser_contract_product_offerasset_Image} | User get the payload from datafiles | email-create-admin-advertiser-contract-product-offerasset.json
| | ${admin_advertiser_contract_product_offerasset_image_req_body} | Set Variable | ${admin_advertiser_contract_product_offerasset_Image}[0]
| | ${admin_advertiser_contract_product_offerasset_image_resp_body} | Set Variable | ${admin_advertiser_contract_product_offerasset_Image}[1]
| | ${admin_advertiser_contract_product_offerasset_id_image} | Set Variable | ${admin_advertiser_contract_product_offerasset_image_resp_body}[id]
| | Set Global Variable | ${admin_advertiser_contract_product_offerasset_id_image}
| | Set Global Variable | ${admin_advertiser_contract_product_offerasset_image_req_body}

| User set the Variables for admin advertiser product offer ads
| | [Documentation] | User expected to set the Variables for admin advertiser product offer ads
| | ${admin_advertiser_product_offer_ads} | User get the payload from datafiles | create-admin-advertiser-product-offer-ads.json
| | ${admin_advertiser_product_offer_ads_req_body} | Set Variable | ${admin_advertiser_product_offer_ads}[0]
| | ${admin_advertiser_product_offer_ads_resp_body} | Set Variable | ${admin_advertiser_product_offer_ads}[1]
| | ${admin_advertiser_product_offer_ads_id} | Set Variable | ${admin_advertiser_product_offer_ads_resp_body}[id]
| | Set Global Variable | ${admin_advertiser_product_offer_ads_id}
| | Set Global Variable | ${admin_advertiser_product_offer_ads_req_body}

| User set the Variables for changing status of admin advertiser product offer ads
| | [Documentation] | User expected to set the Variables for admin advertiser product offer ads
| | ${admin_advertiser_product_offer_ads_update_status} | User get the payload from datafiles | update-status-admin-advertiser-product-offer-ads.json
| | ${admin_advertiser_product_offer_ads_update_status_resp_body} | Set Variable | ${admin_advertiser_product_offer_ads_update_status}[1]
| | ${admin_advertiser_product_offer_ads_update_status_req_body_id} | Set Variable | ${admin_advertiser_product_offer_ads_update_status_resp_body}[id]
| | Set Global Variable | ${admin_advertiser_product_offer_ads_update_status_req_body_id}

| User set the Variables for admin advertiser campagin
| | [Documentation] | User expected to test set the variables for the admin advertiser
| | ${admin_advertiser_campagin} | User get the payload from datafiles | admin-advertiser-campagin.json
| | ${admin_advertiser_campagin_req_body} | Set Variable | ${admin_advertiser_campagin}[0]
| | ${admin_advertiser_campagin_resp_body} | Set Variable | ${admin_advertiser_campagin}[1]
| | Set Global Variable | ${admin_advertiser_campagin_req_body}
| | ${admin_advertiser_campagin_id} | Set Variable | ${admin_advertiser_campagin_resp_body}[id]
| | Set Global Variable | ${admin_advertiser_campagin_id}
| | ${admin_advertiser_campagin_start_date} | Set Variable | ${admin_advertiser_campagin_resp_body}[contract_start_date]
| | Set Global Variable | ${admin_advertiser_campagin_start_date}
| | ${admin_advertiser_campagin_end_date} | Set Variable | ${admin_advertiser_campagin_resp_body}[contract_end_date]
| | Set Global Variable | ${admin_advertiser_campagin_end_date}

| User set the Variables for add the product to admin advertiser campagin
| | [Documentation] | User expected to test set the variables for the admin advertiser
| | ${add_product_admin_advertiser_campagin} | User get the payload from datafiles | add-the-product-to-admin-advertiser-campagin.json
| | ${add_product_admin_advertiser_campagin_resp_body} | Set Variable | ${add_product_admin_advertiser_campagin}[1]
| | ${add_product_admin_advertiser_campagin_resp_body_id} | Set Variable | ${add_product_admin_advertiser_campagin_resp_body}[0][id]
| | Set Global Variable | ${add_product_admin_advertiser_campagin_resp_body_id}

| User Creates the Payload for add new admin user
| | [Documentation] | User Expected to Create the Payload data
| | [Arguments] | ${payload_data}
| | ${body}= | create_admin_add_user | ${payload_data}
| | Set Test Variable | ${body}

| User Creates the Payload for Brand
| | [Documentation] | User Expected to Create the Payload data
| | [Arguments] | ${payload_data}
| | ${body}= | create_brand | ${payload_data}
| | Set Test Variable | ${body}

| User Creates the Payload for Brand update
| | [Documentation] | User Expected to Create the Payload data
| | ${body}= | update_brand | ${brand_req_body}
| | Set Test Variable | ${body}

| User Creates the Payload for Admin advertiser
| | [Documentation] | User Expected to Create the Payload data
| | [Arguments] | ${payload_data}
| | ${body}= | create_admin_advertiser | ${payload_data}
| | Set Test Variable | ${body}

| User modifiying the Payload for Admin advertiser
| | [Documentation] | User Expected to Create the Payload data
| | [Arguments] | ${field_name} | ${TC_action}=create
| | ${body}= | modify_admin_advertiser | ${advertiser_req_body} | ${field_name} | ${TC_action}
| | Set Test Variable | ${body}

| User Creates the Payload for Admin advertiser updates
| | [Documentation] | User Expected to Create the Payload data
| | ${body}= | create_admin_advertiser_update | ${advertiser_req_body}
| | Set Test Variable | ${body}

| User modify the Payload for Admin advertiser updates
| | [Documentation] | User Expected to Create the Payload data
| | [Arguments] | ${field_name} | ${TC_action}=update
| | ${body}= | modify_admin_advertiser | ${admin_advertiser_update_req_body} | ${field_name} | ${TC_action}
| | Set Test Variable | ${body}

| User Creates the Payload for Admin advertiser contract
| | [Documentation] | User Expected to Create the Payload data
| | [Arguments] | ${payload_data}
| | ${body}= | create_admin_advertiser_contract | ${payload_data} | ${admin_advertiser_product_id}
| | Set Test Variable | ${body}

| User Modify the Payload for Admin advertiser contract
| | [Documentation] | User Expected to Create the Payload data
| | [Arguments] | ${field_name} | ${TC_action}=create
| | ${body}= | modify_admin_advertiser_contract | ${Advertiser_contract_req_body} | ${field_name} | ${TC_action}
| | Set Test Variable | ${body}

| User Creates the Payload for Admin advertiser contract updates
| | [Documentation] | User Expected to Create the Payload data
| | ${body}= | create_admin_advertiser_contract_update | ${Advertiser_contract_req_body}
| | Set Test Variable | ${body}

| User modify the Payload for Admin advertiser contract updates
| | [Documentation] | User Expected to Create the Payload data
| | [Arguments] | ${field_name} | ${TC_action}=update
| | ${body}= | modify_admin_advertiser_contract | ${admin_advertiser_contract_update_req_body} | ${field_name} | ${TC_action}
| | Set Test Variable | ${body}

| User modify the Payload for Admin advertiser contract confirm & save
| | [Documentation] | User Expected to Create the Payload data
| | [Arguments] | ${field_name}
| | ${body}= | modify_admin_advertiser_contract_save_and_confirm | ${Advertiser_contract_req_body_approve} | ${field_name}
| | Set Test Variable | ${body}

| User modify the Payload for Admin advertiser contract final approve
| | [Documentation] | User Expected to Create the Payload data
| | [Arguments] | ${field_name}
| | ${body}= | admin_advertiser_contract_final_approve | ${Admin_Advertiser_contract_final_approval_req_body} | ${field_name}
| | Set Test Variable | ${body}

| User Creates the Payload for admin advertiser contract product add
| | [Documentation] | User Expected to Create the Payload data
| | [Arguments] | ${payload_data}
| | ${body}= | create_admin_advertiser_contract_product_add | ${payload_data}
| | Set Test Variable | ${body}

| User Creates the Payload for admin advertiser product
| | [Documentation] | User Expected to Create the Payload data
| | [Arguments] | ${payload_data}
| | ${body}= | create_admin_advertiser_product | ${payload_data}
| | Set Test Variable | ${body}

| User Modify the Payload for admin advertiser product
| | [Documentation] | User Expected to Create the Payload data
| | [Arguments] | ${field_name} | ${TC_action}=create
| | ${body}= | modify_admin_advertiser_product | ${admin_advertiser_product_req_body} | ${field_name} | ${TC_action}
| | Set Test Variable | ${body}

| User Creates the Payload for admin advertiser product update
| | [Documentation] | User Expected to Create the Payload data
| | ${body}= | create_admin_advertiser_product_update | ${admin_advertiser_product_req_body}
| | Set Test Variable | ${body}

| User Modify the Payload for admin advertiser product update
| | [Documentation] | User Expected to Create the Payload data
| | [Arguments] | ${field_name} | ${TC_action}=update
| | ${body}= | modify_admin_advertiser_product | ${Admin_Advertiser_product_update_req_body} | ${field_name} | ${TC_action}
| | Set Test Variable | ${body}

| User Creates the Payload for admin advertiser contract product offerasset
| | [Documentation] | User Expected to Create the Payload data
| | [Arguments] | ${payload_data} 
| | ${body}= | create_admin_advertiser_contract_product_offerasset | ${payload_data} | ${advertiser_id}
| | Set Test Variable | ${body}

| User Modify the Payload for admin advertiser contract product offerasset
| | [Documentation] | User Expected to Create the Payload data
| | [Arguments] | ${field_name} | ${TC_action}=create
| | ${body}= | modify_admin_advertiser_contract_product_offerasset | ${admin_advertiser_contract_product_offerasset_logo_req_body} | ${field_name} | ${TC_action}
| | Set Test Variable | ${body}

| User Creates the Payload for admin advertiser contract product offerasset update
| | [Documentation] | User Expected to Create the Payload data
| | ${body}= | create_admin_advertiser_contract_product_offerasset_update | ${admin_advertiser_contract_product_offerasset_logo_req_body}
| | Set Test Variable | ${body}

| User Creates the Payload for admin advertiser product ads
| | [Documentation] | User Expected to Create the Payload data
| | [Arguments] | ${payload_data}
| | ${body}= | create_admin_advertiser_product_ads | ${payload_data} | ${advertiser_id} | ${admin_advertiser_product_id} | ${admin_advertiser_contract_product_offerasset_id_logo} | ${admin_advertiser_contract_product_offerasset_id_image}
| | Set Test Variable | ${body}

| User Creates the Payload for admin advertiser product offer ads update
| | [Documentation] | User Expected to Create the Payload data
| | ${body}= | create_admin_advertiser_product_ads_update | ${admin_advertiser_product_offer_ads_req_body}
| | Set Test Variable | ${body}

| User Creates the Payload for admin advertiser campagin
| | [Documentation] | User Expected to Create the Payload data
| | [Arguments] | ${payload_data}
| | ${body}= | create_admin_advertiser_campagin | ${payload_data} | ${admin_contract_start_date} | ${admin_contract_end_date}
| | Set Test Variable | ${body}

| User Creates the Payload for Admin Advertiser campagin update
| | [Documentation] | User Expected to Create the Payload data
| | ${body}= | create_admin_advertiser_campagin_update | ${admin_advertiser_campagin_req_body}
| | Set Test Variable | ${body}

| User Creates the Payload for add the product to admin advertiser campagin
| | [Documentation] | User Expected to Create the Payload data
| | [Arguments] | ${payload_data}
| | ${body}= | create_add_the_product_admin_advertiser_campagin | ${payload_data} | ${admin_advertiser_campagin_id} | ${advertiser_id} | ${admin_advertiser_product_id} | ${admin_advertiser_campagin_start_date} | ${admin_advertiser_campagin_end_date} | ${admin_advertiser_product_offer_ads_update_status_req_body_id}
| | Set Test Variable | ${body}

| User Creates the Payload with filter
| | [Documentation] | User Expected to Initiate the post call and verifies the status code of the Response
| | [Arguments] | ${payload_name}
| | ${body}= | create_admin_report | ${output_resp} | ${payload_name}
| | Set Test Variable | ${body}

| User Initiate POST call and verify Status Response
| | [Documentation] | User Expected to Initiate the post call and verifies the status code of the Response
| | [Arguments] | ${uri} | ${output} | ${Expected_status_code} | ${body}=None
| | Initiate Post Request | ${uri} | ${output} | ${body}
| | The Status Response ${Expected_status_code} Should Be Integer type
| | ${resp_data} | Output | response body

| User Initiate PUT call and verify Status Response
| | [Documentation] | User Expected to Initiate the Put call and verifies the status code of the Response
| | [Arguments] | ${uri} | ${output} | ${Expected_status_code} | ${body}=None
| | Initiate Put Request | ${uri} | ${output} | ${body}
| | The Status Response ${Expected_status_code} Should Be Integer type
| | ${resp_data} | Output | response body

| User Initiate GET call and verify Status Response
| | [Documentation] | User Expected to Initiate the post call and verifies the status code of the Response
| | [Arguments] | ${uri} | ${output} | ${Expected_status_code}
| | Initiate GET Request | ${uri} | ${output}
| | The Status Response ${Expected_status_code} Should Be Integer type
| | ${resp_data} | Output | response body

| User Initiate DELETE call and verify Status Response
| | [Documentation] | User expects to Delete a data by providing the ID
| | [Arguments] | ${uri} | ${output} | ${Expected_status_code} | ${body}=None
| | Initiate Delete Request | ${uri} | ${output} | ${body}
| | The Status Response ${Expected_status_code} Should Be Integer type
| | ${resp_data} | Output | response body

| GET all existing user for advertiser
| | [Documentation] | User Expected to get all the brands for advertiser
| | [Arguments] | ${uri} | ${Expected_status_code} | ${file_name}
| | User Initiate GET call and verify Status Response | ${uri} | ${cms_datafile}${file_name} | ${Expected_status_code}
| | Output | response body
# | | String | $[1].id | ${data_variable}[id]
# | | String | $[1].name | ${data_variable}[name]

| User Add the new Brand data for advertiser
| | [Documentation] | User Expected to add/create a new brand 
| | [Arguments] | ${uri} | ${Expected_status_code} | ${file_name}
| | User Initiate POST call and verify Status Response | ${uri} | ${cms_datafile}${file_name} | ${Expected_status_code} | ${body}

| User get existing brand data by ID
| | [Documentation] | User Expected to get the existing data by ID
| | [Arguments] | ${Expected_status_code} | ${file_name}
| | ${uri} | generate_api_url | brand_api | id=${brand_id}
| | User Initiate GET call and verify Status Response | ${uri} | ${cms_datafile}${file_name} | ${Expected_status_code}
| | ${resp_data} | Output | response body

| User updates the Existing brands data
| | [Documentation] | User Expected to get the existing data by ID
| | [Arguments] | ${Expected_status_code} | ${file_name}
| | ${uri} | generate_api_url | brand_api | id=${brand_id}
| | User Initiate PUT call and verify Status Response | ${uri} | ${cms_datafile}${file_name} | ${Expected_status_code} | ${body}
| | ${resp_data} | Output | response body

| User GET Admin Advertiser contract Details
| | [Documentation] | User Expected to get the existing data by ID
| | [Arguments] | ${uri} | ${Expected_status_code} | ${content}
| | User Initiate GET call and verify Status Response | ${uri} | ${admad_datafile}get-all-existing-contract_details_by_AdvertiserID.json | ${Expected_status_code}
| | ${resp_data} | Output | response body
| | Should Be Equal | ${resp_data}[${content}] | ${data_variable}[${content}]

# | User Compare the API response body with Expected data
# | | [Documentation] | User Expected to compare the Response data from API and Expected data.
# | | [Arguments] | ${Expected_body}
# | | Log | ${Expected_body}
# | | String | response body id | ${Expected_body}[id]
# | | String | response body name | ${Expected_body}[name]
# | | String | response body tagline | ${Expected_body}[tagline]
# | | Integer | response body popularity_score | ${Expected_body}[popularity_score]
# | | String | response body country_of_origin_code | ${Expected_body}[country_of_origin_code]
# | | String | response body identity_logo_url | ${Expected_body}[identity_logo_url]
# | | String | response body parent_company_name | ${Expected_body}[parent_company_name]
# | | String | response body related_tags | ${Expected_body}[related_tags]
# | | Integer | response body industry_classification id | ${Expected_body}[industry_classification][id]
# | | String | response body industry_classification name | ${Expected_body}[industry_classification][name]

| User updates an Existing data for advertiser
| | [Documentation] | User Expected to updates the data which Already Exist for advertiser
| | [Arguments] | ${content} | ${Expected_status_code} | ${file_name}
| | ${uri} | generate_api_url | product_ads_status | id=${advertiser_id} | product_ad_id=${admin_advertiser_product_offer_ads_id}
| | User Initiate PUT call and verify Status Response | ${uri} | ${admad_datafile}${file_name} | ${Expected_status_code} | ${body}
| | ${resp_data} | Output | response body
| | Set Test Variable | ${resp_data}

| User Deletes an Existing data for brands
| | [Documentation] | User expects to Delete a data by providing the brand's ID for advertiser
| | [Arguments] | ${Expected_status_code} | ${file_name}
| | ${uri} | generate_api_url | brand_api | id=${brand_id}
| | User Initiate DELETE call and verify Status Response | ${uri} | ${cms_datafile}${file_name} | ${Expected_status_code}
| | ${resp_data} | Output | response body

| User Logs into the existing account for admin
| | [Documentation] | User expected to login with existing account
| | [Arguments] | ${uri} | ${Expected_status_code} | ${file_name}
| | User Initiate POST call and verify Status Response | ${uri} | ${user_mangmnt_datafile}${file_name} | ${Expected_status_code} | ${body}
| | ${resp_data} | Output | response body

| User Logs into the existing account
| | [Documentation] | User expected to login with existing account
| | [Arguments] | ${uri} | ${Expected_status_code} | ${content}
| | User Initiate POST call and verify Status Response | ${uri} | ${admad_datafile}logs-into-existing-account.json | ${Expected_status_code} | ${body}
| | ${resp_data} | Output | response body
| | Should Be Equal | ${resp_data}[${content}] | ${data_variable}[${content}]

| User Resgister to an Application
| | [Documentation] | User Expected to Register for Advertiser
| | [Arguments] | ${uri} | ${Expected_status_code} | ${content} | ${file_name}
| | User Initiate Post call and verify Status Response | ${uri} | ${admad_datafile}${file_name} | ${Expected_status_code} | ${body}
| | ${resp_data} | Output | response body
# | | Should Be Equal | ${resp_data}[${content}] | ${data_variable}[${content}]

| User get the account id for admin advertiser
| | [Documentation] | User Expected to Register for Advertiser
| | [Arguments] | ${Expected_status_code}=200
| | ${Uri} | generate_api_url | create_user_account | id=${advertiser_id}
| | User Initiate GET call and verify Status Response | ${Uri} | ${admad_datafile}get-account-id.json | ${Expected_status_code}
| | ${resp_data} | Output | response body
| | ${account_id} | Set Variable | ${resp_data}[0][account_id]
| | Set Global Variable | ${account_id}

| User Logout from an Application
| | [Documentation] | User Expected to Logout from current User
| | [Arguments] | ${uri} | ${Expected_status_code} | ${content}
| | User Initiate Post call and verify Status Response | ${uri} | ${admad_datafile}logout-from-application.json | ${Expected_status_code}
| | ${resp_data} | Output | response body
| | Should Be Equal | ${resp_data}[${content}] | ${data_variable}[${content}]

| User Adds the new admin user
| | [Documentation] | User Expected to Add new user data
| | [Arguments] | ${uri} | ${Expected_status_code} | ${file_name} | ${content}
| | User Initiate Post call and verify Status Response | ${uri} | ${user_mangmnt_datafile}${file_name} | ${Expected_status_code} | ${body}
| | ${resp_data} | Output | response body
# | | Should Be Equal | ${resp_data}[${content}] | ${data_variable}[${content}]

| User GET all existing user
| | [Documentation] | User Expected to
| | [Arguments] | ${uri} | ${Expected_status_code} | ${file_name}
| | User Initiate GET call and verify Status Response | ${uri} | ${admad_datafile}${file_name} | ${Expected_status_code}
| | ${resp_data} | Output | response body

| User Updates an Existing data As Admin
| | [Documentation] | User expected to Update the Existing data by Userid as Admin
| | [Arguments] | ${Expected_status_code} | ${content} | ${file_name}
| | ${uri} | generate_api_url | admin_user | id=${add_admin_user_id}
| | User Initiate Put call and verify Status Response | ${uri} | ${user_mangmnt_datafile}${file_name} | ${Expected_status_code} | ${body}
| | ${resp_data} | Output | response body
# | | Should Be Equal | ${resp_data}[${content}] | ${data_variable}[${content}]

| User Deletes the existing users data as Admin
| | [Documentation] | User expects to Delete a data by providing the brand's ID for advertiser
| | [Arguments] | ${uri} | ${Expected_status_code} | ${content}
| | ${uri} | generate_api_url | update_advertiser | id=${advertiser_id}
| | User Initiate DELETE call and verify Status Response | ${uri} | ${admad_datafile}delete-existing-data-as-admin.json | ${Expected_status_code}
| | ${resp_data} | Output | response body
| | Should Be Equal | ${resp_data}[${content}] | ${data_variable}[${content}]

| User Verifies email as Admin User
| | [Documentation] | User expects to Verify email as Admin user.
| | [Arguments] | ${uri} | ${Expected_status_code} | ${content}
| | User Initiate Post call and verify Status Response | ${uri} | ${admad_datafile}verifies-email-as-admin.json | ${Expected_status_code} | ${body}
| | ${resp_data} | Output | response body
| | Should Be Equal | ${resp_data}[${content}] | ${data_variable}[${content}]

| User Set the password for Admin new account
| | [Documentation] | User expects to set password by for admin new account
| | [Arguments] | ${uri} | ${Expected_status_code} | ${content}
| | User Initiate Post call and verify Status Response | ${uri} | ${admad_datafile}set-password-as-admin.json | ${Expected_status_code} | ${body}
| | ${resp_data} | Output | response body
| | Log | ${resp_data}[${content}]
| | Should Be Equal | ${resp_data}[${content}] | ${data_variable}[${content}]

| User changes the password for admin using ID
| | [Documentation] | User expects to change the password by using ID.
| | [Arguments] | ${Expected_status_code} | ${content} | ${file_name}
| | ${uri} | generate_api_url | add_admin_user | id=${add_admin_user_id}
| | User Initiate Post call and verify Status Response | ${uri} | ${user_mangmnt_datafile}${file_name} | ${Expected_status_code} | ${body}
| | ${resp_data} | Output | response body
# | | Should Be Equal | ${resp_data}[${content}] | ${data_variable}[${content}]

| User Reset the Password for Admin
| | [Documentation] | User Expected to Reset the password for admin.
| | [Arguments] | ${uri} | ${Expected_status_code} | ${content}
| | User Initiate Post call and verify Status Response | ${uri} | ${admad_datafile}changes-password-as-admin-using-ID.json | ${Expected_status_code} | ${body}
| | ${resp_data} | Output | response body
| | Should Be Equal | ${resp_data}[${content}] | ${data_variable}[${content}]

| User Resgister to an Application for upload content
| | [Documentation] | User Expected to Register for publisher
| | [Arguments] | ${csv_file_name} | ${Expected_status_code} | ${Expected_status_code_Put} | ${adm_pub_publisher_id}=5481c4ff-c9b0-4ee2-b234-d7a883dc11b3
| | ${amazonaws_uri} | get_uri_for_admin_pub_upload_content_amazon | ${csv_file_name} | ${adm_pub_publisher_id}
| | User Initiate Post call and verify Status Response | ${amazonaws_uri} | ${admad_datafile}URL-creation-for-upload-content.json | ${Expected_status_code}
| | ${resp_data} | Output | response body
| | Log | ${pathtocsvfile}sample.csv
| | ${response} | trigger_put_call_upload_the_file | ${resp_data}[uploadURL] 
| | ${content_uri} | get_uri_for_admin_pub_upload_content | ${adm_pub_publisher_id}
| | ${body}= | Set Variable | {"file_key":"${resp_data}[Key]"}
| | Log | ${body}
| | User Initiate Post call and verify Status Response | ${content_uri} | ${admad_datafile}creation-call-for-upload-content.json | ${Expected_status_code_Put} | ${body}
| | ${resp_data} | Output | response body

| User Creates the Payload for Admin Publisher
| | [Documentation] | User Expected to Create the Payload data
| | [Arguments] | ${payload_data}
| | ${body}= | create_admin_publisher | ${payload_data}
| | Set Test Variable | ${body}

| User Creates the Payload for Admin publisher updates
| | [Documentation] | User Expected to Create the Payload data
| | ${body}= | create_admin_publisher_update | ${publisher_req_body}
| | Set Test Variable | ${body}

| User Creates the Payload for Admin Publisher Contract
| | [Arguments] | ${payload_data}
| | [Documentation] | User Expected to Create the Payload data
| | ${body}= | create_admin_publisher_contact | ${payload_data} | ${adm_pub_publisher_id}
| | Set Test Variable | ${body}

| User Creates the Payload for admin Publisher Contract update
| | [Documentation] | User Expected to Create the Payload data
| | ${body}= | create_admin_publisher_contact_update | ${admin_pub_contract_req_body}
| | Set Test Variable | ${body}

| User Creates the Payload for Admin Publisher Content
| | [Arguments] | ${payload_data}
| | [Documentation] | User Expected to Create the Payload data
| | ${body}= | create_admin_publisher_content | ${payload_data} | ${adm_pub_publisher_id}
| | Set Test Variable | ${body}

| User Creates the Payload for admin Publisher content update
| | [Documentation] | User Expected to Create the Payload data
| | ${body}= | create_admin_publisher_content_update | ${admin_pub_content_req_body}
| | Set Test Variable | ${body}

| User Creates the Payload for Generate Sandbox/Livesite Key for Admin Publisher
| | [Documentation] | User Expected to Create the Payload data
| | [Arguments] | ${payload_data}
| | ${body}= | create_admin_publisher_Sandbox_Key | ${payload_data} | ${adm_pub_publisher_id}
| | Set Test Variable | ${body}

| User Creates the Payload for Admin Publisher SSO setup
| | [Documentation] | User Expected to Create the Payload data
| | [Arguments] | ${payload_data}
| | ${body}= | create_admin_publisher_sso_setup | ${payload_data} | ${admin_pub_contract_id} | ${admin_pub_sandbox_site_url} | ${admin_pub_sandbox_activation_date} | ${admin_pub_livesite_site_url} | ${admin_pub_livesite_activation_date} 
| | Set Test Variable | ${body}

| User Creates the Payload for Admin Publisher SSO setup update
| | [Documentation] | User Expected to Create the Payload data
| | ${body}= | create_admin_publisher_sso_setup_update | ${admin_pub_sso_req_body} 
| | Set Test Variable | ${body}

| User creates the admin publisher
| | [Documentation] | User Expected to Register for publisher
| | [Arguments] | ${uri} | ${Expected_status_code} | ${file_name}
| | User Initiate Post call and verify Status Response | ${uri} | ${admpub_datafile}${file_name} | ${Expected_status_code} | ${body}
| | ${resp_data} | Output | response body

| User get the account id for admin publisher
| | [Documentation] | User Expected to Register for publisher
| | [Arguments] | ${Expected_status_code}=200
| | ${Uri} | generate_api_url | create_admin_Publisher_user_account | id=${adm_pub_publisher_id}
| | User Initiate GET call and verify Status Response | ${Uri} | ${admpub_datafile}get-account-id.json | ${Expected_status_code}
| | ${resp_data} | Output | response body
| | ${account_id} | Set Variable | ${resp_data}[0][account_id]
| | Set Global Variable | ${account_id}

| User Updates an Admin publisher
| | [Documentation] | User expected to Update the Existing data by Userid as Admin
| | [Arguments] | ${Expected_status_code} | ${file_name}
| | ${uri} | generate_api_url | admin_publisher_update | id=${adm_pub_publisher_id}
| | User Initiate Put call and verify Status Response | ${uri} | ${admpub_datafile}${file_name} | ${Expected_status_code} | ${body}
| | ${resp_data} | Output | response body

| User GET all admin publisher data
| | [Documentation] | User Expected to get all the brands
| | [Arguments] | ${uri} | ${Expected_status_code} | ${file_name}
| | User Initiate GET call and verify Status Response | ${uri} | ${admpub_datafile}${file_name} | ${Expected_status_code}
| | ${resp_data} | Output | response body
# | | Should Be Equal | ${resp_data}[${content}] | ${data_variable}[${content}]
# | | Should Be Equal | ${resp_data}[data][0][id] | ${data_variable}[id]

| User Creates Admin Publisher Contract
| | [Documentation] | User Expected to Register for publisher
| | [Arguments] | ${Expected_status_code} | ${file_name}
| | ${uri} | generate_api_url | admin_publisher_contract | id=${adm_pub_publisher_id}
| | User Initiate Post call and verify Status Response | ${uri} | ${admpub_datafile}${file_name} | ${Expected_status_code} | ${body}
| | ${resp_data} | Output | response body

| User Updates the status of an Admin publisher Sandbox/Livesite Key link
| | [Documentation] | User expected to Update the Existing data by Userid as Admin
| | [Arguments] | ${Expected_status_code} | ${file_name}
| | IF | '${file_name}' == 'update-status-admin-publisher-sandbox-Key.json'
| | ${uri} | generate_api_url | admin_publisher_sandbox_livesite_status | pub_id=${adm_pub_publisher_id} | id=${admin_pub_sandbox_api_key}
| | ELSE
| | ${uri} | generate_api_url | admin_publisher_sandbox_livesite_status | pub_id=${adm_pub_publisher_id} | id=${admin_pub_livesite_api_key}
| | END
| | User Initiate Put call and verify Status Response | ${uri} | ${admpub_datafile}${file_name} | ${Expected_status_code} | ${body}
| | ${resp_data} | Output | response body

| User set the Variables for admin publisher
| | [Documentation] | User expected to test set the variables for the admin publisher
| | ${Admin_Publisher} | User get the payload from admin publisher datafiles | Create-Admin-publisher.json
| | ${publisher_req_body} | Set Variable | ${Admin_Publisher}[0]
| | ${publisher_resp_body} | Set Variable | ${Admin_Publisher}[1]
| | Set Global Variable | ${publisher_req_body}
| | ${adm_pub_publisher_id} | Set Variable | ${publisher_resp_body}[id]
| | Set Global Variable | ${adm_pub_publisher_id}

| User set the Variables for admin publisher contract
| | [Documentation] | User expected to test set the variables for the admin Publisher
| | ${Admin_pub_contract} | User get the payload from admin publisher datafiles | create-Admin-Publisher-Contract.json
| | ${admin_pub_contract_req_body} | Set Variable | ${Admin_pub_contract}[0]
| | ${admin_pub_contract_resp_body} | Set Variable | ${Admin_pub_contract}[1]
| | ${admin_pub_contract_id} | Set Variable | ${admin_pub_contract_resp_body}[id]
| | Set Global Variable | ${admin_pub_contract_req_body}
| | Set Global Variable | ${admin_pub_contract_id}
| | Set To Dictionary | ${admin_pub_contract_req_body} | is_save_and_confirm | ${TRUE}
| | ${admin_pub_contract_req_body_approve} | Set Variable | ${admin_pub_contract_req_body}
| | Set Global Variable | ${admin_pub_contract_req_body_approve}

| User set the Variables for admin publisher content
| | [Documentation] | User expected to test set the variables for the admin Publisher
| | ${Admin_pub_content} | User get the payload from admin publisher datafiles | create-Admin-Publisher-content.json
| | ${admin_pub_content_req_body} | Set Variable | ${Admin_pub_content}[0]
| | ${admin_pub_content_resp_body} | Set Variable | ${Admin_pub_content}[1]
| | ${admin_pub_content_id} | Set Variable | ${admin_pub_content_resp_body}[id]
| | Set Global Variable | ${admin_pub_content_req_body}
| | Set Global Variable | ${admin_pub_content_id}

| User set the Variables for admin publisher Sandbox Key link
| | [Documentation] | User expected to test set the variables for the admin Publisher
| | ${Admin_pub_sandbox} | User get the payload from admin publisher datafiles | Generates-Sandbox-Key-admin-publisher.json
| | ${admin_pub_sandbox_req_body} | Set Variable | ${Admin_pub_sandbox}[0]
| | ${admin_pub_sandbox_resp_body} | Set Variable | ${Admin_pub_sandbox}[1]
| | ${admin_pub_sandbox_api_key} | Set Variable | ${admin_pub_sandbox_resp_body}[api_key]
| | Set Global Variable | ${admin_pub_sandbox_req_body}
| | Set Global Variable | ${admin_pub_sandbox_api_key}
| | ${admin_pub_sandbox_site_url} | Set Variable | ${admin_pub_sandbox_resp_body}[site_url]
| | Set Global Variable | ${admin_pub_sandbox_site_url}
| | ${admin_pub_sandbox_activation_date} | Set Variable | ${admin_pub_sandbox_resp_body}[activation_date]
| | Set Global Variable | ${admin_pub_sandbox_activation_date}

| User set the Variables for admin publisher Livesite Key link
| | [Documentation] | User expected to test set the variables for the admin Publisher
| | ${Admin_pub_livesite} | User get the payload from admin publisher datafiles | Generates-Livesite-Key-admin-publisher.json
| | ${admin_pub_livesite_req_body} | Set Variable | ${Admin_pub_livesite}[0]
| | ${admin_pub_livesite_resp_body} | Set Variable | ${Admin_pub_livesite}[1]
| | ${admin_pub_livesite_api_key} | Set Variable | ${admin_pub_livesite_resp_body}[api_key]
| | Set Global Variable | ${admin_pub_livesite_req_body}
| | Set Global Variable | ${admin_pub_livesite_api_key}
| | ${admin_pub_livesite_site_url} | Set Variable | ${admin_pub_livesite_resp_body}[site_url]
| | Set Global Variable | ${admin_pub_livesite_site_url}
| | ${admin_pub_livesite_activation_date} | Set Variable | ${admin_pub_livesite_resp_body}[activation_date]
| | Set Global Variable | ${admin_pub_livesite_activation_date}

| User set the Variables for admin publisher SSO setup
| | [Documentation] | User expected to test set the variables for the admin Publisher
| | ${Admin_pub_sso} | User get the payload from admin publisher datafiles | create-admin-publisher-sso.json
| | ${admin_pub_sso_req_body} | Set Variable | ${Admin_pub_sso}[0]
| | ${admin_pub_sso_resp_body} | Set Variable | ${Admin_pub_sso}[1]
| | ${admin_pub_sso_id} | Set Variable | ${admin_pub_sso_resp_body}[id]
| | Set Global Variable | ${admin_pub_sso_req_body}
| | Set Global Variable | ${admin_pub_sso_id}

| User set the Variables for Admin Reports campaigns and Publisher Models
| | [Documentation] | User expected to test set the variables for the admin Reports
| | [Arguments] | ${output_file_name} | ${keyname}
| | ${Admin_Report_output} | User get the payload from admin report datafiles | ${output_file_name}
| | ${Admin_Report_resp_body} | Set Variable | ${Admin_Report_output}[1]
| | ${output_resp} | Set Variable | ${Admin_Report_resp_body}[${keyname}]
| | Set Test Variable | ${output_resp}

| GET all admin publisher users
| | [Documentation] | User Expected to get all the brands
| | [Arguments] | ${uri} | ${Expected_status_code} | ${content}
| | ${Uri} | generate_api_url | create_user_account | id=${advertiser_id}
| | User Initiate GET call and verify Status Response | ${uri} | ${admpub_datafile}Get-all-admin-publisher-user.json | ${Expected_status_code}
| | ${resp_data} | Output | response body
| | Log | ${data_variable}
# | | Should Be Equal | ${resp_data}[${content}] | ${data_variable}[${content}]

| GET all admin publisher users for Nested data
| | [Documentation] | User Expected to get all the brands
| | [Arguments] | ${uri} | ${Expected_status_code} | ${list_name} | ${key_name} | ${content} | ${file_name}
| | User Initiate GET call and verify Status Response | ${uri} | ${admpub_datafile}${file_name} | ${Expected_status_code}
| | ${resp_data} | Output | response body
| | Log | ${resp_data}[${list_name}][0][${key_name}]
# | | Should Be Equal | ${resp_data}[${list_name}][0][${key_name}] | ${content}

| GET all admin publisher users for twice Nested data
| | [Documentation] | User Expected to get all the brands
| | [Arguments] | ${uri} | ${Expected_status_code} | ${key_name} | ${content}
| | User Initiate GET call and verify Status Response | ${uri} | ${admpub_datafile}Get-all-admin-publisher-user-nested-data.json | ${Expected_status_code}
| | ${resp_data} | Output | response body
| | Log | ${resp_data}
| | Log | ${resp_data}[0][${key_name}]
# | | Should Be Equal | ${resp_data}[0][${key_name}] | ${content}

| User creates the admin advertiser
| | [Documentation] | User Expected to Register for admin Advertiser
| | [Arguments] | ${uri} | ${Expected_status_code} | ${file_name}
| | User Initiate Post call and verify Status Response | ${uri} | ${admad_datafile}${file_name} | ${Expected_status_code} | ${body}
| | ${resp_data} | Output | response body

| GET all admin advertiser users for Nested data
| | [Documentation] | User Expected to get all the brands
| | [Arguments] | ${uri} | ${Expected_status_code} | ${file_name}
| | User Initiate GET call and verify Status Response | ${uri} | ${admad_datafile}${file_name} | ${Expected_status_code}
| | ${resp_data} | Output | response body

| User creates the contract for Admin Advertiser
| | [Documentation] | User Expected to get all the brands
| | [Arguments] | ${Expected_status_code} | ${file_name}
| | ${uri} | generate_api_url | contract_url | id=${advertiser_id}
| | User Initiate Post call and verify Status Response | ${uri} | ${admad_datafile}${file_name} | ${Expected_status_code} | ${body}
| | ${req_data} | Output | request body
| | ${resp_data} | Output | response body

| User Confirm & Save the contract for admin Publisher
| | [Documentation] | User Expected to get all the brands
| | [Arguments] | ${Expected_status_code} | ${file_name}
| | ${uri} | generate_api_url | get_admin_publisher_contract | pub_id=${adm_pub_publisher_id} | contract_Id=${admin_pub_contract_id}
| | User Initiate PUT call and verify Status Response | ${uri} | ${admpub_datafile}${file_name} | ${Expected_status_code} | ${admin_pub_contract_req_body_approve}
| | ${resp_data} | Output | response body

| User approves the contract for admin advertiser
| | [Documentation] | User Expected to get all the brands
| | [Arguments] | ${Expected_status_code} | ${file_name}
| | ${uri} | generate_api_url | contract | id=${advertiser_id} | contractId=${admin_contract_id}
| | User Initiate PUT call and verify Status Response | ${uri} | ${admad_datafile}${file_name} | ${Expected_status_code} | ${Advertiser_contract_req_body_approve}
| | ${resp_data} | Output | response body

| User confirm & save the contract for admin advertiser
| | [Documentation] | User Expected to get all the brands
| | [Arguments] | ${Expected_status_code} | ${file_name}
| | ${uri} | generate_api_url | contract | id=${advertiser_id} | contractId=${admin_contract_id}
| | User Initiate PUT call and verify Status Response | ${uri} | ${admad_datafile}${file_name} | ${Expected_status_code} | ${body}
| | ${resp_data} | Output | response body

| User publish the campaign for Admin Advertiser
| | [Documentation] | User expected to Update the Existing data by Userid as Admin
| | [Arguments] | ${Expected_status_code} | ${content} | ${file_name}
| | ${uri} | generate_api_url | contract_publish | id=${advertiser_id} | campaign_id=${admin_advertiser_campagin_id}
| | User Initiate Put call and verify Status Response | ${uri} | ${admad_datafile}${file_name} | ${Expected_status_code}
| | ${resp_data} | Output | response body
# | | Should Be Equal | ${resp_data}[${content}] | ${data_variable}[${content}]

# this module combines all the admin advertiser GET request
| GET Call Admin Advertiser Get The Information
| | [Documentation] | User gets all the admin advertiser details
| | [Arguments] | ${Expected_status_code} | ${file_name} | ${action_for}
| | ${uri} | generate_api_url | ${action_for} | id=${advertiser_id} | campaign_id=${admin_advertiser_campagin_id} | product_id=${admin_advertiser_product_id} |
| | ... | product_campain_res_id=${add_product_admin_advertiser_campagin_resp_body_id} | product_ads_id=${admin_advertiser_product_offer_ads_id} | product_ad_id=${admin_advertiser_product_offer_ads_id} |
| | ... | offerasset_id=${admin_advertiser_contract_product_offerasset_id_logo} | contractId=${admin_contract_id} | account_id=${account_id}
| | User Initiate GET call and verify Status Response | ${uri} | ${admad_datafile}${file_name} | ${Expected_status_code}
| | ${resp_data} | Output | response body
# | | Should Be Equal | ${resp_data}[${content}] | ${data_variable}[${content}]

# This module combines all the admin advertiser PUT request
| Put Call Admin Advertiser And Update The Information
| | [Documentation] | User update all the advertiser details
| | [Arguments] | ${Expected_status_code} | ${file_name} | ${action_for}
| | ${uri} | generate_api_url | ${action_for} | id=${advertiser_id} | campaign_id=${admin_advertiser_campagin_id} | product_id=${admin_advertiser_product_id} |
| | ... | product_campain_res_id=${add_product_admin_advertiser_campagin_resp_body_id} | product_ads_id=${admin_advertiser_product_offer_ads_id} | product_ad_id=${admin_advertiser_product_offer_ads_id} |
| | ... | offerasset_id=${admin_advertiser_contract_product_offerasset_id_logo} | contractId=${admin_contract_id} | account_id=${account_id}
| | User Initiate Put call and verify Status Response | ${uri} | ${admad_datafile}${file_name} | ${Expected_status_code} | ${body}
| | ${resp_data} | Output | response body

# This module combines all the admin advertiser Post request
| Post Call Admin Advertiser Add The Information
| | [Documentation] | User creates all the advertiser Information
| | [Arguments] | ${Expected_status_code} | ${file_name} | ${action_for}
| | ${uri} | generate_api_url | ${action_for} | id=${advertiser_id} | campaign_id=${admin_advertiser_campagin_id} | product_id=${admin_advertiser_product_id} |
| | ... | product_campain_res_id=${add_product_admin_advertiser_campagin_resp_body_id} | product_ads_id=${admin_advertiser_product_offer_ads_id} | product_ad_id=${admin_advertiser_product_offer_ads_id} |
| | ... | offerasset_id=${admin_advertiser_contract_product_offerasset_id_logo} | contractId=${admin_contract_id} | account_id=${account_id}
| | User Initiate Post call and verify Status Response | ${uri} | ${admad_datafile}${file_name} | ${Expected_status_code} | ${body}
| | ${resp_data} | Output | response body

# This module combines all the admin advertiser Delete request
| Delete Call Admin Advertiser Delete The Information
| | [Documentation] | User deletes all the advertiser information
| | [Arguments] | ${Expected_status_code} | ${content} | ${file_name} | ${action_for}
| | ${uri} | generate_api_url | ${action_for} | id=${advertiser_id} | campaign_id=${admin_advertiser_campagin_id} | product_id=${admin_advertiser_product_id} |
| | ... | product_campain_res_id=${add_product_admin_advertiser_campagin_resp_body_id} | product_ads_id=${admin_advertiser_product_offer_ads_id} | product_ad_id=${admin_advertiser_product_offer_ads_id} |
| | ... | offerasset_id=${admin_advertiser_contract_product_offerasset_id_logo} | contractId=${admin_contract_id} | account_id=${account_id}
| | User Initiate DELETE call and verify Status Response | ${uri} | ${admad_datafile}${file_name} | ${Expected_status_code}
| | ${resp_data} | Output | response body
# | | Should Be Equal | ${resp_data}[${content}] | ${data_variable}[${content}]

# This module combines all the admin publisher get request
| Get Call Admin Publisher Get The Information
| | [Documentation] | User get all the publisher information
| | [Arguments] | ${Expected_status_code} | ${file_name} | ${action_for}
| | ${uri} | generate_api_url | ${action_for} | id=${adm_pub_publisher_id} | user_id=${account_id} | contract_Id=${admin_pub_contract_id} |
| | ... | pub_id=${adm_pub_publisher_id} | content_id=${admin_pub_content_id} | sso_id=${admin_pub_sso_id} |
| | User Initiate GET call and verify Status Response | ${uri} | ${admpub_datafile}${file_name} | ${Expected_status_code}
| | ${resp_data} | Output | response body

# This module combines all the admin publisher post request
| Post Call Admin Publisher Add The Information
| | [Documentation] | User creates the publisher information
| | [Arguments] | ${Expected_status_code} | ${file_name} | ${action_for}
| | ${uri} | generate_api_url | ${action_for} | id=${adm_pub_publisher_id} | user_id=${account_id} | contract_Id=${admin_pub_contract_id} |
| | ... | pub_id=${adm_pub_publisher_id} | content_id=${admin_pub_content_id} | sso_id=${admin_pub_sso_id} |
| | User Initiate Post call and verify Status Response | ${uri} | ${admpub_datafile}${file_name} | ${Expected_status_code} | ${body}
| | ${resp_data} | Output | response body

# This module combines all the admin publisher put request
| Put Call Admin Publisher Update The Information
| | [Documentation] | User Updates the publisher information
| | [Arguments] | ${Expected_status_code} | ${file_name} | ${action_for}
| | ${uri} | generate_api_url | ${action_for} | id=${adm_pub_publisher_id} | user_id=${account_id} | contract_Id=${admin_pub_contract_id} |
| | ... | pub_id=${adm_pub_publisher_id} | content_id=${admin_pub_content_id} | sso_id=${admin_pub_sso_id} |
| | User Initiate Put call and verify Status Response | ${uri} | ${admpub_datafile}${file_name} | ${Expected_status_code} | ${body}
| | ${resp_data} | Output | response body

# This module combines all the admin publisher delete request
| Delete Call Admin Publisher Delete The Information
| | [Documentation] | User Deletes the publisher information
| | [Arguments] | ${Expected_status_code} | ${file_name} | ${action_for}
| | ${uri} | generate_api_url | ${action_for} | id=${adm_pub_publisher_id} | user_id=${account_id} | contract_Id=${admin_pub_contract_id} |
| | ... | pub_id=${adm_pub_publisher_id} | content_id=${admin_pub_content_id} | sso_id=${admin_pub_sso_id} |
| | User Initiate DELETE call and verify Status Response | ${uri} | ${admpub_datafile}${file_name} | ${Expected_status_code}
| | ${resp_data} | Output | response body

| User Fetch the Report Data for campaigns products offers and Publisher Models
| | [Documentation] | User expected to Update the Existing data by Userid as Admin
| | [Arguments] | ${uri} | ${Expected_status_code} | ${file_name}
| | User Initiate Post call and verify Status Response | ${uri} | ${adm_report_datafile}${file_name} | ${Expected_status_code} | ${body}
| | ${resp_data} | Output | response body