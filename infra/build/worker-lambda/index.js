const { SNSClient, PublishCommand } = require("@aws-sdk/client-sns");

const sns = new SNSClient({ region: process.env.AWS_REGION });

exports.handler = async (event) => {
  console.log("Received SQS event:", JSON.stringify(event));

  try {
    for (const record of event.Records) {
      const message = record.body;

      await sns.send(
        new PublishCommand({
          TopicArn: process.env.SNS_TOPIC_ARN,
          Message: `New Ticket Message: ${message}`,
        })
      );

      console.log("Message sent to SNS:", message);
    }

    return { statusCode: 200 };
  } catch (err) {
    console.error("Error processing SQS message:", err);
    throw err;
  }
};
