*** Settings ***
Documentation     Traffic scenario for one UE using all of its bearers
Resource          ../../resources/EPC_API.robot
Resource          ../../resources/EPC_Assertions.robot
Resource          ../../resources/EPC_Common.robot

*** Test Cases ***
01 UE Traffic Across All Bearers Should Be Visible In The UE Summary
	[Documentation]    Verifies that the default bearer and additional bearers can carry traffic and are visible in the UE details and aggregate summary.
	# Arrange
	Prepare Clean EPC Environment
	Prepare UE With Additional Bearers

	# Act
	Start Traffic On All Bearers

	# Assert
	Verify Traffic On All Bearers
	Verify UE Aggregate Summary For All Bearers

	# Cleanup
	Stop Traffic On All Bearers

*** Keywords ***

Attach UE To Network
	[Arguments]    ${ue_id}
	${resp}=    Attach UE    ${ue_id}
	Response Status Should Be    ${resp}    200
	Response Should Contain Key    ${resp}    status
	Response JSON Field Should Be    ${resp}    ue_id    ${ue_id}

Prepare UE With Additional Bearers
	Attach UE To Network    ${UE_VALID}
	Add Bearer To UE    ${UE_VALID}    1
	Add Bearer To UE    ${UE_VALID}    ${BEARER_VALID}

Add Bearer To UE
	[Arguments]    ${ue_id}    ${bearer_id}
	${resp}=    Add Bearer    ${ue_id}    ${bearer_id}
	Response Status Should Be    ${resp}    200
	Response Should Contain Key    ${resp}    status
	Response JSON Field Should Be    ${resp}    ue_id    ${ue_id}
	Response JSON Field Should Be    ${resp}    bearer_id    ${bearer_id}

Start Traffic On Bearer
	[Arguments]    ${ue_id}    ${bearer_id}    ${protocol}    ${mbps}
	${resp}=    Start Traffic    ${ue_id}    ${bearer_id}    ${protocol}    ${mbps}
	${expected_bps}=    Evaluate    int(${mbps}) * 1000000
	Response Status Should Be    ${resp}    200
	Response Should Contain Key    ${resp}    status
	Response JSON Field Should Be    ${resp}    ue_id    ${ue_id}
	Response JSON Field Should Be    ${resp}    bearer_id    ${bearer_id}
	Response JSON Field Should Be    ${resp}    target_bps    ${expected_bps}

Start Traffic On All Bearers
	Start Traffic On Bearer    ${UE_VALID}    9    tcp    10
	Start Traffic On Bearer    ${UE_VALID}    1    udp    20
	Start Traffic On Bearer    ${UE_VALID}    ${BEARER_VALID}    tcp    30

Stop Traffic On Bearer
	[Arguments]    ${ue_id}    ${bearer_id}
	${resp}=    Stop Traffic    ${ue_id}    ${bearer_id}
	Response Status Should Be    ${resp}    200
	Response Should Contain Key    ${resp}    status
	Response JSON Field Should Be    ${resp}    ue_id    ${ue_id}
	Response JSON Field Should Be    ${resp}    bearer_id    ${bearer_id}

Stop Traffic On All Bearers
	Stop Traffic On Bearer    ${UE_VALID}    9
	Stop Traffic On Bearer    ${UE_VALID}    1
	Stop Traffic On Bearer    ${UE_VALID}    ${BEARER_VALID}

Get UE Details
	[Arguments]    ${ue_id}
	${resp}=    GET    /ues/${ue_id}
	RETURN    ${resp}

Get UE Summary
	[Arguments]    ${ue_id}    ${include_details}=false
	${resp}=    GET    /ues/stats?ue_id=${ue_id}&include_details=${include_details}
	RETURN    ${resp}

Verify UE Bearer Traffic In Summary
	[Arguments]    ${ue_id}    ${bearer_id}    ${protocol}    ${mbps}
	${expected_bps}=    Evaluate    int(${mbps}) * 1000000
	${resp}=    Get UE Details    ${ue_id}
	Response Status Should Be    ${resp}    200
	Response JSON Field Should Be    ${resp}    ue_id    ${ue_id}
	Response Should Contain Key    ${resp}    bearers
	Response Should Contain Key    ${resp}    stats
	Response JSON Nested Object Field Should Be    ${resp}    bearers    ${bearer_id}    bearer_id    ${bearer_id}
	Response JSON Nested Object Field Should Be    ${resp}    bearers    ${bearer_id}    active    ${True}
	Response JSON Nested Object Field Should Be    ${resp}    bearers    ${bearer_id}    protocol    ${protocol}
	Response JSON Nested Object Field Should Be    ${resp}    bearers    ${bearer_id}    target_bps    ${expected_bps}
	Response JSON Nested Object Field Should Be    ${resp}    stats    ${bearer_id}    bearer_id    ${bearer_id}
	Response JSON Nested Object Field Should Be    ${resp}    stats    ${bearer_id}    ue_id    ${ue_id}
	Response JSON Nested Object Field Should Be    ${resp}    stats    ${bearer_id}    protocol    ${protocol}
	Response JSON Nested Object Field Should Be    ${resp}    stats    ${bearer_id}    target_bps    ${expected_bps}

Verify Traffic On All Bearers
	Verify UE Bearer Traffic In Summary    ${UE_VALID}    9    tcp    10
	Verify UE Bearer Traffic In Summary    ${UE_VALID}    1    udp    20
	Verify UE Bearer Traffic In Summary    ${UE_VALID}    ${BEARER_VALID}    tcp    30

Verify UE Aggregate Summary For All Bearers
	${resp}=    Get UE Summary    ${UE_VALID}    true
	Response Status Should Be    ${resp}    200
	Response Should Contain Key    ${resp}    scope
	Response JSON Field Should Be    ${resp}    ue_count    1
	Response JSON Field Should Be    ${resp}    bearer_count    3
	Response Should Contain Key    ${resp}    total_tx_bps
	Response Should Contain Key    ${resp}    total_rx_bps
	Response Should Contain Key    ${resp}    details


