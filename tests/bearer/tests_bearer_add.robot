*** Settings ***
Documentation   Tests of adding bearers
Resource        keywords/EPC_Bearers_Keywords.robot

Test Setup      Attach UE With ID 1
Test Teardown   Reset EPC

*** Test Cases ***

# --- Valid ---

Test add bearer with valid UE ID and Bearer ID
    [Documentation]    Verify that a new bearer can be added to an attached UE when valid UE ID and Bearer ID are provided.
    Response From Add Bearer 2 To UE 1 Should Be OK
    UE 1 Should Have Bearer 2

Test add bearer response should contain correct status
    [Documentation]    Verify that the response from adding a bearer contains the correct "status" key with the value "bearer_added".
    Response From Add Bearer 2 To UE 1 Should Contain Key status With Value bearer_added

Test add bearer response should contain same UE ID
    [Documentation]    Verify that the response from adding a bearer contains the correct UE ID.
    Response From Add Bearer 2 To UE 1 Should Contain Key ue_id With Value 1

Test add bearer response should contain same Bearer ID
    [Documentation]    Verify that the response from adding a bearer contains the correct Bearer ID.
    Response From Add Bearer 2 To UE 1 Should Contain Key bearer_id With Value 2

Test add bearer lower boundary ID 1
    [Documentation]    Verify adding a bearer with the lowest allowed ID (ID = 1).
    Response From Add Bearer 1 To UE 1 Should Be OK

Test add bearer upper boundary for dedicated ID 8
    [Documentation]    Verify adding a bearer with the highest allowed ID for dedicated bearers (ID = 8).
    Response From Add Bearer 8 To UE 1 Should Be OK

# --- Invalid ---