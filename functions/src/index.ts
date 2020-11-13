import * as functions from "firebase-functions";
const vision = require("@google-cloud/vision").v1;

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

export const recogniseTextFromPdf = functions.region('australia-southeast1').https.onCall(
    async (data, context) => {
        const client = new vision.ImageAnnotatorClient();

        const gcsSourceUri = `gs://remembrallpdf.appspot.com/pdf/${data.name}`;
        const gcsDestinationUri = `gs://remembrallpdf.appspot.com/pdf_results/${data.name}`;

        const inputConfig = {
            mimeType: 'application/pdf',
            gcsSource: {
                uri: gcsSourceUri,
            }
        };
        const outputConfig = {
            gcsDestination: {
                uri: gcsDestinationUri,
            }
        };
        const features = [{ type: 'DOCUMENT_TEXT_DETECTION' }];
        const request = {
            requests: [
                {
                    inputConfig: inputConfig,
                    features: features,
                    outputConfig: outputConfig,
                },
            ],
        };

        const [operation] = await client.asyncBatchAnnotateFiles(request);
        const [filesResponse] = await operation.promise();
        const destinationUri =
            filesResponse.responses[0].outputConfig.gcsDestination.uri;
        console.log('Json saved to: ' + destinationUri);
    }
);
