require "test_helper"

class Api::V1::PicksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_picks_url(race_id: races(:one).id)
    assert_response :success
  end

  test "should create pick" do
    assert_difference("Pick.count") do
      post api_v1_picks_url, params: {
        pick: {
          participant_id: participants(:two).id,
          race_id: races(:one).id,
          race_tier_id: race_tiers(:one).id,
          driver_id: drivers(:one).id
        }
      }
    end
    assert_response :created
  end
end
