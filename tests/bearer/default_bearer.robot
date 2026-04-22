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



03 Adding bearer 9 should fail because it is default
    [Documentation]    Verify that adding bearer 9 fails because it already exists by default.
    [Tags]    bearer    default    negative

    Attach UE With ID 1
    Add Bearer With ID 9 To UE With ID 1 Response With Bad Request
    UE With ID 1 Have Bearer With ID 9

04 Default bearer 9 behavior for a range of valid UE IDs
    [Documentation]    Verify that for a range of valid UE IDs (1–100), each UE automatically receives default bearer 9, and that bearer 9 cannot be added or removed.
    [Tags]    bearer    default    range    positive    negative

    Verify Default Bearer 9 Behavior For UE Range 1 To 100


*** Keywords ***

Verify Default Bearer 9 Behavior For UE Range ${ue_start} To ${ue_end}
    [Documentation]    For each UE in the given range, verifies that default bearer 9 exists, cannot be added, and cannot be removed.

    ${ue_start}=    Convert To Integer    ${ue_start}
    ${ue_end}=      Convert To Integer    ${ue_end}

    FOR    ${ue_id}    IN RANGE    ${ue_start}    ${ue_end + 1}
        Attach UE With ID ${ue_id}

        # Default bearer must exist
        UE With ID ${ue_id} Have Bearer With ID 9

        # Adding bearer 9 must fail
        Add Bearer With ID 9 To UE With ID ${ue_id} Response With Bad Request

        # Removing bearer 9 must fail
        Delete Bearer With ID 9 From UE With ID ${ue_id} Response With Bad Request

        # Still exists
        UE With ID ${ue_id} Have Bearer With ID 9
    END