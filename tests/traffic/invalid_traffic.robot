*** Settings ***
Documentation     Negative traffic checks for invalid UE and bearer identifiers
Resource          ../../resources/EPC_API.robot
Resource          ../../resources/EPC_Assertions.robot
Resource          ../../resources/EPC_Common.robot

*** Test Cases ***
01 Check Traffic With Invalid UE ID
	[Documentation]    Verifies that traffic check fails when UE does not exist.
	[Tags]    traffic    negative    invalid-ue
	# Arrange
	Prepare Clean EPC Environment

	# Act
	Check Traffic For Invalid UE ID

	# Assert
	Verify Traffic Check Error For Invalid UE ID

02 Check Traffic With Invalid Bearer ID
	[Documentation]    Verifies response for traffic check on a non-existing bearer identifier.
	[Tags]    traffic    negative    invalid-bearer
	# Arrange
	Prepare Clean EPC Environment

	# Act
	Attach The Default UE
	Check Traffic For Invalid Bearer ID

	# Assert
	Verify Traffic Check Result For Invalid Bearer ID

03 End Traffic With Invalid UE ID
	[Documentation]    Verifies that stopping traffic fails when UE does not exist.
	[Tags]    traffic    negative    invalid-ue
	# Arrange
	Prepare Clean EPC Environment

	# Act
	End Traffic For Invalid UE ID

	# Assert
	Verify End Traffic Error For Invalid UE ID

04 End Traffic With Invalid Bearer ID
	[Documentation]    Verifies that stopping traffic fails when bearer does not exist.
	[Tags]    traffic    negative    invalid-bearer
	# Arrange
	Prepare Clean EPC Environment

	# Act
	Attach The Default UE
	End Traffic For Invalid Bearer ID

	# Assert
	Verify End Traffic Error For Invalid Bearer ID

05 Start Traffic With Negative Throughput
	[Documentation]    Verifies that traffic speed out of range (negative value) returns an error.
	[Tags]    exploratory    traffic    validation    negative
	# Arrange
	Prepare Clean EPC Environment
	Attach UE With ID 11
	Add Bearer With ID 1 To UE With ID 11

	# Act
	Start Traffic With Negative Throughput    11    1

	# Assert
	Verify Traffic Rejection For Negative Throughput

06 Throughput Statistics Should Not Be Negative
	[Documentation]    Verifies that even with invalid input, reporting stats (tx/rx) do not become negative.
	[Tags]    exploratory    traffic    stats    negative
	# Arrange
	Prepare Clean EPC Environment
	Attach UE To Network    12
	Add Bearer With ID 1 To UE With ID 12

	# Act
	Start Traffic With Negative Throughput    12    1
	Retrieve Traffic Statistics    12    1

	# Assert
	Verify Statistics Are Non-Negative

07 Check Traffic For Nonexistent Bearer Must Fail
    [Documentation]    Verifies that GET traffic for nonexistent bearer returns error (400/404), NOT 200 with fake stats. Per spec: bearer must be active. Consistency with DELETE test 01: both should fail.
    [Tags]    compliance    traffic    negative    nonexistent-bearer

    # Arrange
    Prepare Clean EPC Environment
    Attach The Default UE

    # Act
    Retrieve Traffic For Nonexistent Bearer    ${UE_VALID}    99

    # Assert
    Verify Traffic For Nonexistent Bearer Returns Error Not Success
	

*** Keywords ***

Check Traffic For Invalid UE ID
	${resp}=    Check Traffic    ${UE_INVALID}    ${BEARER_DEFAULT}
	Set Test Variable    ${INVALID_UE_TRAFFIC_RESPONSE}    ${resp}

Verify Traffic Check Error For Invalid UE ID
	Response Status Should Be    ${INVALID_UE_TRAFFIC_RESPONSE}    400
	Response Should Contain Message    ${INVALID_UE_TRAFFIC_RESPONSE}    UE not found

