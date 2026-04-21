*** Settings ***
Documentation     Start traffic validation tests for EPC simulator
Resource          ../../resources/EPC_API.robot
Resource          ../../resources/EPC_Assertions.robot
Resource          ../../resources/EPC_Common.robot
Resource          ../../resources/EPC_Traffic.robot

*** Test Cases ***
01 Start Traffic With Valid Parameters
    [Documentation]    Verifies that traffic can be started with valid UE, bearer, protocol, and speed.
    [Tags]    traffic    start-traffic    positive
    # Arrange
    Prepare Clean EPC Environment
    Attach The Default UE

    # Act
    Start Traffic With Valid Parameters

    # Assert
    Verify Start Traffic Succeeds

    # Cleanup
    Stop Traffic On Default Bearer

02 Start Traffic With Speed Out Of Range
    [Documentation]    Verifies that traffic start fails when the speed is out of the allowed range.
    [Tags]    traffic    start-traffic    negative    invalid-speed
    # Arrange
    Prepare Clean EPC Environment
    Attach The Default UE

    # Act
    Start Traffic With Invalid Speed

    # Assert
    Verify Start Traffic Fails For Invalid Speed

03 Start Traffic With Inactive Bearer
    [Documentation]    Verifies that traffic start fails when the bearer is not active for the UE.
    [Tags]    traffic    start-traffic    negative    inactive-bearer
    # Arrange
    Prepare Clean EPC Environment
    Attach The Default UE

    # Act
    Start Traffic On Inactive Bearer

    # Assert
    Verify Start Traffic Fails For Inactive Bearer

04 Start Traffic With Invalid UE ID
    [Documentation]    Verifies that traffic start fails when the UE ID is invalid or not connected.
    [Tags]    traffic    start-traffic    negative    invalid-ue
    # Arrange
    Prepare Clean EPC Environment

    # Act
    Start Traffic With Invalid UE ID

    # Assert
    Verify Start Traffic Fails For Invalid UE ID

05 Start Traffic With UE Not Attached
    [Documentation]    Verifies that traffic start fails when a valid UE ID is not attached.
    [Tags]    traffic    start-traffic    negative    not-attached
    # Arrange
    Prepare Clean EPC Environment

    # Act
    Start Traffic With UE Not Attached

    # Assert
    Verify Start Traffic Fails For UE Not Attached

*** Keywords ***
Start Traffic With Valid Parameters
    ${resp}=    Start Traffic    ${UE_VALID}    ${BEARER_DEFAULT}    ${TRAFFIC_PROTOCOL}    ${TRAFFIC_VALID}
    Set Test Variable    ${START_TRAFFIC_VALID_RESPONSE}    ${resp}

Verify Start Traffic Succeeds
    ${expected_bps}=    Evaluate    int(${TRAFFIC_VALID}) * 1000000
    Response Status Should Be    ${START_TRAFFIC_VALID_RESPONSE}    200
    Response Should Contain Key    ${START_TRAFFIC_VALID_RESPONSE}    status
    Response JSON Field Should Be    ${START_TRAFFIC_VALID_RESPONSE}    ue_id    ${UE_VALID}
    Response JSON Field Should Be    ${START_TRAFFIC_VALID_RESPONSE}    bearer_id    ${BEARER_DEFAULT}
    Response JSON Field Should Be    ${START_TRAFFIC_VALID_RESPONSE}    target_bps    ${expected_bps}

Stop Traffic On Default Bearer
    Stop Traffic On Bearer    ${UE_VALID}    ${BEARER_DEFAULT}

Start Traffic With Invalid Speed
    ${resp}=    Start Traffic    ${UE_VALID}    ${BEARER_DEFAULT}    ${TRAFFIC_PROTOCOL}    ${TRAFFIC_INVALID}
    Set Test Variable    ${START_TRAFFIC_INVALID_SPEED_RESPONSE}    ${resp}

Verify Start Traffic Fails For Invalid Speed
    Response Status Should Be    ${START_TRAFFIC_INVALID_SPEED_RESPONSE}    422

Start Traffic On Inactive Bearer
    ${resp}=    Start Traffic    ${UE_VALID}    ${BEARER_VALID}    ${TRAFFIC_PROTOCOL}    ${TRAFFIC_VALID}
    Set Test Variable    ${START_TRAFFIC_INACTIVE_BEARER_RESPONSE}    ${resp}

Verify Start Traffic Fails For Inactive Bearer
    Response Status Should Be    ${START_TRAFFIC_INACTIVE_BEARER_RESPONSE}    400
    Response Should Contain Message    ${START_TRAFFIC_INACTIVE_BEARER_RESPONSE}    Bearer not found

Start Traffic With Invalid UE ID
    ${resp}=    Start Traffic    ${UE_INVALID}    ${BEARER_DEFAULT}    ${TRAFFIC_PROTOCOL}    ${TRAFFIC_VALID}
    Set Test Variable    ${START_TRAFFIC_INVALID_UE_RESPONSE}    ${resp}

Verify Start Traffic Fails For Invalid UE ID
    Response Status Should Be    ${START_TRAFFIC_INVALID_UE_RESPONSE}    400
    Response Should Contain Message    ${START_TRAFFIC_INVALID_UE_RESPONSE}    UE not found

Start Traffic With UE Not Attached
    ${resp}=    Start Traffic    ${UE_VALID}    ${BEARER_DEFAULT}    ${TRAFFIC_PROTOCOL}    ${TRAFFIC_VALID}
    Set Test Variable    ${START_TRAFFIC_NOT_ATTACHED_RESPONSE}    ${resp}

Verify Start Traffic Fails For UE Not Attached
    Response Status Should Be    ${START_TRAFFIC_NOT_ATTACHED_RESPONSE}    400
    Response Should Contain Message    ${START_TRAFFIC_NOT_ATTACHED_RESPONSE}    UE not found
