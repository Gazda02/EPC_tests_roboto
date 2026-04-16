*** Settings ***
Documentation   Tests of default bearer added automaticly to UE on attach
Resource        keywords/EPC_Bearers_Keywords.robot

Test Setup      Attach UE    1
Test Teardown   Reset EPC

*** Test Cases ***

# --- Valid ---

Test attached UE should have Bearer with ID 9
    [Documentation]     Verify that after attaching a User Equipment (UE), it automatically receives a default bearer with ID 9.
    UE 1 Should Have Bearer 9

# --- Invalid ---