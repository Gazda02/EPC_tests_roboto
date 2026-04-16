*** Settings ***
Documentation     Business-level negative scenarios for checking traffic with invalid identifiers.
Resource          ../../resources/domains/traffic/EPC_Negative_Traffic_Domain.robot
Suite Setup       Negative Traffic Scenario Starts From Clean EPC State
Suite Teardown    Negative Traffic Scenario Starts From Clean EPC State

*** Test Cases ***
01 Check Traffic With Invalid UE ID Should Be Rejected
    [Documentation]    Sprawdza, czy próba odczytu traffic dla nieistniejącego UE jest odrzucana.
    Traffic Check With Invalid UE ID Should Be Rejected

02 Check Traffic With Invalid Bearer ID Should Be Rejected
    [Documentation]    Sprawdza, czy próba odczytu traffic dla nieistniejącego bearera jest odrzucana.
    Valid UE Is Prepared For Invalid Bearer Check
    Traffic Check With Invalid Bearer ID Should Be Rejected

