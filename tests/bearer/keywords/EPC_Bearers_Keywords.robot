*** Settings ***
Resource          ../../../resources/EPC_API.robot
Resource          ../../../resources/EPC_Assertions.robot

*** Keywords ***

# ============================================================
#   UE SETUP
# ============================================================

Attach UE With ID
    [Arguments]    ${ue_id}
    [Documentation]    Attaches UE to the network. Returns response for optional validation.
    ${resp}=    Attach UE    ${ue_id}
    RETURN    ${resp}


# ============================================================
#   ADD BEARER (DOMAIN KEYWORDS)
# ============================================================

Add Bearer To UE
    [Arguments]    ${ue_id}    ${bearer_id}
    [Documentation]    Sends request to add bearer. No assertions here.
    ${resp}=    Add Bearer    ${ue_id}    ${bearer_id}
    RETURN    ${resp}


# ============================================================
#   REMOVE BEARER (DOMAIN KEYWORDS)
# ============================================================

Remove Bearer From UE
    [Arguments]    ${ue_id}    ${bearer_id}
    [Documentation]    Sends request to delete bearer. No assertions here.
    ${resp}=    Delete Bearer    ${ue_id}    ${bearer_id}
    RETURN    ${resp}


# ============================================================
#   UE BEARER STATE ASSERTIONS
# ============================================================

UE With ID Should Have Bearer
    [Arguments]    ${ue_id}    ${bearer_id}
    [Documentation]    Verifies that UE has given bearer.
    ${resp}=    Get UE    ${ue_id}
    ${json}=    Set Variable    ${resp.json()}

    Dictionary Should Contain Key    ${json}    bearers
    ${bearers}=    Get From Dictionary    ${json}    bearers

    ${bearer_id_str}=    Convert To String    ${bearer_id}
    Dictionary Should Contain Key    ${bearers}    ${bearer_id_str}


UE With ID Should Not Have Bearer
    [Arguments]    ${ue_id}    ${bearer_id}
    [Documentation]    Verifies that UE does NOT have given bearer.
    ${resp}=    Get UE    ${ue_id}
    ${json}=    Set Variable    ${resp.json()}

    Dictionary Should Contain Key    ${json}    bearers
    ${bearers}=    Get From Dictionary    ${json}    bearers

    ${bearer_id_str}=    Convert To String    ${bearer_id}
    Dictionary Should Not Contain Key    ${bearers}    ${bearer_id_str}


# ============================================================
#   ASSERTION HELPERS FOR ADD/REMOVE
# ============================================================

Add Bearer Should Respond With Status
    [Arguments]    ${expected_status}    ${ue_id}    ${bearer_id}
    [Documentation]    Adds bearer and checks only HTTP status.
    ${resp}=    Add Bearer    ${ue_id}    ${bearer_id}
    Response Status Should Be    ${resp}    ${expected_status}


Add Bearer Should Respond With Error Type
    [Arguments]    ${expected_error_type}    ${ue_id}    ${bearer_id}
    [Documentation]    Adds bearer and checks validation error type.
    ${resp}=    Add Bearer    ${ue_id}    ${bearer_id}
    ${json}=    Set Variable    ${resp.json()}
    ${actual_type}=    Set Variable    ${json["detail"][0]["type"]}
    Should Be Equal As Strings    ${actual_type}    ${expected_error_type}


Delete Bearer Should Respond With Status
    [Arguments]    ${expected_status}    ${ue_id}    ${bearer_id}
    [Documentation]    Deletes bearer and checks only HTTP status.
    ${resp}=    Delete Bearer    ${ue_id}    ${bearer_id}
    Response Status Should Be    ${resp}    ${expected_status}
