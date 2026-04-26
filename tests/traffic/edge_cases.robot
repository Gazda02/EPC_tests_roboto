*** Settings ***
Documentation     Edge case tests for API type coercion and traffic direction assumptions
Resource          ../../resources/EPC_API.robot
Resource          ../../resources/EPC_Assertions.robot
Resource          ../../resources/EPC_Common.robot

*** Keywords ***

Stop Traffic For Nonexistent Bearer
	[Arguments]    ${ue_id}    ${bearer_id}
	${resp}=    Stop Traffic    ${ue_id}    ${bearer_id}
	Set Test Variable    ${NONEXISTENT_BEARER_STOP_RESPONSE}    ${resp}

