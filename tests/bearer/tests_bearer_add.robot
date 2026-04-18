*** Settings ***
Documentation   Tests of adding bearers
Resource        keywords/EPC_Bearers_Keywords.robot

Test Teardown   Reset EPC

*** Test Cases ***

# --- Valid ---

01 Add bearer with valid UE ID and Bearer ID
    [Documentation]    Verify that a new bearer can be added to an attached UE when valid UE ID and Bearer ID are provided.
    Attach UE With ID 1
    Add Bearer With ID 2 To UE With ID 1 Response With OK
    UE With ID 1 Have Bearer With ID 2

02 Add bearer response contain correct IDs and status
    [Documentation]    Verify that the response from adding a bearer contains the correct UE ID, Bearer ID and Status.
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

05 Add Bearer under boundary ID
    [Documentation]    TO DO
    Attach UE With ID 1
    Add Bearer With ID 0 To UE With ID 1 Response With Unprocessable Entity
    UE With ID 1 Do Not Have Bearer With ID 0

06 Add Bearer above bundary ID
    [Documentation]    TO DO
    Attach UE With ID 1
    Add Bearer With ID 10 To UE With ID 1 Response With Unprocessable Entity
    UE With ID 1 Do Not Have Bearer With ID 10

07 Add Bearer under boundary ID response contain correct error type
    [Documentation]    TO DO
    Attach UE With ID 1
    Add Bearer With ID 0 To UE With ID 1 Response With Less Than Equal Error Type

08 Add Bearer above boundary ID response contain correct error type
    [Documentation]    TO DO
    Attach UE With ID 1
    Add Bearer With ID 10 To UE With ID 1 Response With Greater Than Equal Error Type

09 Add Existing Bearer
    [Documentation]    TO DO
    Attach UE With ID 1
    Add Bearer With ID 2 To UE With ID 1
    Add Bearer With ID 2 To UE With ID 1 Response With Bad Request

10 Add Bearer to non-existing UE
    [Documentation]    TO DO
    # To make sure that no UE is added already
    Reset EPC
    Add Bearer With ID 2 To UE With ID 1 Response With Bad Request

11 Add bearer without ID
    Attach UE With ID 1
    Add Bearer Without ID To UE With ID 1 Response With Unprocessable Entity