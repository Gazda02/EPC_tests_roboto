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


04 Add Bearer With String Bearer ID Should Fail
	[Documentation]    Verifies that API rejects string values for bearer_id parameter. Per spec: bearer_id must be numeric.
	[Tags]    api    edge-case    type-coercion    string    compliance
	# Arrange
	Prepare Clean EPC Environment
	Attach The Default UE

	# Act
	Add Bearer With String ID

	# Assert
	Verify Add Bearer With String ID Fails With Type Error

05 Start Traffic With String Speed Parameter Should Fail
	[Documentation]    Verifies that API rejects string values for numeric speed parameters (e.g., "25" instead of 25). Per spec: Mbps must be numeric.
	[Tags]    api    edge-case    type-coercion    string    traffic    compliance
	# Arrange
	Prepare Clean EPC Environment
	Attach The Default UE

	# Act
	Start Traffic With String Speed

	# Assert
	Verify Start Traffic With String Speed Fails With Type Error


06 Start Traffic With Boolean True Speed Parameter Should Fail
	[Documentation]    Verifies that API rejects boolean TRUE value for numeric speed parameters. Per spec: Mbps must be numeric.
	[Tags]    api    edge-case    type-coercion    boolean    traffic    compliance
	# Arrange
	Prepare Clean EPC Environment
	Attach The Default UE

	# Act
	Start Traffic With Boolean Speed

	# Assert
	Verify Start Traffic With Boolean Speed Fails With Type Error


07 Start Traffic In Uplink Direction UL Should Fail
	[Documentation]    Verifies that transfer can ONLY be started in downlink (DL) direction. Per spec (line 30): "Transfer danych można rozpocząć tylko w kierunku DL". UL must be rejected.
	[Tags]    api    edge-case    transfer-direction    compliance
	# Arrange
	Prepare Clean EPC Environment
	Attach The Default UE

	# Act
	Start Traffic In UL Direction

	# Assert
	Verify Traffic Started In UL Direction Fails With Invalid Direction Error


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

Add Bearer With String ID
	${string_bearer_id}=    Set Variable    3
	${body}=    Create Dictionary    bearer_id=${string_bearer_id}
	${resp}=    POST    /ues/${UE_VALID}/bearers    ${body}
	Set Test Variable    ${ADD_BEARER_STRING_ID_RESPONSE}    ${resp}

Verify Add Bearer With String ID Fails With Type Error
	Response Status Should Not Be    ${ADD_BEARER_STRING_ID_RESPONSE}    200
	# Should reject string where numeric expected
	Should Be True    ${ADD_BEARER_STRING_ID_RESPONSE.status_code} >= 400
	
Start Traffic With String Speed
	${string_speed}=    Set Variable    25
	${payload}=    Create Dictionary    protocol=tcp    Mbps=${string_speed}
	${resp}=    POST    /ues/${UE_VALID}/bearers/${BEARER_DEFAULT}/traffic    ${payload}
	Set Test Variable    ${START_TRAFFIC_STRING_SPEED_RESPONSE}    ${resp}

Verify Start Traffic With String Speed Fails With Type Error
	Response Status Should Not Be    ${START_TRAFFIC_STRING_SPEED_RESPONSE}    200
	# Should reject string where numeric expected
	Should Be True    ${START_TRAFFIC_STRING_SPEED_RESPONSE.status_code} >= 400

Start Traffic With Boolean Speed
	${boolean_speed}=    Evaluate    True
	${payload}=    Create Dictionary    protocol=udp    Mbps=${boolean_speed}
	${resp}=    POST    /ues/${UE_VALID}/bearers/${BEARER_DEFAULT}/traffic    ${payload}
	Set Test Variable    ${START_TRAFFIC_BOOLEAN_SPEED_RESPONSE}    ${resp}

Verify Start Traffic With Boolean Speed Fails With Type Error
	Response Status Should Not Be    ${START_TRAFFIC_BOOLEAN_SPEED_RESPONSE}    200
	# Should reject boolean where numeric expected
	Should Be True    ${START_TRAFFIC_BOOLEAN_SPEED_RESPONSE.status_code} >= 400


Start Traffic In UL Direction
	${payload}=    Create Dictionary    protocol=tcp    Mbps=10    direction=UL
	${resp}=    POST    /ues/${UE_VALID}/bearers/${BEARER_DEFAULT}/traffic    ${payload}
	Set Test Variable    ${START_TRAFFIC_UL_RESPONSE}    ${resp}

Verify Traffic Started In UL Direction Fails With Invalid Direction Error
	Response Status Should Not Be    ${START_TRAFFIC_UL_RESPONSE}    200
	# Per spec: only DL is allowed, UL must fail
	Should Be True    ${START_TRAFFIC_UL_RESPONSE.status_code} >= 400
	Response Should Contain Message    ${START_TRAFFIC_UL_RESPONSE}    direction