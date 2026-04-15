*** Settings ***
Documentation     Basic connectivity test for EPC simulator
Resource          ../../resources/EPC_API.robot
Resource          ../../resources/EPC_Assertions.robot

*** Test Cases ***
EPC Root Should Respond
    ${resp}=    GET    /
    Response Status Should Be    ${resp}    200
