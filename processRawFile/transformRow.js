"use strict";

const transformRow = (record, callback) => {
  try {
    const item = JSON.parse(`{"event": {${record}}`);

    const content = `${JSON.stringify(item)}\n`;

    return callback(null, content);
  } catch (error) {
    console.warn({message: "Encountered a record with invalid JSON", record: record, error: error});

    return callback(null, "");
  }
};

module.exports = transformRow;
