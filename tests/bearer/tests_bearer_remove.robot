*** Settings ***
Documentation   Tests of removing bearers
Resource        keywords/EPC_Bearers_Keywords.robot

Test Setup      Attach UE With ID 1 And Add Bearer With ID 2
Test Teardown   Reset EPC

*** Test Cases ***

# --- Valid ---

Test delete correct bearer valid UE ID and Bearer ID
    [Documentation]    Verify successful deletion of a previously added dedicated bearer.
    Response From Delete Bearer 2 From UE 1 Should Be OK

Test delete bearer response should contain correct status
    [Documentation]    Verify that the response from deleting a bearer contains the correct "status" key with the value "bearer_deleted".
    Response From Delete Bearer 2 From UE 1 Should Contain Key status With Value bearer_deleted

Test delete bearer response should contain same UE ID
    [Documentation]    Verify that the response from deleting a bearer contains the correct UE ID.
    Response From Delete Bearer 2 From UE 1 Should Contain Key ue_id With Value 1

Test delete bearer response should contain same Bearer ID
    [Documentation]    Verify that the response from deleting a bearer contains the correct Bearer ID.
    Response From Delete Bearer 2 From UE 1 Should Contain Key bearer_id With Value 2