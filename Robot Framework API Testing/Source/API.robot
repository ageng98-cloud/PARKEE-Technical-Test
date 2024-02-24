*** Settings ***
Library    RequestsLibrary


*** Variables ***
${BASE_URL}    https://reqres.in
${payload}             {"id":2,"email":"janet.weaver@reqres.in","first_name":"Janet","last_name":"Weaver"}
${payload2}             {"id":2,"email":"janet.weaver@reqres.in","first_name":"Janet"}
${payload3}             {"id":2,"email":"","first_name":"","last_name":"Weaver"}
${payload4}             {"id":2,"email":"jane.weaver@reqres.in","first_name":"Janet","last_name":"Weaver"}

#Expect Result
${EXPECTED_id}                2
${EXPECTED_email}             janet.weaver@reqres.in
${EXPECTED_first_name}        Janet
${EXPECTED_last_name}         Weaver


*** Test Cases ***

Method POST Positive Case
    [Documentation]    Test GET request to the API
    Create Session    Base    ${BASE_URL}
    ${headers}=    Create Dictionary    Content-Type    application/json
    ${response}=    POST On Session    Base    /api/users    headers=${headers}  data=${payload}
    
    Log    ${response.status_code}
    Log    ${response.json()}
    
    #Check Status 
    Should Be Equal As Strings    ${response.status_code}    201

    #Check Field 
    ${json_response}=    Set Variable    ${response.json()}
        
    Delete All Sessions


Method POST Case Missing Request Body Fields

    [Documentation]    Test GET request to the API
    Create Session    Base    ${BASE_URL}
    ${headers}=    Create Dictionary    Content-Type    application/json
    ${response}=    POST On Session    Base    /api/users    headers=${headers}  data=${payload2}
    
    Log    ${response.status_code}
    Log    ${response.json()}
    
    Should Be Equal As Strings    ${response.status_code}    201

    ${json_response}=    Set Variable    ${response.json()}
    ${field_id}=    Set Variable    ${json_response['id']}  
    ${field_email}=    Set Variable    ${json_response['email']}  
    ${field_first}=    Set Variable    ${json_response['first_name']}  
    ${field_last}=    Set Variable    ${json_response['last_name']}  

    Should Be Equal As Strings    ${field_id}    ${EXPECTED_id}
    Should Be Equal As Strings    ${field_email}    ${EXPECTED_email}
    Should Be Equal As Strings    ${field_first}    ${EXPECTED_first_name} 
    Should Be Equal As Strings    ${field_last}    ${EXPECTED_last_name}
    Delete All Sessions


Method POST Case Missing Response

    [Documentation]    Test GET request to the API
    Create Session    Base    ${BASE_URL}
    ${headers}=    Create Dictionary    Content-Type    application/json
    ${response}=    POST On Session    Base    /api/users    headers=${headers}  data=${payload3}
    
    Log    ${response.status_code}
    Log    ${response.json()}
    
    #Check Status 
    Should Be Equal As Strings    ${response.status_code}    201

    #Check Field 
    ${json_response}=    Set Variable    ${response.json()}
    ${field_id}=    Set Variable    ${json_response['id']}  
    ${field_email}=    Set Variable    ${json_response['email']}  
    ${field_first}=    Set Variable    ${json_response['first_name']}  
    ${field_last}=    Set Variable    ${json_response['last_name']}  

    Run Keyword If    '${field_id}' == ''       Log    Warning: ID cannot be empty  
    ...    ELSE IF    '${field_email}' == ''    Log    Warning: Email cannot be empty
    ...    ELSE IF    '${field_first}' == ''    Log    Warning: First name cannot be empty
    ...    ELSE IF    '${field_last}' == ''     Log    Warning: Last name cannot be empty
    ...    ELSE    Log    Data has been successfully filled

    Delete All Sessions


Method Response Not Equals with Request
    [Documentation]    Test GET request to the API
    Create Session    Base    ${BASE_URL}
    ${headers}=    Create Dictionary    Content-Type    application/json
    ${response}=    POST On Session    Base    /api/users    headers=${headers}  data=${payload4}
    
    Log    ${response.json()}
    
    ${json_response}=    Set Variable    ${response.json()}

    ${field_id}=         Set Variable    ${json_response['id']}  
    ${field_email}=      Set Variable    ${json_response['email']}  
    ${field_first}=      Set Variable    ${json_response['first_name']}  
    ${field_last}=       Set Variable    ${json_response['last_name']}  

    Should Be Equal As Strings    ${field_id}       ${EXPECTED_id}
    Should Be Equal As Strings    ${field_email}    ${EXPECTED_email}
    Should Be Equal As Strings    ${field_first}    ${EXPECTED_first_name} 
    Should Be Equal As Strings    ${field_last}     ${EXPECTED_last_name}
    Delete All Sessions