*** Settings ***
Documentation     Traffic scenario for a single bearer with clear AAA structure
Resource          ../../resources/EPC_API.robot
Resource          ../../resources/EPC_Assertions.robot
Resource          ../../resources/EPC_Common.robot
Resource          ../../resources/EPC_Traffic.robot

*** Test Cases ***
01 UE Starts And Stops Traffic On The Default Bearer
    [Documentation]    Verifies a business scenario: the UE is attached, starts traffic, and then stops it.
    [Tags]    traffic    single-bearer    positive
    # Arrange
    Prepare Clean EPC Environment

    # Act
    Attach The Default UE
    Start Traffic On The Default Bearer

    # Assert
    Verify Traffic On The Default Bearer
    Stop Traffic On The Default Bearer

*** Keywords ***
Start Traffic On The Default Bearer
    Start Traffic On Bearer    ${UE_VALID}    9    tcp    50

Verify Traffic On The Default Bearer
    ${resp}=    Check Traffic    ${UE_VALID}    9
    Response Status Should Be    ${resp}    200
    Response JSON Field Should Be    ${resp}    ue_id    ${UE_VALID}
    Response JSON Field Should Be    ${resp}    bearer_id    9
    Response JSON Field Should Be    ${resp}    protocol    tcp
    Response Should Contain Key    ${resp}    tx_bps
    Response Should Contain Key    ${resp}    rx_bps
    Response Should Contain Key    ${resp}    duration

Stop Traffic On The Default Bearer
    Stop Traffic On Bearer    ${UE_VALID}    9
