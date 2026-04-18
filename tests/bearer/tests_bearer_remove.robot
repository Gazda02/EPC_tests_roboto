*** Settings ***
Documentation   Tests of removing bearers
Resource        keywords/EPC_Bearers_Keywords.robot

Test Teardown   Reset EPC

*** Test Cases ***

# --- Valid ---

01 Delete correct bearer valid UE ID and Bearer ID
    [Documentation]    Verify successful deletion of a previously added dedicated bearer.
    Attach UE With ID 1
    Add Bearer With ID 2 To UE With ID 1
    
    Delete Bearer With ID 2 From UE With ID 1 Response With OK
    
    UE With ID 1 Do Not Have Bearer With ID 2

02 Delete bearer contain correct IDs and status
    [Documentation]    Verify that the response from deleting a bearer contains the correct UE ID, Bearer ID and Status.
    Attach UE With ID 1
    Add Bearer With ID 2 To UE With ID 1
    
    Delete Bearer With ID 2 From UE With ID 1 Response With Correct Values


# --- Invalid ---

03 Delete non-existeng bearer
    [Documentation]    TODO
    Attach UE With ID 1

    Delete Bearer With ID 5 From UE With ID 1 Response With Bad Request

04 Delete bearer without ID
    [Documentation]    TODO
    Attach UE With ID 1

    Delete Bearer Without ID From UE With ID 1 Response With Unprocessable Entity


*** Keywords ***

Delete Bearer With ID ${bearer_id} From UE With ID ${ue_id} Response With OK
    Delete Bearer Should Response With    200   ${ue_id}    ${bearer_id}

Delete Bearer Without ID From UE With ID ${ue_id} Response With Unprocessable Entity
    Delete Bearer Should Response With    422   ${ue_id}    ''

Delete Bearer With ID ${bearer_id} From UE With ID ${ue_id} Response With Correct Values
    ${add_resp}=       Delete Bearer    ${ue_id}   ${bearer_id}
    Response JSON Field Should Be  ${add_resp}     ue_id     ${ue_id}
    Response JSON Field Should Be  ${add_resp}     bearer_id     ${bearer_id}
    Response JSON Field Should Be  ${add_resp}     status     bearer_deleted
