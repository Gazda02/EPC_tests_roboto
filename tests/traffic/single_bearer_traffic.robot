*** Settings ***
Documentation     Traffic scenario for a single bearer with clear AAA structure
Resource          ../../resources/EPC_API.robot
Resource          ../../resources/EPC_Assertions.robot
Resource          ../../resources/EPC_Common.robot

*** Test Cases ***
01 UE Starts And Stops Traffic On The Default Bearer
    [Documentation]    Verifies a business scenario: the UE is attached, starts traffic, and then stops it.
    # Arrange
    Prepare Clean EPC Environment

    # Act
    Attach The Default UE
    Start Traffic On The Default Bearer

    # Assert
    Verify Traffic On The Default Bearer
    Stop Traffic On The Default Bearer

*** Keywords ***

Attach UE To Network
    [Arguments]    ${ue_id}
    ${resp}=    Attach UE    ${ue_id}
    Response Status Should Be    ${resp}    200
    Response Should Contain Key    ${resp}    status
    Response JSON Field Should Be    ${resp}    ue_id    ${ue_id}

Attach The Default UE
    Attach UE To Network    10

Start Traffic On Bearer
    [Arguments]    ${ue_id}    ${bearer_id}    ${protocol}    ${mbps}
    ${resp}=    Start Traffic    ${ue_id}    ${bearer_id}    ${protocol}    ${mbps}
    Response Status Should Be    ${resp}    200
    Response Should Contain Key    ${resp}    status
    Response JSON Field Should Be    ${resp}    ue_id    ${ue_id}
    Response JSON Field Should Be    ${resp}    bearer_id    ${bearer_id}
    Response Should Contain Key    ${resp}    target_bps

Start Traffic On The Default Bearer
    Start Traffic On Bearer    10    9    tcp    50

Verify Traffic On The Default Bearer
    ${resp}=    Check Traffic    10    9
    Response Status Should Be    ${resp}    200
    Response JSON Field Should Be    ${resp}    ue_id    10
    Response JSON Field Should Be    ${resp}    bearer_id    9
    Response JSON Field Should Be    ${resp}    protocol    tcp
    Response Should Contain Key    ${resp}    tx_bps
    Response Should Contain Key    ${resp}    rx_bps
    Response Should Contain Key    ${resp}    duration

Stop Traffic On The Default Bearer
    ${resp}=    Stop Traffic    10    9
    Response Status Should Be    ${resp}    200
    Response Should Contain Key    ${resp}    status
    Response JSON Field Should Be    ${resp}    ue_id    10
    Response JSON Field Should Be    ${resp}    bearer_id    9
