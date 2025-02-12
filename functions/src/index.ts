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
const admin = require('firebase-admin');
admin.initializeApp();




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



export const deleteUserAccount = onRequest(async (request, response) => {
  logger.info("Starting user account deletion process", { structuredData: true });

  // Check for Authorization header
  const authHeader = request.headers.authorization;
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
      logger.error("Unauthorized request: No valid token provided");
      response.status(401).json({ error: "Unauthorized request: No valid token provided" });
      return;
  }

  try {
      // Verify Firebase ID token
      const idToken = authHeader.split("Bearer ")[1];
      const decodedToken = await admin.auth().verifyIdToken(idToken);
      const uid = decodedToken.uid;

      logger.info(`Deleting account for UID: ${uid}`);

      // Delete Firestore user document (Check if it exists first)
      const userDocRef = admin.firestore().collection("users").doc(uid);
      const docSnapshot = await userDocRef.get();
      if (docSnapshot.exists) {
          await userDocRef.delete();
          logger.info(`Firestore document deleted for UID: ${uid}`);
      } else {
          logger.warn(`No Firestore document found for UID: ${uid}`);
      }

      // Delete Firebase Authentication user
      await admin.auth().deleteUser(uid);
      logger.info(`Firebase Auth account deleted for UID: ${uid}`);

      response.json({ success: true, message: "User account deleted successfully" });
  } catch (error) {
      let errorMessage = "Internal Server Error: Unable to delete user account";

      // Convert error to a readable message
      if (error instanceof Error) {
          errorMessage = error.message;
          logger.error(`Error deleting user account: ${error.message}`, error);
      } else {
          logger.error("Unknown error occurred:", error);
      }

      response.status(500).json({ error: errorMessage });
  }
});





