require "test_helper"

class Api::V1::LeaderboardControllerTest < ActionDispatch::IntegrationTest
  test "should get race" do
    get api_v1_leaderboard_race_url
    assert_response :success
  end

  test "should get season" do
    get api_v1_leaderboard_season_url
    assert_response :success
  end
end
