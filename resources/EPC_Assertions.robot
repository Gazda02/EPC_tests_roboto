*** Settings ***
Library          Collections

*** Keywords ***
Response Status Should Be
    [Arguments]    ${resp}    ${expected}
    Should Be Equal As Integers    ${resp.status_code}    ${expected}

Response Should Contain Key
    [Arguments]    ${resp}    ${key}
    Dictionary Should Contain Key   ${resp.json()}    ${key}

Response Should Contain Message
    [Arguments]    ${resp}    ${expected}
    Should Contain    ${resp.text}    ${expected}

Response JSON Field Should Be
    [Arguments]    ${resp}    ${key}    ${expected}
    ${payload}=    Set Variable    ${resp.json()}
    ${actual}=    Get From Dictionary    ${payload}    ${key}
    Should Be Equal As Strings    ${actual}    ${expected}

