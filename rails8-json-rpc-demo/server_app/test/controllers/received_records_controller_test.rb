require "test_helper"

class ReceivedRecordsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get received_records_index_url
    assert_response :success
  end

  test "should get show" do
    get received_records_show_url
    assert_response :success
  end
end
