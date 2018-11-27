"use strict";

const processFile = require("./processFile");

module.exports.processRawFile = async (event, context, callback) => {
  console.info(event);

  try {
    const sourceBucket = event.Records[0].s3.bucket.name;
    const sourcekey = event.Records[0].s3.object.key;
    console.info({sourceBucket: sourceBucket, sourcekey: sourcekey});

    await processFile(sourceBucket, sourcekey);

    return callback(null, {message: "File processed sucessfully"});
  } catch (error) {
    const message = "Error processing file!";

    console.info({error: error, message: message});

    return callback(null, {message: message});
  }
};
