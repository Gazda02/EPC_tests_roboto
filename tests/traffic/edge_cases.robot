*** Settings ***
Documentation     Edge case tests for API type coercion and traffic direction assumptions
Resource          ../../resources/EPC_API.robot
Resource          ../../resources/EPC_Assertions.robot
Resource          ../../resources/EPC_Common.robot


*** Test Cases ***
01 Delete Traffic For Nonexistent Bearer Returns 400
	[Documentation]    Verifies that DELETE traffic for a nonexistent bearer returns 400 (Bearer not found).
	[Tags]    traffic    edge-case    nonexistent-bearer
	# Arrange
	Prepare Clean EPC Environment
	Attach The Default UE

	# Act
	Stop Traffic For Nonexistent Bearer    ${UE_VALID}    99

	# Assert
	Verify Delete Traffic Error For Nonexistent Bearer


02 Attach UE With String UE ID Should Fail
	[Documentation]    Verifies that API rejects string values for numeric fields (e.g., ue_id="50" instead of 50). Per spec: ue_id must be numeric.
	[Tags]    api    edge-case    type-coercion    string    compliance
	# Arrange
	Prepare Clean EPC Environment

	# Act
	Attach UE With String ID

	# Assert
	Verify Attach With String ID Fails With Type Error

03 Attach UE With Boolean True For UE ID Should Fail
	[Documentation]    Verifies that API rejects boolean TRUE for numeric fields. Per spec: ue_id must be numeric integer.
	[Tags]    api    edge-case    type-coercion    boolean    compliance
	# Arrange
	Prepare Clean EPC Environment

	# Act
	Attach UE With Boolean True ID

	# Assert
	Verify Attach With Boolean ID Fails With Type Error

*** Keywords ***

Stop Traffic For Nonexistent Bearer
	[Arguments]    ${ue_id}    ${bearer_id}
	${resp}=    Stop Traffic    ${ue_id}    ${bearer_id}
	Set Test Variable    ${NONEXISTENT_BEARER_STOP_RESPONSE}    ${resp}

Verify Delete Traffic Error For Nonexistent Bearer
	Response Status Should Be    ${NONEXISTENT_BEARER_STOP_RESPONSE}    400
	Response Should Contain Message    ${NONEXISTENT_BEARER_STOP_RESPONSE}    Bearer not found

Attach UE With String ID
	${string_ue_id}=    Set Variable    50
	${body}=    Create Dictionary    ue_id=${string_ue_id}
	${resp}=    POST    /ues    ${body}
	Set Test Variable    ${ATTACH_STRING_ID_RESPONSE}    ${resp}

Verify Attach With String ID Fails With Type Error
	Response Status Should Not Be    ${ATTACH_STRING_ID_RESPONSE}    200
	# Should reject string where numeric expected
	Should Be True    ${ATTACH_STRING_ID_RESPONSE.status_code} >= 400

Attach UE With Boolean True ID
	${boolean_id}=    Evaluate    True
	${body}=    Create Dictionary    ue_id=${boolean_id}
	${resp}=    POST    /ues    ${body}
	Set Test Variable    ${ATTACH_BOOLEAN_ID_RESPONSE}    ${resp}

Verify Attach With Boolean ID Fails With Type Error
	Response Status Should Not Be    ${ATTACH_BOOLEAN_ID_RESPONSE}    200
	# Should reject boolean where numeric expected
	Should Be True    ${ATTACH_BOOLEAN_ID_RESPONSE.status_code} >= 400