require "test_helper"

class CoursesControllerTest < ActionDispatch::IntegrationTest
  test "should get list" do
    get courses_list_url
    assert_response :success
  end
end
