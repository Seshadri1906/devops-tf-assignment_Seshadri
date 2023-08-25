ENDPOINT_URL=http://localstack:4566
NAME=helloworld-localstack

init:
	tflocal init

plan:
	tflocal plan

apply:
	tflocal apply --auto-approve

destroy:
	tflocal destroy --auto-approve

list1:
	aws --endpoint-url=${ENDPOINT_URL} lambda list-functions

test1:
	@{\
  	FUNCTION_NAME="$$(aws --endpoint-url=${ENDPOINT_URL} lambda list-functions | jq -r '.Functions[0].FunctionName')"; \
  	aws --endpoint-url=${ENDPOINT_URL} lambda invoke --function-name $${FUNCTION_NAME} ./output.json >> /dev/null; \
		OUTPUT=$$(cat ./output.json); \
		echo $${OUTPUT} | jq '.'; \
  }

list2:
	aws --endpoint-url=${ENDPOINT_URL} apigateway get-rest-apis

test2:
	@{\
		REST_API_ID="$$(aws --endpoint-url=${ENDPOINT_URL} apigateway get-rest-apis | jq -r '.items[0].id')"; \
		curl -s http://${LOCALSTACK_HOSTNAME}:4566/restapis/$${REST_API_ID}/test/_user_request_/ | jq '.'; \
	}

test3:
	@{\
		REST_API_ID="$$(aws --endpoint-url=${ENDPOINT_URL} apigateway get-rest-apis | jq -r '.items[0].id')"; \
		REST_API_KEY="$$(aws apigateway --endpoint-url=${ENDPOINT_URL} get-api-keys --query 'items[?name==`helloworld-localstack-test`].value' --include-values --output text)"; \
		echo $${REST_API_KEY}; \
	}

test4:
	@{\
		CUSTOM_DOMAIN="$$(aws apigateway --endpoint-url=${ENDPOINT_URL} get-domain-names --query 'items[?domainName==`helloworld.myapp.earth`]'  | jq -r '.[0].domainName')"; \
		echo $${CUSTOM_DOMAIN}; \
	}
