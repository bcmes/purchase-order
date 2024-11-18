curl -i -X POST 'http://localhost:8080/actuator/loggers/ROOT' \
    -H 'Content-Type: application/json' \
    -d '{"configuredLevel":"off", "effectiveLevel":"off"}'

# Levels.: O log de nível maior contém os de níveis menores
# 0: OFF
# 1: ERROR
# 2: WARN
# 3: INFO
# 4: DEBUG
# 5: TRACE
