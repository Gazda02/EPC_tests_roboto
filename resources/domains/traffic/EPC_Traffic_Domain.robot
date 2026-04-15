*** Settings ***
Resource          ../../EPC_API.robot
Resource          ../../EPC_Assertions.robot

*** Keywords ***
Single Bearer Session Is Prepared
    ${ue_resp}=    Attach UE    ${UE_VALID}
    Response Status Should Be    ${ue_resp}    201
    ${bearer_resp}=    Add Bearer    ${UE_VALID}    ${BEARER_VALID}
    Response Status Should Be    ${bearer_resp}    201

Traffic Is Started For Single Bearer
    ${start_resp}=    Start Traffic    ${UE_VALID}    ${BEARER_VALID}    ${TRAFFIC_VALID}
    Response Status Should Be    ${start_resp}    201

Traffic Is Visible For Single Bearer
    ${traffic_resp}=    Check Traffic    ${UE_VALID}    ${BEARER_VALID}
    Response Status Should Be    ${traffic_resp}    200
    Response Should Contain Message    ${traffic_resp}    ${TRAFFIC_VALID}

Traffic Is Stopped For Single Bearer
    ${stop_resp}=    Stop Traffic    ${UE_VALID}    ${BEARER_VALID}
    Response Status Should Be    ${stop_resp}    200

Single Bearer Session Is Cleaned Up
    ${delete_resp}=    Delete Bearer    ${UE_VALID}    ${BEARER_VALID}
    Response Status Should Be    ${delete_resp}    200
    ${detach_resp}=    Detach UE    ${UE_VALID}
    Response Status Should Be    ${detach_resp}    200

Scenario Starts From Clean EPC State
    Reset EPC



