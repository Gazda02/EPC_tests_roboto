*** Settings ***
Documentation     Business-level scenario for checking traffic on all bearers.
Resource          ../../resources/domains/traffic/EPC_Traffic_Domain.robot
Suite Setup       Scenario Starts From Clean EPC State
Suite Teardown    Scenario Starts From Clean EPC State

*** Test Cases ***
All Bearers Traffic Should Be Visible
    [Documentation]    Sprawdza, czy każdy skonfigurowany bearer może rozpocząć, pokazać i zakończyć transfer.
    Multiple Bearers Session Is Prepared
    Traffic Is Started For All Bearers
    Traffic Is Visible For All Bearers
    Traffic Is Stopped For All Bearers
    Multiple Bearers Session Is Cleaned Up

