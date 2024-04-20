import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import {
  DynamoDBDocumentClient,
  ScanCommand,
  PutCommand,
  GetCommand,
  DeleteCommand,
} from "@aws-sdk/lib-dynamodb";

const client = new DynamoDBClient({});

const dynamo = DynamoDBDocumentClient.from(client);

const crudDemoTableName = "http-crud-demo-product";

export const handler = async (event, context) => {
  let body;
  let statusCode = 200;
  const headers = {
    "Content-Type": "application/json",
  };

  try {
    switch (event.routeKey) {
      case "DELETE /product/{id}":
        await dynamo.send(
          new DeleteCommand({
            TableName: crudDemoTableName,
            Key: {
              id: event.pathParameters.id,
            },
          })
        );
        body = `Deleted product ${event.pathParameters.id}`;
        break;
      case "GET /product/{id}":
        body = await dynamo.send(
          new GetCommand({
            TableName: crudDemoTableName,
            Key: {
              id: event.pathParameters.id,
            },
          })
        );
        body = body.Item;
        break;
      case "GET /product":
        body = await dynamo.send(
          new ScanCommand({ TableName: crudDemoTableName })
        );
        body = body.Items;
        break;
      case "PUT /product":
        let requestJSON = JSON.parse(event.body);
        await dynamo.send(
          new PutCommand({
            TableName: crudDemoTableName,
            Item: {
              id: requestJSON.id,
              price: requestJSON.price,
              name: requestJSON.name,
            },
          })
        );
        body = `Put product ${requestJSON.id}`;
        break;
      default:
        throw new Error(`Unsupported route error occured: "${event.routeKey}"`);
    }
  } catch (err) {
    statusCode = 400;
    body = err.message;
  } finally {
    body = JSON.stringify(body);
  }

  return {
    statusCode,
    body,
    headers,
  };
};
