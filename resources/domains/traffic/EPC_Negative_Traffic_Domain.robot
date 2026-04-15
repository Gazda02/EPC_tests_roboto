*** Settings ***
Resource          ../../EPC_API.robot
Resource          ../../EPC_Assertions.robot

*** Keywords ***
Traffic Check With Invalid UE ID Should Be Rejected
    ${traffic_resp}=    Check Traffic    ${UE_INVALID}    ${BEARER_VALID}
    Response Status Should Be    ${traffic_resp}    404

Valid UE Is Prepared For Invalid Bearer Check
    ${ue_resp}=    Attach UE    ${UE_VALID}
    Response Status Should Be    ${ue_resp}    201

Traffic Check With Invalid Bearer ID Should Be Rejected
    ${traffic_resp}=    Check Traffic    ${UE_VALID}    ${BEARER_INVALID}
    Response Status Should Be    ${traffic_resp}    404

Negative Traffic Scenario Starts From Clean EPC State
    Reset EPC



