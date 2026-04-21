*** Settings ***
Documentation   Tests of adding bearers
Resource        keywords/EPC_Bearers_Keywords.robot
Resource        keywords/EPC_Bearers_HighLevel.robot

Test Teardown   Reset EPC

*** Test Cases ***

# --- Valid ---

01 Add bearer with valid UE ID and bearer ID
    [Documentation]    Verify that a new bearer can be added to an attached UE when valid UE ID and bearer ID are provided.

    # Arrange
    Attach UE With ID    1

    # Act
    Add Bearer With ID 2 To UE With ID 1 Should Succeed

    # Assert
    UE With ID Should Have Bearer    1    2


02 Add bearer response contains correct IDs and status
    [Documentation]    Verify that the response from adding a bearer contains the correct UE ID, bearer ID and status.

    # Arrange
    Attach UE With ID    1

    # Act + Assert
    Add Bearer With ID 2 To UE With ID 1 Should Return Correct Values


03 Add bearer lower boundary ID
    [Documentation]    Verify adding a bearer with the lowest allowed ID (1).

    # Arrange
    Attach UE With ID    1

    # Act
    Add Bearer With ID 1 To UE With ID 1 Should Succeed

    # Assert
    UE With ID Should Have Bearer    1    1


04 Add bearer upper boundary ID
    [Documentation]    Verify adding a bearer with the highest allowed ID (8).

    # Arrange
    Attach UE With ID    1

    # Act
    Add Bearer With ID 8 To UE With ID 1 Should Succeed

    # Assert
    UE With ID Should Have Bearer    1    8


# --- Invalid ---

05 Add bearer under boundary ID
    [Documentation]    Verify that adding a bearer with ID below allowed range (0) fails with 422.

    # Arrange
    Attach UE With ID    1

    # Act
    Add Bearer With ID 0 To UE With ID 1 Should Fail With Status 422

    # Assert
    UE With ID Should Not Have Bearer    1    0


06 Add bearer above boundary ID
    [Documentation]    Verify that adding a bearer with ID above allowed range (10) fails with 422.

    # Arrange
    Attach UE With ID    1

    # Act
    Add Bearer With ID 10 To UE With ID 1 Should Fail With Status 422

    # Assert
    UE With ID Should Not Have Bearer    1    10


07 Add bearer under boundary ID returns correct error type
    [Documentation]    Verify that adding bearer with ID below minimum returns 'greater_than_equal'.

    # Arrange
    Attach UE With ID    1

    # Act + Assert
    Add Bearer With ID 0 To UE With ID 1 Should Return Error Type greater_than_equal



08 Add bearer above boundary ID returns correct error type
    [Documentation]    Verify that adding bearer with ID above maximum returns 'less_than_equal'.

    # Arrange
    Attach UE With ID    1

    # Act + Assert
    Add Bearer With ID 10 To UE With ID 1 Should Return Error Type less_than_equal


09 Add existing bearer
    [Documentation]    Verify that adding an already existing bearer returns 400.

    # Arrange
    Attach UE With ID    1
    Add Bearer With ID 2 To UE With ID 1 Should Succeed

    # Act + Assert
    Add Bearer With ID 2 To UE With ID 1 Should Fail With Status 400


10 Add bearer to non-existing UE
    [Documentation]    Verify that adding a bearer to a non-attached UE returns 400.

    # Arrange
    Reset EPC

    # Act + Assert
    Add Bearer With ID 2 To UE With ID 1 Should Fail With Status 400


11 Add bearer without ID
    [Documentation]    Verify that adding a bearer without ID returns 422.

    # Arrange
    Attach UE With ID    1

    # Act + Assert
    Add Bearer Without ID To UE With ID 1 Should Fail With Status 422


*** Keywords ***

Add Bearer With ID ${bearer_id} To UE With ID ${ue_id} Should Return Correct Values
    ${resp}=    Add Bearer To UE    ${ue_id}    ${bearer_id}
    Response JSON Field Should Be    ${resp}    ue_id        ${ue_id}
    Response JSON Field Should Be    ${resp}    bearer_id    ${bearer_id}
    Response JSON Field Should Be    ${resp}    status       bearer_added

Add Bearer With ID ${bearer_id} To UE With ID ${ue_id} Should Return Error Type ${error_type}
    ${resp}=    Add Bearer To UE    ${ue_id}    ${bearer_id}
    ${json}=    Set Variable    ${resp.json()}
    ${actual_type}=    Set Variable    ${json["detail"][0]["type"]}
    Should Be Equal As Strings    ${actual_type}    ${error_type}

Add Bearer With ID ${bearer_id} To UE With ID ${ue_id} Should Fail With Status 400
    ${resp}=    Add Bearer To UE    ${ue_id}    ${bearer_id}
    Response Status Should Be    ${resp}    400

Add Bearer With ID ${bearer_id} To UE With ID ${ue_id} Should Fail With Status 422
    ${resp}=    Add Bearer To UE    ${ue_id}    ${bearer_id}
    Response Status Should Be    ${resp}    422

Add Bearer Without ID To UE With ID ${ue_id} Should Fail With Status 422
    ${resp}=    Add Bearer To UE    ${ue_id}    ''
    Response Status Should Be    ${resp}    422