/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import {onRequest} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import  {generateFrontAnalysisFromImage, generateBackAnalysisFromImage} from "./utils/openaiHandler";




// Start writing functions
// https://firebase.google.com/docs/functions/typescript

export const helloWorld = onRequest((request, response) => {
  logger.info("Hello logs!");
  response.send({"data": "Hello from Firebase!"});
});

export const returnNumber = onRequest((request, response) => {
    logger.info("returning number", {structuredData: true});
    response.send({"data": "hello hello"})
});

export const returnFrontAnalysis = onRequest(async (request, response) => {
    logger.info("Running return front analysis", {structuredData: true});
    
    let data = await generateFrontAnalysisFromImage(request.body.data);

    //let data = "tell me a story";

    response.send({"data": data})
});


export const returnBackAnalysis = onRequest(async (request, response) => {
  logger.info("Running return back analysis", {structuredData: true});
  
  let data = await generateBackAnalysisFromImage(request.body.data);

  //let data = "tell me a story";

  response.send({"data": data})
});



