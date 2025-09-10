import type { APIGatewayProxyEvent, APIGatewayProxyResult } from "aws-lambda";
import { v4 as uuidv4 } from "uuid";
import AWS from "aws-sdk";
import { Ticket } from "../models/ticket";

const dynamodb = new AWS.DynamoDB.DocumentClient();
const TABLE_NAME = process.env.TICKETS_TABLE || "mini-helpdesk-dev-tickets";

export const handler = async (
  event: APIGatewayProxyEvent
): Promise<APIGatewayProxyResult> => {
  console.log("Event:", JSON.stringify(event));

  try {
    const method = event.httpMethod;
    const path = event.path;

    // POST /tickets
    if (method === "POST" && path.endsWith("/tickets")) {
      const body = JSON.parse(event.body || "{}");
      if (!body.title || !body.description) {
        return response(400, { message: "Title and description required" });
      }

      const newTicket: Ticket = {
        id: uuidv4(),
        title: body.title,
        description: body.description,
        status: "open",
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString(),
      };

      await dynamodb
        .put({ TableName: TABLE_NAME, Item: newTicket })
        .promise();

      return response(201, newTicket);
    }

    // GET /tickets
    if (method === "GET" && path.endsWith("/tickets")) {
      const result = await dynamodb
        .scan({ TableName: TABLE_NAME })
        .promise();
      return response(200, result.Items || []);
    }

    // PATCH /tickets/{id}
    if (method === "PATCH" && event.pathParameters?.id) {
      const id = event.pathParameters.id;
      const body = JSON.parse(event.body || "{}");

      const updateExpression: string[] = [];
      const expressionValues: Record<string, any> = {};
      if (body.status) {
        updateExpression.push("status = :s");
        expressionValues[":s"] = body.status;
      }
      updateExpression.push("updatedAt = :u");
      expressionValues[":u"] = new Date().toISOString();

      const result = await dynamodb
        .update({
          TableName: TABLE_NAME,
          Key: { id },
          UpdateExpression: "SET " + updateExpression.join(", "),
          ExpressionAttributeValues: expressionValues,
          ReturnValues: "ALL_NEW",
        })
        .promise();

      if (!result.Attributes) {
        return response(404, { message: "Ticket not found" });
      }

      return response(200, result.Attributes);
    }

    // GET /health
    if (method === "GET" && path.endsWith("/health")) {
      return response(200, { status: "ok" });
    }

    // Default 404
    return response(404, { message: "Not Found" });
  } catch (err) {
    console.error("Error:", err);
    return response(500, { error: (err as Error).message });
  }
};

// ✅ Helper to build responses with CORS
function response(statusCode: number, body: any): APIGatewayProxyResult {
  return {
    statusCode,
    headers: {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "OPTIONS,GET,POST,PATCH,DELETE",
      "Access-Control-Allow-Headers": "Content-Type",
    },
    body: JSON.stringify(body),
  };
}
