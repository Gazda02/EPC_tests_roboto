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

