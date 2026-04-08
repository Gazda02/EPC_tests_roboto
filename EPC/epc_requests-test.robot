*** Settings ***
Documentation    Documentation incoming...
Library          EpcRequests.py

*** Variables ***
# Suite-wide values keep data out of the steps and easy to change.
${CORRECT_RESPONSE}         200

*** Test Cases ***
EPC Root Connections
    [Documentation]    Check if the EPC is avaliable
    [Tags]    connection    avaliable
    ${response}=    Test Epc Connection
    Verify Response Is  ${response}

*** Keywords ***
Verify Response Is
    [Documentation]    Check if the reasponse code is 200 (correct)
    [Arguments]    ${sended_response}
    should be equal as integers    ${sended_response}   ${CORRECT_RESPONSE}