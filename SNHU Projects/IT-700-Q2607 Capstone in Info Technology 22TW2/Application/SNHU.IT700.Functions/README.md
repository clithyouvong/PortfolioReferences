###DESCRIPTION
Use this API to get the values for the website


###USAGE

METHOD: GET
URL: http://localhost:7105/api/GetSearchResults
PARAMETERS:
{
    //no parameters
}
HEADERS:
{
    //no headers
}
BODY:
{
    "FirstName":"",
    "LastName":"",
    "City":"",
    "StateId": 0,
    "CountryId":0,
    "DateLostStart": "1900-01-01",
    "DateLostEnd": "1900-01-01",
    "AgeStart":0,
    "AgeEnd":0,
    "GenderId": 0,
    "EthnicityId":0,
    "HairColorId":0,
    "EyeColorId":0
}


METHOD:POST
URL: http://localhost:7105/api/PostReportResults
PARAMETERS:
{
    //no parameters
}
HEADERS:
{
    //no headers
}
BODY:
{
    "FirstName":"bar",
    "LastName":"foo",
    "City":"Penguinville",
    "StateId": 1,
    "CountryId": 1,
    "GenderId": 1,
    "EthnicityId": 1,
    "HairColorId": 1,
    "EyeColorId": 1,
    "Description": "fdfdsa fadfda fdf fa fadsfdfew wfew vdvrgtrw vsdfdsres gsdfadsf dasfaefe wfeawfewfaewf",
    "Age": 1,
    "Phone1": "(111) 222 - 3333",
    "Phone2": "(111) 222 - 3333",
    "Phone3": "(111) 222 - 3333",
    "Email1": "sender@domain.com",
    "Email2": "sender@domain.com",
    "Email3": "sender@domain.com",
    "DateLost":"1901-01-01"
}


METHOD: GET
URL: http://localhost:7105/api/GetSearchFilters
PARAMETERS:
{
    //no parameters
}
HEADERS:
{
    //no headers
}
BODY:
{
    //no body required
}


METHOD: GET
URL: http://localhost:7105/api/GetReportFilters
PARAMETERS:
{
    //no parameters
}
HEADERS:
{
    //no headers
}
BODY:
{
    //no body required
}


METHOD: POST
URL: http://localhost:7105/runtime/webhooks/EventGrid?functionName=PostForumTopic
PARAMETERS:
{
    //no parameters
}
HEADERS:
{
    "aeg-event-type" : "Notification", 
    "Content-type" : "application/json"
}
BODY:
{
    [ 
        { 
            "topic": "SNHU-IT700-EventGrid-EastUS2", 
            "subject": "PostForumTopic", 
            "id": "00000000-0000-0000-0000-000000000000", 
            "eventType": "PostForumTopic", 
            "eventTime": "2023-01-05T00:00:00", 
            "data": {
                "Id":0,
                "Topic":"Searching for missing John Doe",
                "DateCreatedBy" : 1004            
            }, 
            "dataVersion": "dev", 
            "metadataVersion": "test" 
        } 
    ]
}


METHOD: POST
URL: http://localhost:7105/runtime/webhooks/EventGrid?functionName=PostForumPost
PARAMETERS:
{
    //no parameters
}
HEADERS:
{
    "aeg-event-type" : "Notification", 
    "Content-type" : "application/json"
}
BODY:
{
    [ 
        { 
            "topic": "SNHU-IT700-EventGrid-EastUS2", 
            "subject": "PostForumPost", 
            "id": "00000000-0000-0000-0000-000000000000", 
            "eventType": "PostForumPost", 
            "eventTime": "2023-01-05T00:00:00", 
            "data": {
                "Id":0,
                "ForumTopicId": 3,
                "Post":"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc nec hendrerit sapien. Nullam at tortor dignissim, maximus mi non, viverra urna. Nam et augue ante. Integer sollicitudin tincidunt ligula, eget consequat felis posuere eu. Proin viverra, odio in rutrum porttitor, massa metus ornare purus, et venenatis justo eros at urna. Nulla aliquam leo quis velit eleifend eleifend. Sed feugiat quam ac est varius, non luctus velit blandit.",
                "DateCreatedBy" : 1004            
            }, 
            "dataVersion": "dev", 
            "metadataVersion": "test" 
        } 
    ]
}


METHOD: GET
URL: http://localhost:7105/api/GetForums
PARAMETERS:
{
    //no parameters
}
HEADERS:
{
    //no headers
}
BODY:
{
    //no body required
}


METHOD: GET
URL: http://localhost:7105/api/GetForumPosts?ID=3
PARAMETERS:
{
    ID : int <- ForumTopicId
}
HEADERS:
{
    //no headers
}
BODY:
{
    //no body required
}