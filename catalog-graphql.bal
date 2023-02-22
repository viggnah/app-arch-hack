// Ballerina service for graphql api to fetch catalog information from mysql database
import ballerina/graphql;
import app_arch_hack.configs;
import ballerina/sql;

// Type definition for a Catalog
type CatalogItem record {
    int id;
    string title;
    string description;
    decimal price;
    string material;
};

// Defines a service class to use as an object in the GraphQL service.
service class Product {
    private final int id;
    private final string title;
    private final string description;
    private final decimal price;
    private final string material;

    function init(int id, string title, string description, decimal price, string material) {
        self.id = id;
        self.title = title;
        self.description = description;
        self.price = price;
        self.material = material;
    }

    // Each resource method becomes a field of the `Profile` type.
    resource function get id() returns int {
        return self.id;
    }
    resource function get title() returns string {
        return self.title;
    }
    resource function get description() returns string {
        return self.description;
    }
    resource function get price() returns decimal {
        return self.price;
    }
    resource function get material() returns string {
        return self.material;
    }
}

service /catalogue on new graphql:Listener(9090) {

    // This resolver returns a service type, which will be mapped to a GraphQL output object type
    // named `Product`. Each resource method in the service type is mapped to a field in the GraphQL
    // output object type.
    resource function get allProducts() returns Product[]|error {
        stream<CatalogItem, sql:Error?> catalog = configs:dbClient->query(`SELECT * FROM catalogue`);
        
        Product[] products = [];
        check from CatalogItem item in catalog
            do {
              products.push(new Product(item.id, item.title, item.description, item.price, item.material));   
            };

        return products;
    }

    function stop() returns error? {
        // Close the mysql client at the end of the service. This will close the
        // connection pool and release all the connections.
        _ = check configs:dbClient.close();
    }
}