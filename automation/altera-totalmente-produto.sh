curl -vX PUT http://localhost:8080/products \
-H "Content-Type:application/json" \
-d '{"id": 2, "description": "Product 4"}' | jq