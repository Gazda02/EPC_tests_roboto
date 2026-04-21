# layer 1.5 — shared high-level test keywords

*** Settings ***
Resource    ../../../resources/EPC_API.robot
Resource    ../../../resources/EPC_Assertions.robot
Resource    EPC_Bearers_Keywords.robot

*** Keywords ***

# --- ADD BEARER ---

Add Bearer With ID ${bearer_id} To UE With ID ${ue_id} Should Succeed
    [Documentation]    High-level keyword: adds bearer and verifies success status.
    ${resp}=    Add Bearer To UE    ${ue_id}    ${bearer_id}
    Response Status Should Be    ${resp}    200


# --- REMOVE BEARER ---

Delete Bearer With ID ${bearer_id} From UE With ID ${ue_id} Should Fail With Status 400
    [Documentation]    High-level keyword: verifies that deleting bearer returns 400.
    ${resp}=    Remove Bearer From UE    ${ue_id}    ${bearer_id}
    Response Status Should Be    ${resp}    400
