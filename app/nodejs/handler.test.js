const jest = require("jest");
const { describe, expect, test } = require("@jest/globals");
const { hello } = require("./handler");

const mockCallback = jest.fn((x, y) => console.log(x, y));

describe("hello", () => {
  test("returns hello world", () => {
    hello({}, {}, mockCallback);

    expect(mockCallback).toHaveBeenCalledWith(null, {
      body: '{"payload":"Hello, world."}',
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json",
      },
      statusCode: 200,
    });
  });
});
