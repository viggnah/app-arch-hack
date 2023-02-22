import ballerina/sql;
import ballerina/http;
import ballerinax/mysql.driver as _;
import ballerinax/mysql;

configurable string host = ?;
configurable int port = ?;
configurable string username = ?;
configurable string password = ?;
configurable string database = ?;

service /follow on new http:Listener(9090) {

    private final mysql:Client dbClient;

    function init() returns error? {
        // Initiate the mysql client at the start of the service. This will be used
        // throughout the lifetime of the service.
        self.dbClient = check new(host, username, password, database, port, connectionPool={maxOpenConnections: 3});
    }

    resource function get follow (string userId, string productId) returns error? {
        sql:ParameterizedQuery query = `INSERT INTO following (user_id, product_id) VALUES (${userId}, ${productId})`;
        _ = check self.dbClient->execute(query);
    }

    resource function get unfollow (string userId, string productId) returns error? {
        sql:ParameterizedQuery query = `DELETE FROM following WHERE user_id = ${userId} AND product_id = ${productId}`;
        _ = check self.dbClient->execute(query);
    }

    function stop() returns error? {
        // Close the mysql client at the end of the service. This will close the
        // connection pool and release all the connections.
        _ = check self.dbClient.close();
    }
}