import ballerina/io;
import ballerina/sql;
// import ballerina/time;
import ballerinax/mysql;

// Defines a record to load the query result schema as shown below in the
// 'getDataWithTypedQuery' function. In this example, all columns of the 
// Employee table will be loaded. Therefore, the `Employee` record will be 
// created with all the columns. The column name of the result and the 
// defined field name of the record will be matched case insensitively.
type Employee record {|
    int EmployeeId;
    string lastName;
    string firstName;
    // Date dob;
    string email;
    int depName;
|};

public function main() returns error? {
    // Runs the prerequisite setup for the example.
    check beforeExample();

    // Initializes the MySQL client.
    mysql:Client mysqlClient = check new (user = "root", 
            password = "12345", database = "org_test.Employee");

    // Select the rows in the database table via the query remote operation.
    // The result is returned as a stream and the elements of the stream can
    // be either a record or an error. The name and type of the attributes 
    // within the record from the `resultStream` will be automatically 
    // identified based on the column name and type of the query result.
    stream<record {}, error> resultStream = 
            mysqlClient->query(`SELECT * FROM Employees`);

    // If there is any error during the execution of the SQL query or
    // iteration of the result stream, the result stream will terminate and
    // return the error.
    error? e = resultStream.forEach(function(record {} result) {
        io:println("Full Employee details: ", result);
    });

    // The result of the count operation is provided as a record stream.
    stream<record {}, error> resultStream2 = 
            mysqlClient->query(`SELECT COUNT(*) AS total FROM Employees`);

    // Since the above count query will return only a single row,
    // the `next()` operation is sufficient to retrieve the data.
    record {|record {} value;|}|error? result = resultStream2.next();
    // Checks the result and retrieves the value for the total.
    if result is record {|record {} value;|} {
        io:println("Total rows in Employee table : ", result.value["total"]);
    }

    // In general cases, the stream will be closed automatically
    // when the stream is fully consumed or any error is encountered.
    // However, in case if the stream is not fully consumed, the stream
    // should be closed specifically.
    error? er = resultStream.close();

    // If a `Employee` stream type is defined when calling the query method,
    // The result is returned as a `Employee` record stream and the elements
    // of the stream can be either a `Employee` record or an error.
    stream<Employee, error> EmployeeStream = 
        mysqlClient->query(`SELECT * FROM Employees`);

    // Casts the generic record type to the `Employee` stream type.
    // stream<Employee, sql:Error> EmployeeStream = 
    //     <stream<Employee, sql:Error>>resultStream3;

    // Iterates the Employee stream.
    error? e2 = EmployeeStream.forEach(function(Employee Employee) {
        io:println("Full Employee details: ", Employee);
    });

    // Performs the cleanup after the example.
    check afterExample(mysqlClient);
}

// Initializes the database as a prerequisite to the example.
function beforeExample() returns sql:Error? {
    mysql:Client mysqlClient = check new (user = "root", password = "12345");

    // Creates a database.
    sql:ExecutionResult result = 
        check mysqlClient->execute(`CREATE DATABASE org_test`);

    // Creates a table in the database.
    result = check mysqlClient->execute(`CREATE TABLE org_test.Employees
            (EmployeeId INTEGER NOT NULL AUTO_INCREMENT, firstName
            VARCHAR(300), lastName  VARCHAR(300), registrationID INTEGER,
            creditLimit DOUBLE, email  VARCHAR(300),
            PRIMARY KEY (EmployeeId))`);

    // Adds the records to the newly-created table.
    result = check mysqlClient->execute(`INSERT INTO org_test.Employees
            (firstName, lastName, registrationID,creditLimit,email) VALUES
            ('Peter','Stuart', 1, 5000.75, 'USA')`);
    result = check mysqlClient->execute(`INSERT INTO org_test.Employees
            (firstName, lastName, registrationID,creditLimit,email) VALUES
            ('Dan', 'Brown', 2, 10000, 'UK')`);

    check mysqlClient.close();
}

// Cleans up the database after running the example.
function afterExample(mysql:Client mysqlClient) returns sql:Error? {
    // Cleans the database.
    sql:ExecutionResult result = 
            check mysqlClient->execute(`DROP DATABASE org_test`);
    // Closes the MySQL client.
    check mysqlClient.close();
}