Check Traffic For Invalid Bearer ID
	${resp}=    Check Traffic    ${UE_VALID}    ${BEARER_INVALID}
	Set Test Variable    ${INVALID_BEARER_TRAFFIC_RESPONSE}    ${resp}

Verify Traffic Check Result For Invalid Bearer ID
	Response Status Should Be    ${INVALID_BEARER_TRAFFIC_RESPONSE}    200
	Response JSON Field Should Be    ${INVALID_BEARER_TRAFFIC_RESPONSE}    ue_id    ${UE_VALID}
	Response JSON Field Should Be    ${INVALID_BEARER_TRAFFIC_RESPONSE}    bearer_id    ${BEARER_INVALID}
	Response JSON Field Should Be    ${INVALID_BEARER_TRAFFIC_RESPONSE}    protocol    ${None}
	Response JSON Field Should Be    ${INVALID_BEARER_TRAFFIC_RESPONSE}    target_bps    ${None}
	Response JSON Field Should Be    ${INVALID_BEARER_TRAFFIC_RESPONSE}    tx_bps    0
	Response JSON Field Should Be    ${INVALID_BEARER_TRAFFIC_RESPONSE}    rx_bps    0
	Response Should Contain Key    ${INVALID_BEARER_TRAFFIC_RESPONSE}    duration

End Traffic For Invalid UE ID
	${resp}=    Stop Traffic    ${UE_INVALID}    ${BEARER_DEFAULT}
	Set Test Variable    ${INVALID_UE_STOP_RESPONSE}    ${resp}

Verify End Traffic Error For Invalid UE ID
	Response Status Should Be    ${INVALID_UE_STOP_RESPONSE}    400
	Response Should Contain Message    ${INVALID_UE_STOP_RESPONSE}    UE not found

End Traffic For Invalid Bearer ID
	${resp}=    Stop Traffic    ${UE_VALID}    ${BEARER_INVALID}
	Set Test Variable    ${INVALID_BEARER_STOP_RESPONSE}    ${resp}

Verify End Traffic Error For Invalid Bearer ID
	Response Status Should Be    ${INVALID_BEARER_STOP_RESPONSE}    400
	Response Should Contain Message    ${INVALID_BEARER_STOP_RESPONSE}    Bearer not found

Start Traffic With Negative Throughput
	[Arguments]    ${ue_id}    ${bearer_id}
	${resp}=    Start Traffic    ${ue_id}    ${bearer_id}    ${TRAFFIC_PROTOCOL}    -1
	Set Test Variable    ${NEGATIVE_TRAFFIC_RESPONSE}    ${resp}

Verify Traffic Rejection For Negative Throughput
	Should Not Be Equal As Integers    ${NEGATIVE_TRAFFIC_RESPONSE.status_code}    200

Retrieve Traffic Statistics
	[Arguments]    ${ue_id}    ${bearer_id}
	${resp}=    Check Traffic    ${ue_id}    ${bearer_id}
	Set Test Variable    ${TRAFFIC_STATS_RESPONSE}    ${resp}

Verify Statistics Are Non-Negative
	${tx}=    Get From Dictionary    ${TRAFFIC_STATS_RESPONSE.json()}    tx_bps
	${rx}=    Get From Dictionary    ${TRAFFIC_STATS_RESPONSE.json()}    rx_bps
	Should Be True    ${tx} >= 0
	Should Be True    ${rx} >= 0

Retrieve Traffic For Nonexistent Bearer
	[Arguments]    ${ue_id}    ${bearer_id}
	${resp}=    Check Traffic    ${ue_id}    ${bearer_id}
	Set Test Variable    ${NONEXISTENT_BEARER_TRAFFIC_RESPONSE}    ${resp}

Verify Traffic For Nonexistent Bearer Returns Error Not Success
	Response Status Should Not Be    ${NONEXISTENT_BEARER_TRAFFIC_RESPONSE}    200
	# Per spec and DELETE consistency: must fail, not return empty stats
	Should Be True    ${NONEXISTENT_BEARER_TRAFFIC_RESPONSE.status_code} >= 400