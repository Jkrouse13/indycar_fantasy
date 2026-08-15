require "test_helper"

class Api::V1::DriversControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_drivers_url
    assert_response :success
  end

  test "should get show" do
    get api_v1_driver_url(drivers(:one))
    assert_response :success
  end

  test "should create driver" do
    assert_difference("Driver.count") do
      post api_v1_drivers_url, params: {
        driver: { name: "New Driver", car_number: "99", team_id: teams(:one).id }
      }
    end
    assert_response :created
  end

  test "should update driver" do
    patch api_v1_driver_url(drivers(:one)), params: { driver: { name: "Updated Driver" } }
    assert_response :success
  end

  test "should destroy driver" do
    assert_difference("Driver.count", -1) do
      delete api_v1_driver_url(drivers(:three))
    end
    assert_response :no_content
  end
end
