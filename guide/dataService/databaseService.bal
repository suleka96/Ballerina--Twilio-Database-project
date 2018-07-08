import ballerina/sql;
import ballerina/mysql;
import ballerina/log;
import ballerina/http;
import ballerina/config;
import ballerina/io;
import ballerina/time;



// Create SQL endpoint to MySQL database
endpoint mysql:Client employeeDB {
    host: config:getAsString("DATABASE_HOST", default = ""),
    port: config:getAsInt("DATABASE_PORT", default = ),
    name: config:getAsString("DATABASE_NAME", default = ""),
    username: config:getAsString("DATABASE_USERNAME", default = ""),
    password: config:getAsString("DATABASE_PASSWORD", default = ""),
    dbOptions: { useSSL: false }
};

//create endpoint to twillo service
endpoint http:Client twillo{
    url: "http://localhost:8080"
};

endpoint http:Listener listener {
    port: 9090
};

// Service for the patient data service
@http:ServiceConfig {
    basePath: "/records"
}
service<http:Service> PatientData bind listener {

    @http:ResourceConfig {
        methods: ["GET"],
        path: "/employee/"
    }
    retrievePatientDataResource(endpoint httpConnection, http:Request request) {

         //getting current date
        time:Time currentTime = time:currentTime();
        string customdateString = currentTime.format("dd-MM-yyyy");

        // Initialize an empty http response message to send response to the terminal
        http:Response response;

        // Initialize an empty request to send request to tillo service
        http:Request req = new;

        // Invoke retrieveRecords function to retrieve data from Mymysql database
        var data = retrieveRecords("not",customdateString);
        io:println(data);

        foreach retrievedRecord in data {
             io:println("inside for each");


            match retrievedRecord {
                json extractedRecord =>{
                    string appointmentId = check <string>extractedRecord.AppointmentId;
                    string patientName = check <string>extractedRecord.PatientName;
                    string nameOfDocor = check <string>extractedRecord.NameOfDocor;
                    string arrivalTime = check <string>extractedRecord.ArrivalTime;

                    var updateStatus = updateRecord("sent",appointmentId);

                    if (updateStatus["Status"].toString() == "updated") {

                        string telephoNo = check <string>extractedRecord.PatientTelephoneNo;
                        string message = patientName+", You have an appointment TODAY. Doctor: "+nameOfDocor+ ". Arrival time: "+arrivalTime+".";
                        io:println(message);
                        json jsonMsgTillo = {"number": telephoNo, "msg": message };
                        req.setJsonPayload(jsonMsgTillo);

                        //send the request to twillo service and get the response from it and store it in ping variable
                        var ping= twillo->post("/twillo",req);

                        // check the response received from twitter service
                        match ping {
                        // get the response from twillo    
                            http:Response resp => {
                                //and store it in the msg variable
                                var msg = resp.getJsonPayload();

                                //check the msg (response)
                                match msg {
                                    //pass the value in the msg variable to reply variable
                                    json sentmsg => {
                                        //create a response to send it to the terminal
                                        var resultMessage = sentmsg["replymsg"].toString();
                                        //send the response to the terminal
                                        io:println(resultMessage);     
                                    }
                                    //exception for the msg reponse
                                    error err => {
                                        log:printError(err.message, err = err);
                                    }
                                }
                            }
                            //exception for the ping response
                            error err => { log:printError(err.message, err = err); }
                        }

                    }

                    else {
                        log:printError(updateStatus["Error"].toString());
                    }
                }

            }
        }

    var finalMessage = "execution done!";
    response.setJsonPayload(finalMessage);
     _ = httpConnection->respond(response);  

        
    }
}


public function retrieveRecords(string status, string date) returns (json) {
    json jsonReturnValue;
    string sqlStringRetieve = "SELECT PatientInfo.PatientName,PatientInfo.PatientTelephoneNo,AppointmentInfo.AppointmentDate,AppointmentInfo.ArrivalTime,AppointmentInfo.NameOfDocor,AppointmentInfo.AppointmentId FROM PatientInfo INNER JOIN AppointmentInfo ON AppointmentInfo.PatientId = PatientInfo.PatientId WHERE AppointmentInfo.MsgStatus = ? AND AppointmentInfo.AppointmentDate = ?";

    // Retrieve employee data by invoking select action defined in ballerina sql client
    var ret1 = employeeDB->select(sqlStringRetieve,(), status, date);
    match ret1 {
        table dataTable => {
            // Convert the sql data table into JSON using type conversion
            jsonReturnValue = check <json>dataTable;
            io:println(jsonReturnValue);
        }
        error err => {
            jsonReturnValue = { "Status": "Data Not Found", "Error": err.message };
        }
    }
     return jsonReturnValue;
}

public function updateRecord(string status, string id) returns (json) {
     json updateStatus = {};
    string sqlStringUpdate = "UPDATE AppointmentInfo SET MsgStatus = ? WHERE AppointmentId  = ?";
    // Update existing data by invoking update action defined in ballerina sql client
    var ret2 = employeeDB->update(sqlStringUpdate, status, id);
    match ret2 {
        int updateRowCount => {
            if (updateRowCount > 0) {
                updateStatus = { "Status": "updated" };
            }
            else {
                updateStatus = { "Status": "Data Not Updated"};
            }
        }
        error err => {
            updateStatus = { "Error": err.message };
        }
    }

    return updateStatus;
}
   




