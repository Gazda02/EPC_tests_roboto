*** Settings ***
Resource          ../../EPC_API.robot
Resource          ../../EPC_Assertions.robot

*** Variables ***
@{ALL_BEARERS}    5    6    7

*** Keywords ***
Single Bearer Session Is Prepared
    ${ue_resp}=    Attach UE    ${UE_VALID}
    Response Status Should Be    ${ue_resp}    201
    ${bearer_resp}=    Add Bearer    ${UE_VALID}    ${BEARER_VALID}
    Response Status Should Be    ${bearer_resp}    201

Traffic Is Started For Single Bearer
    ${start_resp}=    Start Traffic    ${UE_VALID}    ${BEARER_VALID}    ${TRAFFIC_VALID}
    Response Status Should Be    ${start_resp}    201

Traffic Is Visible For Single Bearer
    ${traffic_resp}=    Check Traffic    ${UE_VALID}    ${BEARER_VALID}
    Response Status Should Be    ${traffic_resp}    200
    Response Should Contain Message    ${traffic_resp}    ${TRAFFIC_VALID}

Traffic Is Stopped For Single Bearer
    ${stop_resp}=    Stop Traffic    ${UE_VALID}    ${BEARER_VALID}
    Response Status Should Be    ${stop_resp}    200

Single Bearer Session Is Cleaned Up
    ${delete_resp}=    Delete Bearer    ${UE_VALID}    ${BEARER_VALID}
    Response Status Should Be    ${delete_resp}    200
    ${detach_resp}=    Detach UE    ${UE_VALID}
    Response Status Should Be    ${detach_resp}    200

Multiple Bearers Session Is Prepared
    ${ue_resp}=    Attach UE    ${UE_VALID}
    Response Status Should Be    ${ue_resp}    201
    FOR    ${bearer_id}    IN    @{ALL_BEARERS}
        ${bearer_resp}=    Add Bearer    ${UE_VALID}    ${bearer_id}
        Response Status Should Be    ${bearer_resp}    201
    END

Traffic Is Started For All Bearers
    FOR    ${bearer_id}    IN    @{ALL_BEARERS}
        ${start_resp}=    Start Traffic    ${UE_VALID}    ${bearer_id}    ${TRAFFIC_VALID}
        Response Status Should Be    ${start_resp}    201
    END

Traffic Is Visible For All Bearers
    FOR    ${bearer_id}    IN    @{ALL_BEARERS}
        ${traffic_resp}=    Check Traffic    ${UE_VALID}    ${bearer_id}
        Response Status Should Be    ${traffic_resp}    200
        Response Should Contain Message    ${traffic_resp}    ${TRAFFIC_VALID}
    END

Traffic Is Stopped For All Bearers
    FOR    ${bearer_id}    IN    @{ALL_BEARERS}
        ${stop_resp}=    Stop Traffic    ${UE_VALID}    ${bearer_id}
        Response Status Should Be    ${stop_resp}    200
    END

Multiple Bearers Session Is Cleaned Up
    FOR    ${bearer_id}    IN    @{ALL_BEARERS}
        ${delete_resp}=    Delete Bearer    ${UE_VALID}    ${bearer_id}
        Response Status Should Be    ${delete_resp}    200
    END
    ${detach_resp}=    Detach UE    ${UE_VALID}
    Response Status Should Be    ${detach_resp}    200

Scenario Starts From Clean EPC State
    Reset EPC



