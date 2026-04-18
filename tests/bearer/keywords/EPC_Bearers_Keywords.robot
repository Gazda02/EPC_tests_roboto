*** Settings ***
Resource          ../../../resources/EPC_API.robot
Resource          ../../../resources/EPC_Assertions.robot

*** Keywords ***

# --- Setups ---

Attach UE With ID ${ue_id}
    Attach UE    ${ue_id}

# --- Add bearer ---

Add Bearer With ID ${bearer_id} To UE With ID ${ue_id}
    ${resp}=    Add Bearer    ${ue_id}    ${bearer_id}

Add Bearer With ID ${bearer_id} To UE With ID ${ue_id} Response With OK
    ${resp}=    Add Bearer    ${ue_id}    ${bearer_id}
    Should Be Equal As Integers    ${resp.status_code}    200

Add Bearer With ID ${bearer_id} To UE With ID ${ue_id} Response With Unprocessable Entity
    ${resp}=    Add Bearer    ${ue_id}    ${bearer_id}
    Should Be Equal As Integers    ${resp.status_code}    422

Add Bearer With ID ${bearer_id} To UE With ID ${ue_id} Response With Correct Values
    ${add_resp}=       Add Bearer    ${ue_id}   ${bearer_id}
    Response JSON Field Should Be  ${add_resp}     ue_id     ${ue_id}
    Response JSON Field Should Be  ${add_resp}     bearer_id     ${bearer_id}
    Response JSON Field Should Be  ${add_resp}     status     bearer_added

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

Delete Bearer With ID ${bearer_id} From UE With ID ${ue_id} Response With OK
    ${resp}=    Delete Bearer    ${ue_id}    ${bearer_id}
    Should Be Equal As Integers    ${resp.status_code}    200

Delete Bearer With ID ${bearer_id} From UE With ID ${ue_id} Response With Correct Values
    ${add_resp}=       Delete Bearer    ${ue_id}   ${bearer_id}
    Response JSON Field Should Be  ${add_resp}     ue_id     ${ue_id}
    Response JSON Field Should Be  ${add_resp}     bearer_id     ${bearer_id}
    Response JSON Field Should Be  ${add_resp}     status     bearer_deleted


# --- UE (do not) have bearer ---

UE With ID ${ue_id} Have Bearer With ID ${bearer_id}
    ${resp}=    Get UE    ${ue_id}

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
