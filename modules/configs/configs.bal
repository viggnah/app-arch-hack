import ballerinax/mysql;

public configurable string host = ?;
public configurable int port = ?;
public configurable string username = ?;
public configurable string password = ?;
public configurable string database = ?;

public mysql:Client dbClient = check new(host, username, password, database, port, connectionPool={maxOpenConnections: 3});
