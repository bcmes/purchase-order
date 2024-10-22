curl -vX POST http://localhost:8080/products \
-H "Content-Type:application/json" \
-d '{"description": "Product 4"}' | jq