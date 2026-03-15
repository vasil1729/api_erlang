#!/bin/bash
# apps/freeapi/curl/test_healthcheck.sh

BASE_URL="${BASE_URL:-http://localhost:3000}"
PASS=0
FAIL=0

test_endpoint() {
    local name="$1"
    local method="$2"
    local endpoint="$3"
    local expected_status="$4"
    local data="$5"

    echo -n "Testing $name... "

    if [ -n "$data" ]; then
        response=$(curl -s -w "\n%{http_code}" -X "$method" "$BASE_URL$endpoint" \
            -H "Content-Type: application/json" \
            -d "$data")
    else
        response=$(curl -s -w "\n%{http_code}" -X "$method" "$BASE_URL$endpoint")
    fi

    body=$(echo "$response" | head -n -1)
    status=$(echo "$response" | tail -n 1)

    if [ "$status" = "$expected_status" ]; then
        echo "✅ PASS (status: $status)"
        ((PASS++))
    else
        echo "❌ FAIL (expected: $expected_status, got: $status)"
        echo "Response: $body"
        ((FAIL++))
    fi
}

# Run tests
echo "=== Healthcheck API Tests ==="
test_endpoint "GET /api/v1/healthcheck" "GET" "/api/v1/healthcheck" "200"

# Summary
echo ""
echo "=== Summary ==="
echo "Passed: $PASS"
echo "Failed: $FAIL"

[ $FAIL -eq 0 ] && exit 0 || exit 1
