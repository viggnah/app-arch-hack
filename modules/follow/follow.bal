import ballerina/sql;
import ballerina/http;
import app_arch_hack.configs;

service /follow on new http:Listener(9090) {

    resource function get follow (string userId, string productId) returns error? {
        sql:ParameterizedQuery query = `INSERT INTO following (user_id, product_id) VALUES (${userId}, ${productId})`;
        _ = check configs:dbClient->execute(query);
    }

    resource function get unfollow (string userId, string productId) returns error? {
        sql:ParameterizedQuery query = `DELETE FROM following WHERE user_id = ${userId} AND product_id = ${productId}`;
        _ = check configs:dbClient->execute(query);
    }

    function stop() returns error? {
        // Close the mysql client at the end of the service. This will close the
        // connection pool and release all the connections.
        _ = check configs:dbClient.close();
    }
}