flutter test integration_test/compatiblity_test.dart -d $1 -v \
    --dart-define=TEST_BASE_URL="$TEST_BASE_URL" \
    --dart-define=TEST_CUV_CLIENT_ID="$TEST_CUV_CLIENT_ID" \
    --dart-define=TEST_CUV_CLIENT_SECRET="$TEST_CUV_CLIENT_SECRET" \
    --dart-define=TEST_USER_ID="$TEST_USER_ID" \
    --dart-define=TEST_DV_PROJECT_ID="$TEST_DV_PROJECT_ID" \
    --dart-define=TEST_CUV_PROJECT_ID="$TEST_CUV_PROJECT_ID"