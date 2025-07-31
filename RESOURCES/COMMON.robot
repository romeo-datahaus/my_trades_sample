*** Settings ***
Library    RequestsLibrary
Variables    ${EXECDIR}${/}variables.py



*** Variables ***
${LOGIN_PATH}                /auth/login



*** Keywords ***
Valid Login With Encrypted Password
    Create Session    api    ${BASE_URL}    verify=True
    ${headers}=    Create Dictionary    Content-Type=application/json    Accept=application/json
    ${payload}=    Set Variable    {"username": "${USERNAME}", "password": "${PASSWORD}"}
    ${response}=    POST On Session    api    ${LOGIN_PATH}    data=${payload}    headers=${headers}    expected_status=200
    Log         ${response.status_code}
    Should Be Equal As Strings    ${response.status_code}    200
    RETURN    ${response}

Get Authentication Token    
    ${response}=    Valid Login With Encrypted Password
    Set Global Variable           ${AUTH_TOKEN}                   Bearer ${response.json()['accessToken']}
