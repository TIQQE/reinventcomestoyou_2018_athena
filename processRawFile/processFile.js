"use strict";

const S3 = require("aws-sdk/clients/s3");
const split = require("split");
const transform = require("stream-transform");
const zlib = require("zlib");

const transformRow = require("./transformRow");

const processFile = (sourceBucket, sourceKey) => {
  return new Promise((resolve, reject) => {
    const fileName = /incoming\/(.*)$/.exec(sourceKey)[1];
    console.info({fileName: fileName});

    const targetBucket = sourceBucket;
    const targetKey = `processed/${fileName}.gz`;

    const s3 = new S3();

    const pipeline = s3.getObject({
      Bucket: sourceBucket,
      Key: sourceKey
    })
      .createReadStream()
      .pipe(split(/, "event": {/))
      .pipe(transform(transformRow))
      .pipe(zlib.createGzip());

    s3.upload({
      Bucket: targetBucket,
      Key: targetKey,
      Body: pipeline
    }, (error) => {
      if (error) {
        console.error({error: error});

        return reject({message: "Failed!"});
      }

      console.info("Done!");

      return resolve({message: "Done!"});
    });
  });
};

module.exports = processFile;
