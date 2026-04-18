*** Settings ***
Resource          ../../../resources/EPC_API.robot
Resource          ../../../resources/EPC_Assertions.robot

*** Keywords ***

# --- Setups ---

Attach UE With ID ${ue_id}
    Attach UE    ${ue_id}

Attach UE With ID ${ue_id} And Add Bearer With ID ${bearer_id}
    Attach UE    ${ue_id}
    Add Bearer    ${ue_id}    ${bearer_id}

# --- Add bearer ---

Response From Add Bearer ${bearer_id} To UE ${ue_id} Should Be OK
    ${resp}=    Add Bearer    ${ue_id}    ${bearer_id}
    Should Be Equal As Integers    ${resp.status_code}    200

Response From Add Bearer ${bearer_id} To UE ${ue_id} Should Contain Key ${key} With Value ${value}
    ${add_resp}=       Add Bearer    ${ue_id}   ${bearer_id}
    Response JSON Field Should Be  ${add_resp}     ${key}     ${value}

Add Bearer With ID ${bearer_id} To UE With ID ${ue_id} Response With Greater Than Equal Error Type
    ${resp}=    Add Bearer    ${ue_id}    ${bearer_id}
    ${json}=    Set Variable    ${resp.json()}
    ${actual_type}=    Set Variable    ${json["detail"][0]["type"]}
    Should Be Equal As Strings    ${actual_type}    greater_than_equal

Add Bearer With ID ${bearer_id} To UE With ID ${ue_id} Response With Less Than Equal Error Type
    ${resp}=    Add Bearer    ${ue_id}    ${bearer_id}
    ${json}=    Set Variable    ${resp.json()}
    ${actual_type}=    Set Variable    ${json["detail"][0]["type"]}
    Should Be Equal As Strings    ${actual_type}    less_than_equal

# --- Remove bearer ---

Response From Delete Bearer ${bearer_id} From UE ${ue_id} Should Be OK
    ${resp}=    Delete Bearer    ${ue_id}    ${bearer_id}
    Should Be Equal As Integers    ${resp.status_code}    200

Response From Delete Bearer ${bearer_id} From UE ${ue_id} Should Contain Key ${key} With Value ${value}
    ${add_resp}=       Delete Bearer    ${ue_id}   ${bearer_id}
    Response JSON Field Should Be  ${add_resp}     ${key}     ${value}


# --- UE have bearer ---

UE ${ue_id} Should Have Bearer ${bearer_id}
    ${resp}=    Get UE    ${ue_id}
    Should Be Equal As Integers    ${resp.status_code}    200

    ${json_body}=    Set Variable    ${resp.json()}
    Dictionary Should Contain Key    ${json_body}    bearers

    ${bearers}=    Get From Dictionary    ${json_body}    bearers
    ${bearer_id_str}=    Convert To String    ${bearer_id}
    Dictionary Should Contain Key    ${bearers}    ${bearer_id_str}

UE With ID ${ue_id} Do Not Have Bearer With ID ${bearer_id}
    ${resp}=    Get UE    ${ue_id}

    ${json_body}=    Set Variable    ${resp.json()}
    Dictionary Should Contain Key    ${json_body}    bearers

    ${bearers}=    Get From Dictionary    ${json_body}    bearers
    ${bearer_id_str}=    Convert To String    ${bearer_id}
    Dictionary Should Not Contain Key    ${bearers}    ${bearer_id_str}
