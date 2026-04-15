*** Settings ***
Library    EpcRequests.py
Resource   EPC_Variables.robot

*** Keywords ***
GET
    [Arguments]    ${endpoint}
    ${resp}=    Request    GET    ${BASE_URL}${endpoint}    ${None}
    RETURN    ${resp}

POST
    [Arguments]    ${endpoint}    ${body}
    ${resp}=    Request    POST    ${BASE_URL}${endpoint}    ${body}
    RETURN    ${resp}

DELETE
    [Arguments]    ${endpoint}
    ${resp}=    Request    DELETE    ${BASE_URL}${endpoint}    ${None}
    RETURN    ${resp}

# --- EPC SPECIFIC KEYWORDS ---

Attach UE
    [Arguments]    ${ue_id}
    ${body}=    Create Dictionary    ue_id=${ue_id}
    ${resp}=    POST    /ues    ${body}
    RETURN    ${resp}

Detach UE
    [Arguments]    ${ue_id}
    ${resp}=    DELETE    /ues/${ue_id}
    RETURN    ${resp}

Add Bearer
    [Arguments]    ${ue_id}    ${bearer_id}
    ${body}=    Create Dictionary    bearer_id=${bearer_id}
    ${resp}=    POST    /ues/${ue_id}/bearers    ${body}
    RETURN    ${resp}

Delete Bearer
    [Arguments]    ${ue_id}    ${bearer_id}
    ${resp}=    DELETE    /ues/${ue_id}/bearers/${bearer_id}
    RETURN    ${resp}

Start Traffic
    [Arguments]    ${ue_id}    ${bearer_id}    ${speed}
    ${body}=    Create Dictionary    speed=${speed}
    ${resp}=    POST    /ues/${ue_id}/bearers/${bearer_id}/traffic    ${body}
    RETURN    ${resp}

Stop Traffic
    [Arguments]    ${ue_id}    ${bearer_id}
    ${resp}=    DELETE    /ues/${ue_id}/bearers/${bearer_id}/traffic
    RETURN    ${resp}

Check Traffic
    [Arguments]    ${ue_id}    ${bearer_id}
    ${resp}=    GET    /ues/${ue_id}/bearers/${bearer_id}/traffic
    RETURN    ${resp}

Reset EPC
    ${resp}=    POST    /reset    ${None}
    RETURN    ${resp}