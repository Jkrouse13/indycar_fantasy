require "test_helper"

class Api::V1::TeamsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_teams_url
    assert_response :success
  end

  test "should get show" do
    get api_v1_team_url(teams(:one))
    assert_response :success
  end

  test "should create team" do
    assert_difference("Team.count") do
      post api_v1_teams_url, params: { team: { name: "New Team" } }
    end
    assert_response :created
  end

  test "should update team" do
    patch api_v1_team_url(teams(:one)), params: { team: { name: "Updated Team" } }
    assert_response :success
  end

  test "should destroy team" do
    assert_difference("Team.count", -1) do
      delete api_v1_team_url(teams(:three))
    end
    assert_response :no_content
  end
end
