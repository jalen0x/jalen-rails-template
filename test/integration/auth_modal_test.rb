require "test_helper"

class AuthModalTest < ActionDispatch::IntegrationTest
  test "auth pages render inside the shared modal frame" do
    [ new_user_session_path, new_user_registration_path, new_user_password_path ].each do |path|
      get path, headers: { "Turbo-Frame" => "modal_content" }

      assert_response :success
      assert_select "turbo-frame#modal_content"
      assert_select "[data-controller='modal']"
      assert_select "form"
    end
  end
end
