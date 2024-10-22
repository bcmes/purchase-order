counter=1

while [ $counter -le 5 ]
do
    echo "................................................................................."
    echo "Inserindo produto: $counter"

    curl -vX POST http://localhost:8080/products \
    -H "Content-Type:application/json" \
    -d "{\"description\": \"Product $counter\"}" | jq

    ((counter++))
    sleep 0.8
done
