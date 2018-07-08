# Ballerina--Twilio-Database-project

This application is aimed at sending notification messages in the form of a SMS to remind patients of their medical consultation appointments. 

I have made use of:
> Database integration with Ballerina
> wso2/twilio api for Ballerina

In order to make this application work:

>Get your twilio credentials as stated here: 
https://central.ballerina.io/wso2/twilio

>Get your Database credentials.

>Put them in the relevant places in the files as indicated

>I have  included an export of the table structure needed. Go to your 
http://localhost/phpmyadmin/ and import this file.

>Fill all the fields appropriately.

Now you are all set up to run the project. To proceed please run the commands below:

Twilio-Database-Project/guide$ ballerina run messageService.bal

then,

Twilio-Database-Project/guide$ ballerina run dataService

and finally send a request to databseService.bal using curl:

Twilio-Database-Project/guide$ curl -v  "http://localhost:9090/records/employee/"



