*** Settings ***
Documentation    Tests verifying that resetting the EPC simulator clears all state and succeeds in both idle and active conditions.
Resource         ../../resources/EPC_Common.robot
Resource         ../bearer/keywords/EPC_Bearers_HighLevel.robot

Test Teardown    Reset EPC


*** Test Cases ***

01 Reset simulator from idle state
    [Documentation]    Verify that resetting the simulator when no UE is attached succeeds and leaves the system empty.
    [Tags]    reset    simulator    positive

    # Arrange
    Reset EPC

    # Act
    Reset EPC Should Succeed

    # Assert
    Simulator Should Have No UEs


02 Reset simulator from active state
    [Documentation]    Verify that resetting the simulator while UE and bearers exist succeeds and clears all state.
    [Tags]    reset    simulator    positive    integration

    # Arrange
    Attach UE With ID    1
    Add Bearer With ID 2 To UE With ID 1 Should Succeed

    # Act
    Reset EPC Should Succeed

    # Assert
    Simulator Should Have No UEs


03 Reset simulator should remove all bearers for all UEs
    [Documentation]    Verify that resetting the simulator removes all UEs and all their bearers.
    [Tags]    reset    simulator    cleanup    integration

    # Arrange
    Attach UE With ID    1
    Add Bearer With ID 2 To UE With ID 1 Should Succeed

    # Act
    Reset EPC Should Succeed

    # Assert
    Simulator Should Have No UEs


*** Keywords ***

    
Simulator Should Have No UEs
    ${resp}=    Get All UEs
    ${json}=    Set Variable    ${resp.json()}
    ${count}=    Get Length    ${json["ues"]}
    Should Be Equal As Integers    ${count}    0