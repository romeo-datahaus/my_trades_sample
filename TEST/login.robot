*** Settings ***
Resource      ${EXECDIR}${/}RESOURCES${/}COMMON.robot


*** Test Cases ***
Login With Encrypted Password And Get Auth Token
    Create Session    api    ${BASE_URL}    verify=True
    ${headers}=    Create Dictionary    Content-Type=application/json    Accept=application/json
    ${payload}=    Set Variable    {"username": "${USERNAME}", "password": "${PASSWORD}"}
    ${response}=    POST On Session    api    ${LOGIN_PATH}    data=${payload}    headers=${headers}    expected_status=200
    Log         ${response.status_code}
    Should Be Equal As Strings    ${response.status_code}    200
    Set Global Variable           ${AUTH_TOKEN}                   Bearer ${response.json()['accessToken']}
    # Log to Console                ${AUTH_TOKEN}

Login With Wrong Encrypted Password
    Valid Login With Encrypted Password 
    Create Session    api    ${BASE_URL}    verify=True
    ${headers}=    Create Dictionary    Content-Type=application/json    Accept=application/json
    ${payload}=    Set Variable    {"username": "${USERNAME}", "password": "yLdGwmFOkeAc8bCrrbrW7Q==:E6zIeHqruaDi6Ogk5t/IAw=="}
    ${response}=    POST On Session    api    ${LOGIN_PATH}    data=${payload}    headers=${headers}    expected_status=422
    Log         ${response.status_code}
    Should Be Equal As Strings    ${response.status_code}    422
    Should Contain                ${response.json()['message']}    Either email or password is not correct.
    # Log to Console               ${response.json()['message']}  

Login With Wrong/Non-Existing Username
    Valid Login With Encrypted Password 
    Create Session    api    ${BASE_URL}    verify=True
    ${headers}=    Create Dictionary    Content-Type=application/json    Accept=application/json
    ${payload}=    Set Variable    {"username": "romeobajadajr@gmail.com", "password": "${PASSWORD}"}
    ${response}=    POST On Session    api    ${LOGIN_PATH}    data=${payload}    headers=${headers}    expected_status=ANY
    Log         ${response.status_code}
    Should Be True    ${response.status_code} in [422, 429]
    Run Keyword If    ${response.status_code} == 422    Should Contain    ${response.json()['message']}    Either email or password is not correct
    Run Keyword If    ${response.status_code} == 429    Should Contain    ${response.json()['message']}    Too many login attempts

Login With Empty Password
    Valid Login With Encrypted Password 
    Create Session    api    ${BASE_URL}    verify=True
    ${headers}=    Create Dictionary    Content-Type=application/json    Accept=application/json
    ${payload}=    Set Variable    {"username": "${USERNAME}", "password": "${EMPTY_PASSWORD}"}
    ${response}=    POST On Session    api    ${LOGIN_PATH}    data=${payload}    headers=${headers}    expected_status=422
    Log         ${response.status_code}
    Should Be Equal As Strings    ${response.status_code}    422
    Should Contain                ${response.json()['message']}    'password': ['Missing data for required field.']

Login With Empty Fields
    Valid Login With Encrypted Password 
    Create Session    api    ${BASE_URL}    verify=True
    ${headers}=    Create Dictionary    Content-Type=application/json    Accept=application/json
    ${payload}=    Set Variable    {"username": "", "password": ""}
    ${response}=    POST On Session    api    ${LOGIN_PATH}    data=${payload}    headers=${headers}    expected_status=422
    Log         ${response.status_code}
    Should Be Equal As Strings    ${response.status_code}    422
    Should Contain                ${response.json()['message']}    'username': ['Missing data for required field.']

Login With Invalid Email Format
    Valid Login With Encrypted Password 
    Create Session    api    ${BASE_URL}    verify=True
    ${headers}=    Create Dictionary    Content-Type=application/json    Accept=application/json
    ${payload}=    Set Variable    {"username": "invalid-email", "password": "${PASSWORD}"}
    ${response}=    POST On Session    api    ${LOGIN_PATH}    data=${payload}    headers=${headers}    expected_status=ANY
    Log         ${response.status_code}
    Should Be True    ${response.status_code} in [422, 429]
    Run Keyword If    ${response.status_code} == 422    Should Contain    ${response.json()['message']}    Either email or password is not correct
    Run Keyword If    ${response.status_code} == 429    Should Contain    ${response.json()['message']}    Too many login attempts

Login With Non-Encrypted Password
    Valid Login With Encrypted Password 
    Create Session    api    ${BASE_URL}    verify=True
    ${headers}=    Create Dictionary    Content-Type=application/json    Accept=application/json
    ${payload}=    Set Variable    {"username": "${USERNAME}", "password": "plaintextpassword"}
    ${response}=    POST On Session    api    ${LOGIN_PATH}    data=${payload}    headers=${headers}    expected_status=422
    Log         ${response.status_code}
    Should Be Equal As Strings    ${response.status_code}    422
    Should Contain                ${response.json()['message']}    not enough values to unpack (expected 2, got 1)

Login With Invalid Encrypted Format
    Valid Login With Encrypted Password 
    Create Session    api    ${BASE_URL}    verify=True
    ${headers}=    Create Dictionary    Content-Type=application/json    Accept=application/json
    ${payload}=    Set Variable    {"username": "${USERNAME}", "password": "corrupted:encrypted:format"}
    ${response}=    POST On Session    api    ${LOGIN_PATH}    data=${payload}    headers=${headers}    expected_status=422
    Log         ${response.status_code}
    Should Be Equal As Strings    ${response.status_code}    422
    Should Contain                ${response.json()['message']}    too many values to unpack (expected 2)

# Login With Rate Limiting
#     Login With Encrypted Password And Get Auth Token
#     Create Session    api    ${BASE_URL}    verify=True
#     ${headers}=    Create Dictionary    Content-Type=application/json    Accept=application/json
#     ${payload}=    Set Variable    {"username": "${USERNAME}", "password": "${WRONG_PASSWORD}"}
#     # Attempt multiple login failures to trigger rate limiting
#     FOR    ${i}    IN RANGE    1    6
#         ${response}=    POST On Session    api    ${LOGIN_PATH}    data=${payload}    headers=${headers}    expected_status=422
#         Log         Attempt ${i}: ${response.status_code}
#         Should Be Equal As Strings    ${response.status_code}    422
#     END
#     # The 6th attempt might trigger rate limiting (429) or continue with 422
#     ${response}=    POST On Session    api    ${LOGIN_PATH}    data=${payload}    headers=${headers}    expected_status=ANY
#     Log         Final attempt: ${response.status_code}
#     Should Be True    ${response.status_code} in [422, 429]