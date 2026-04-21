*** Settings ***
Resource          EPC_API.robot
Resource          EPC_Assertions.robot

*** Keywords ***
Reset EPC Should Succeed
    ${resp}=    Reset EPC
    Response Status Should Be    ${resp}    200

Prepare Clean EPC Environment
    [Documentation]    Backward-compatible alias for suite setup readability.
    Reset EPC Should Succeed

Attach UE To Network
    [Arguments]    ${ue_id}
    ${resp}=    Attach UE    ${ue_id}
    Response Status Should Be    ${resp}    200
    Response Should Contain Key    ${resp}    status
    Response JSON Field Should Be    ${resp}    ue_id    ${ue_id}

Attach The Default UE
    Attach UE To Network    ${UE_VALID}