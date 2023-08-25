"use strict";

function hello(event, context, callback) {
  console.log(event);

  const payload = { payload: `Hello, world.` };

  const resp = {
    statusCode: 200,
    headers: {
      "Access-Control-Allow-Origin": "*",
      "Content-Type": "application/json",
    },
    body: JSON.stringify(payload),
  };
  console.log("response: ", payload);

  callback(null, resp);
}

exports.hello = hello;
