*** Settings ***
Documentation   Tests of default bearer automatically added to UE on attach
Resource        keywords/EPC_Bearers_Keywords.robot
Resource        keywords/EPC_Bearers_HighLevel.robot

Test Teardown   Reset EPC


*** Test Cases ***

01 Attached UE has default bearer with ID 9
    [Documentation]    Verify that after attaching a UE, it automatically receives a default bearer with ID 9.
    [Tags]    bearer    default    positive

    # Arrange
    Attach UE With ID    1

    # Assert
    UE With ID Should Have Bearer    1    9


02 Removing default bearer should fail
    [Documentation]    Verify that deleting the default bearer (ID 9) is not allowed and returns 400.
    [Tags]    bearer    default    negative

    # Arrange
    Attach UE With ID    1

    # Act + Assert
    Delete Bearer With ID 9 From UE With ID 1 Should Fail With Status 400

    # Assert default bearer still exists
    UE With ID Should Have Bearer    1    9