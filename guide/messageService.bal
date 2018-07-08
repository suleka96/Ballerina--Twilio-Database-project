// A system package containing protocol access constructs
// Package objects referenced with 'http:' in code
import wso2/twilio;
import ballerina/config;  
import ballerina/http;
import ballerina/io;
import ballerina/log;

endpoint twilio:Client twilioClient {
    accountSId: config:getAsString("TWILIO_ACCOUNT_SID",default = ""),
    authToken: config:getAsString("TWILIO_AUTH_TOKEN",default = "")
};

documentation {
   A service endpoint represents a listener.
}
endpoint http:Listener listener {
    port:8080
};

documentation {
   A service is a network-accessible API
   Advertised on '/hello', port comes from listener endpoint
}

 @http:ServiceConfig {
   basePath: "/"
}
service<http:Service> sendMessage bind listener {

    @http:ResourceConfig {
        methods: ["POST"],
        path: "/twillo"
    }

    documentation {
       A resource is an invokable API method
       Accessible at '/hello/sayHello
       'caller' is the client invoking this resource 

       P{{caller}} Server Connector
       P{{request}} Request 
    }

    
    sendSMS (endpoint caller, http:Request request) {

        // get the req from the database service
        json req = check request.getJsonPayload();
        json payload = {};

        //this is to store the values in the params of the request
        var message = check <string>req.msg;
        var phoneNumber = check <string>req.number;

        http:Response response = new;

        //to send the message
        var details = twilioClient->sendSms("+16012079387", phoneNumber, message);
        match details {
        twilio:SmsResponse smsResponse => {
            if (smsResponse.sid != "") {
                log:printDebug("Twilio Connector -> SMS successfully sent to " + phoneNumber);
                payload = {replymsg: "Message was sent successfully"};
            }
        }
        twilio:TwilioError err => {
            log:printDebug("Twilio Connector -> SMS failed sent to " + phoneNumber);
            log:printError(err.message);
            payload = {replymsg: "Message was not sent successfully"};
        }
    }
        
        response.setJsonPayload(payload);
        _ = caller -> respond(response);
    }
}