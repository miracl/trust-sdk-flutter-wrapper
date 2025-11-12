flutter test integration_test/compatiblity_test.dart -d $1 -v \
    --dart-define=TEST_CUV_SERVICE_ACCOUNT_TOKEN="$TEST_CUV_SERVICE_ACCOUNT_TOKEN" \
    --dart-define=TEST_USER_ID="$TEST_USER_ID" \
    --dart-define=TEST_DV_PROJECT_ID="$TEST_DV_PROJECT_ID" \
    --dart-define=TEST_CUV_PROJECT_ID="$TEST_CUV_PROJECT_ID" \
    --dart-define=TEST_CUV_PROJECT_URL="$TEST_CUV_PROJECT_URL" \
    --dart-define=TEST_DV_PROJECT_URL="$TEST_DV_PROJECT_URL"