*** Settings ***
Documentation   Tests of default bearer added automaticly to UE on attach
Resource        keywords/EPC_Bearers_Keywords.robot

Test Teardown   Reset EPC

*** Test Cases ***

# --- Valid ---

01 Attached UE have Bearer with ID 9
    [Documentation]     Verify that after attaching a User Equipment (UE), it automatically receives a default bearer with ID 9.
    Attach UE With ID 1
    UE With ID 1 Have Bearer With ID 9


# --- Invalid ---

02 Remove Bearer with ID 9
    [Documentation]    To DO
    Attach UE With ID 1
    Delete Bearer With ID 9 From UE With ID 1 Response With Bad Request
    UE With ID 1 Have Bearer With ID 9