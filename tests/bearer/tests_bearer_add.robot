*** Settings ***
Documentation   Tests of adding bearers
Resource        keywords/EPC_Bearers_Keywords.robot

Test Teardown   Reset EPC

*** Test Cases ***

# --- Valid ---

01 Add bearer with valid UE ID and bearer ID
    [Documentation]    Verify that a new bearer can be added to an attached UE when valid UE ID and bearer ID are provided.
    Attach UE With ID 1
    Add Bearer With ID 2 To UE With ID 1 Response With OK
    UE With ID 1 Have Bearer With ID 2

02 Add bearer response contain correct IDs and status
    [Documentation]    Verify that the response from adding a bearer contains the correct UE ID, bearer ID and Status.
    Attach UE With ID 1
    Add Bearer With ID 2 To UE With ID 1 Response With Correct Values

03 Add bearer lower boundary ID
    [Documentation]    Verify adding a bearer with the lowest allowed ID (ID = 1).
    Attach UE With ID 1
    Add Bearer With ID 1 To UE With ID 1 Response With OK
    UE With ID 1 Have Bearer With ID 1

04 Add bearer upper boundary ID
    [Documentation]    Verify adding a bearer with the highest allowed ID bearers (ID = 8).
    Attach UE With ID 1
    Add Bearer With ID 8 To UE With ID 1 Response With OK
    UE With ID 1 Have Bearer With ID 8


# --- Invalid ---

05 Add bearer under boundary ID
    [Documentation]    TO DO
    Attach UE With ID 1
    Add Bearer With ID 0 To UE With ID 1 Response With Unprocessable Entity
    UE With ID 1 Do Not Have Bearer With ID 0

06 Add bearer above bundary ID
    [Documentation]    TO DO
    Attach UE With ID 1
    Add Bearer With ID 10 To UE With ID 1 Response With Unprocessable Entity
    UE With ID 1 Do Not Have Bearer With ID 10

07 Add bearer under boundary ID response contain correct error type
    [Documentation]    TO DO
    Attach UE With ID 1
    Add Bearer With ID 0 To UE With ID 1 Response With Greater Than Equal Error Type

08 Add bearer above boundary ID response contain correct error type
    [Documentation]    TO DO
    Attach UE With ID 1
    Add Bearer With ID 10 To UE With ID 1 Response With Less Than Equal Error Type

09 Add existing bearer
    [Documentation]    TO DO
    Attach UE With ID 1
    Add Bearer With ID 2 To UE With ID 1
    Add Bearer With ID 2 To UE With ID 1 Response With Bad Request

10 Add bearer to non-existing UE
    [Documentation]    TO DO
    # To make sure that no UE is added already
    Reset EPC
    Add Bearer With ID 2 To UE With ID 1 Response With Bad Request

11 Add bearer without ID
    Attach UE With ID 1
    Add Bearer Without ID To UE With ID 1 Response With Unprocessable Entity


*** Keywords ***

Add Bearer With ID ${bearer_id} To UE With ID ${ue_id} Response With OK
    Add Bearer Should Response With    200      ${ue_id}    ${bearer_id}

Add Bearer With ID ${bearer_id} To UE With ID ${ue_id} Response With Bad Request
    Add Bearer Should Response With    400      ${ue_id}    ${bearer_id}

Add Bearer With ID ${bearer_id} To UE With ID ${ue_id} Response With Unprocessable Entity
    Add Bearer Should Response With    422      ${ue_id}    ${bearer_id}

Add Bearer Without ID To UE With ID ${ue_id} Response With Unprocessable Entity
    Add Bearer Should Response With    422      ${ue_id}    ''

Add Bearer With ID ${bearer_id} To UE With ID ${ue_id} Response With Correct Values
    ${add_resp}=       Add Bearer    ${ue_id}   ${bearer_id}
    Response JSON Field Should Be  ${add_resp}     ue_id     ${ue_id}
    Response JSON Field Should Be  ${add_resp}     bearer_id     ${bearer_id}
    Response JSON Field Should Be  ${add_resp}     status     bearer_added

Add Bearer With ID ${bearer_id} To UE With ID ${ue_id} Response With Greater Than Equal Error Type
    Add Bearer Shuld Response With Error Type   greater_than_equal      ${ue_id}    ${bearer_id}

Add Bearer With ID ${bearer_id} To UE With ID ${ue_id} Response With Less Than Equal Error Type
    Add Bearer Shuld Response With Error Type   less_than_equal      ${ue_id}   ${bearer_id}