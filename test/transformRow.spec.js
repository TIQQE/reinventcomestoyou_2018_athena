"use strict";

const assert = require("chai").assert;

describe("transformRow", () => {
  it("Should transform row to a proper JSON object", (done) => {
    try {
      //const record = "\"date\": \"1254\", \"description\": \"Some event\", \"lang\": \"en\", \"category1\": \"By place\", \"category2\": \"Egypt\", \"granularity\": \"year\"}";

      const record = `"date": "1254", "description": "Some event", "lang": "en", "category1": "By place", "category2": "Egypt", "granularity": "year"}`;

      const expected = {
        event: {
          date: "1254",
          description: "Some event",
          lang: "en",
          category1: "By place",
          category2: "Egypt",
          granularity: "year"
        }
      };

      const transformRow = require("../processRawFile/transformRow");

      transformRow(record, (something, content) => {
        assert.deepEqual(content, `${JSON.stringify(expected)}\n`, "Invalid output");

        done();
      });
    } catch (errorMessage) {
      done(errorMessage);
    }
  });
});
