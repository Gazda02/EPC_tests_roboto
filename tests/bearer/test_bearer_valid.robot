*** Settings ***
Documentation     Do dodania
Resource        keywords/EPC_Bearers_Keywords.robot

Test Setup        Reset EPC
Test Teardown     Reset EPC

*** Test Cases ***

# --- Automatyczne dodanie bearera ---

Test attached UE should have Bearer with ID 9
    [Documentation]     To add
    Response From Attach UE 1 Should Be 200
    UE 1 Should Have Bearer 9


# --- Dodanie kanału transportowego (add bearer) ---

Test add bearer with valid UE ID and Bearer ID
    [Documentation]    To add
    Response From Attach UE 1 Should Be 200
    Response From Add Bearer 2 To UE 1 Should Be 200
    UE 1 Should Have Bearer 2

Test add bearer response should contain correct status
    [Documentation]    To add
    Response From Attach UE 1 Should Be 200
    Response From Add Bearer 2 To UE 1 Should Be 200 And Contain Key status With Value bearer_added

Test add bearer response should contain same UE ID
    [Documentation]    To add
    Response From Attach UE 1 Should Be 200
    Response From Add Bearer 2 To UE 1 Should Be 200 And Contain Key ue_id With Value 1

Test add bearer response should contain same Bearer ID
    [Documentation]    To add
    Response From Attach UE 1 Should Be 200
    Response From Add Bearer 2 To UE 1 Should Be 200 And Contain Key bearer_id With Value 2


# --- Remove bearer ---

Test delete correct bearer valid UE ID and Bearer ID
    [Documentation]    Pomyślne usunięcie wcześniej dodanego dedykowanego bearera.
    Response From Attach UE 1 Should Be 200
    Response From Add Bearer 2 To UE 1 Should Be 200

    Response From Delete Bearer 2 From UE 1 Should Be 200

Test delete bearer response should contain correct status
    [Documentation]    To add
    Response From Attach UE 1 Should Be 200
    Response From Delete Bearer 2 From UE 1 Should Be 200 And Contain Key status With Value bearer_deleted

Test delete bearer response should contain same UE ID
    [Documentation]    To add
    Response From Attach UE 1 Should Be 200
    Response From Delete Bearer 2 From UE 1 Should Be 200 And Contain Key ue_id With Value 1

Test delete bearer response should contain same Bearer ID
    [Documentation]    To add
    Response From Attach UE 1 Should Be 200
    Response From Delete Bearer 2 From UE 1 Should Be 200 And Contain Key bearer_id With Value 2


# --- Boundary values for bearer ---

Test add bearer lower boundary ID 1
    [Documentation]    Dodanie bearera na dolnej granicy zakresu (ID = 1).
    Response From Attach UE 1 Should Be 200
    Response From Add Bearer 1 To UE 1 Should Be 200

Test add bearer upper boundary for dedicated ID 8
    [Documentation]    Dodanie bearera na górnej granicy dla dedykowanych kanałów (ID = 8).
    Response From Attach UE 1 Should Be 200
    Response From Add Bearer 8 To UE 1 Should Be 200
