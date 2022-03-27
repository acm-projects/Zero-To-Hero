const functions = require("firebase-functions");


exports.rest = functions.https.onCall((data, context) => {
  return 1;
});
