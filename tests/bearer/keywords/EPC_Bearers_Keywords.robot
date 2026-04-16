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
