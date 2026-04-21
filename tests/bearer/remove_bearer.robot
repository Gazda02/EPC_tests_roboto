*** Settings ***
Documentation    Tests of removing bearers
Resource         keywords/EPC_Bearers_Keywords.robot
Resource         keywords/EPC_Bearers_HighLevel.robot

Test Teardown    Reset EPC


*** Test Cases ***

# --- Valid ---

01 Remove active bearer
    [Documentation]    Verify successful deletion of a previously added dedicated bearer.

    # Arrange
    Attach UE With ID    1
    Add Bearer With ID 2 To UE With ID 1 Should Succeed

    # Act
    Delete Bearer With ID 2 From UE With ID 1 Should Succeed

    # Assert
    UE With ID Should Not Have Bearer    1    2

02 Remove inactive bearer
    [Documentation]    Verify that removing an inactive bearer succeeds and the bearer is no longer present.

    # Arrange
    Attach UE With ID    1
    Add Bearer With ID 2 To UE With ID 1 Should Succeed
    # tutaj w przyszłości możemy dodać np. End Traffic, jeśli będzie scenariusz z aktywacją

    # Act
    Delete Bearer With ID 2 From UE With ID 1 Should Succeed

    # Assert
    UE With ID Should Not Have Bearer    1    2


03 Remove bearer returns correct values
    [Documentation]    Verify that deleting a bearer returns correct ue_id, bearer_id and status.

    # Arrange
    Attach UE With ID    1
    Add Bearer With ID 2 To UE With ID 1 Should Succeed

    # Act + Assert
    Delete Bearer With ID 2 From UE With ID 1 Should Return Correct Values


# --- Invalid ---

04 Remove non-existing bearer
    [Documentation]    Verify that deleting a bearer that does not exist returns 400.

    # Arrange
    Attach UE With ID    1

    # Act + Assert
    Delete Bearer With ID 5 From UE With ID 1 Should Fail With Status 400


05 Remove bearer without ID
    [Documentation]    Verify that deleting a bearer without providing an ID returns 422.

    # Arrange
    Attach UE With ID    1

    # Act + Assert
    Delete Bearer Without ID From UE With ID 1 Should Fail With Status 422


06 Remove default bearer should fail
    [Documentation]    Verify that removing the default bearer (ID 9) is not allowed and returns 400.

    # Arrange
    Attach UE With ID    1
    # default bearer 9 is created automatically on attach

    # Act + Assert
    Delete Bearer With ID 9 From UE With ID 1 Should Fail With Status 400


*** Keywords ***


Delete Bearer With ID ${bearer_id} From UE With ID ${ue_id} Should Succeed
    ${resp}=    Remove Bearer From UE    ${ue_id}    ${bearer_id}
    Response Status Should Be    ${resp}    200


Delete Bearer With ID ${bearer_id} From UE With ID ${ue_id} Should Return Correct Values
    ${resp}=    Remove Bearer From UE    ${ue_id}    ${bearer_id}
    Response JSON Field Should Be    ${resp}    ue_id        ${ue_id}
    Response JSON Field Should Be    ${resp}    bearer_id    ${bearer_id}
    Response JSON Field Should Be    ${resp}    status       bearer_deleted


Delete Bearer Without ID From UE With ID ${ue_id} Should Fail With Status 422
    ${resp}=    Remove Bearer From UE    ${ue_id}    ''
    Response Status Should Be    ${resp}    422