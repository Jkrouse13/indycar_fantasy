require "test_helper"

class Api::V1::RacesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_races_url
    assert_response :success
  end

  test "should get show" do
    get api_v1_race_url(races(:one))
    assert_response :success
  end

  test "should create race" do
    assert_difference("Race.count") do
      post api_v1_races_url, params: {
        race: {
          name: "Indy 500",
          track: "IMS",
          date: Time.current,
          green_flag_time: Time.current,
          status: "upcoming",
          season_year: 2026
        }
      }
    end
    assert_response :created
  end

  test "should update race" do
    patch api_v1_race_url(races(:one)), params: { race: { name: "Updated Race" } }
    assert_response :success
  end

  test "should destroy race" do
    assert_difference("Race.count", -1) do
      delete api_v1_race_url(races(:three))
    end
    assert_response :no_content
  end
end
