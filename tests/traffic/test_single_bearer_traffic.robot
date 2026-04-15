*** Settings ***
Documentation     Business-level scenario for checking traffic on one bearer.
Resource          ../../resources/domains/traffic/EPC_Traffic_Domain.robot
Suite Setup       Scenario Starts From Clean EPC State
Suite Teardown    Scenario Starts From Clean EPC State

*** Test Cases ***
Single Bearer Traffic Should Be Visible
    [Documentation]    Sprawdza, czy jeden użytkownik i jeden bearer mogą rozpocząć, pokazać i zakończyć transfer.
    Single Bearer Session Is Prepared
    Traffic Is Started For Single Bearer
    Traffic Is Visible For Single Bearer
    Traffic Is Stopped For Single Bearer
    Single Bearer Session Is Cleaned Up


