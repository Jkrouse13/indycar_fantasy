require "test_helper"

class Api::V1::ParticipantsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_participants_url
    assert_response :success
  end

  test "should get show" do
    get api_v1_participant_url(participants(:one))
    assert_response :success
  end

  test "should create participant" do
    assert_difference("Participant.count") do
      post api_v1_participants_url, params: { participant: { email: "new_participant@example.com" } }
    end
    assert_response :success
  end
end
