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


# --- Remove bearer ---

Delete Bearer With ID ${bearer_id} From UE With ID ${ue_id} Response With Bad Request
    Delete Bearer Should Response With    400   ${ue_id}    ${bearer_id}


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


# --- Utils ---

Add Bearer Should Response With
    [Arguments]    ${expected_status}   ${ue_id}    ${bearer_id}
    ${resp}=    Add Bearer    ${ue_id}    ${bearer_id}
    Should Be Equal As Integers    ${resp.status_code}    ${expected_status}

Add Bearer Shuld Response With Error Type
    [Arguments]    ${expected_error_type}   ${ue_id}    ${bearer_id}
    ${resp}=    Add Bearer    ${ue_id}    ${bearer_id}
    ${json}=    Set Variable    ${resp.json()}
    ${actual_type}=    Set Variable    ${json["detail"][0]["type"]}
    Should Be Equal As Strings    ${actual_type}    ${expected_error_type}

Delete Bearer Should Response With
    [Arguments]    ${expected_status}   ${ue_id}    ${bearer_id}
    ${resp}=    Delete Bearer    ${ue_id}    ${bearer_id}
    Should Be Equal As Integers    ${resp.status_code}    ${expected_status}
