require "test_helper"

class Api::V1::RaceTiersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_race_race_tiers_url(races(:one))
    assert_response :success
  end

  test "should create race_tier" do
    assert_difference("RaceTier.count") do
      post api_v1_race_race_tiers_url(races(:two)), params: {
        race_tier: { tier_number: 2, driver_ids: [ drivers(:one).id ] }
      }
    end
    assert_response :created
  end

  test "should update race_tier" do
    patch api_v1_race_tier_url(race_tiers(:three)), params: {
      race_tier: { driver_ids: [ drivers(:two).id ] }
    }
    assert_response :success
  end

  test "should destroy race_tier" do
    assert_difference("RaceTier.count", -1) do
      delete api_v1_race_tier_url(race_tiers(:three))
    end
    assert_response :no_content
  end
end
