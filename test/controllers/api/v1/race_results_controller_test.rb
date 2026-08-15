require "test_helper"

class Api::V1::RaceResultsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_race_race_results_url(races(:one))
    assert_response :success
  end

  test "should create race_result" do
    assert_difference("RaceResult.count") do
      post api_v1_race_race_results_url(races(:two)), params: {
        race_result: { race_id: races(:two).id, driver_id: drivers(:one).id, finishing_position: 5 }
      }
    end
    assert_response :created
  end

  test "should update race_result" do
    patch api_v1_race_result_url(race_results(:one)), params: {
      race_result: { finishing_position: 3 }
    }
    assert_response :success
  end
end
