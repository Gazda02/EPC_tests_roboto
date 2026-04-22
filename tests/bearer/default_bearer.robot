*** Settings ***
Documentation   Tests of default bearer added automaticly to UE on attach
Resource        ../../resources/EPC_Common.robot
Resource        keywords/EPC_Bearers_Keywords.robot

Test Teardown   Reset EPC

*** Test Cases ***

# --- Valid ---

01 Attached UE have Bearer with ID 9
    [Documentation]    Verify that after attaching a User Equipment (UE), it automatically receives a default bearer with ID 9.
    [Tags]    bearer    default    positive

    # Arrange + Act
    Attach UE With ID 1

    # Assert
    UE With ID 1 Have Bearer With ID 9


# --- Invalid ---

02 Remove Bearer with ID 9
    [Documentation]    Verify that deleting default bearer cannot be achieved and returns 400 (Bad Request).
    [Tags]    bearer    default    negative

    # Arrange
    Attach UE With ID 1

    # Act + Assert
    Delete Bearer With ID 9 From UE With ID 1 Response With Bad Request

    # Assert
    UE With ID 1 Have Bearer With ID 9
