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

*** Keywords ***

Check Traffic For Invalid UE ID
	${resp}=    Check Traffic    ${UE_INVALID}    9
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


