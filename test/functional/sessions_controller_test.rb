require 'test_helper'

class SessionsControllerTest < ActionController::TestCase

    test "should get new" do
        get :new
        assert_response :success
    end

    test "client login ok" do
        auth = {"email" => "admin@admin.ru", "password" => "1"}
        admin = User.find_by_email(auth["email"])
        get :create, auth
        assert_redirected_to root_url
        assert admin.id == session["user_id"]
    end

    test "client login failed" do
        auth = {"email" => "admin@admin.ru", "password" => "12"}
        get :create, auth
        assert_response :success
        assert !session["user_id"]
        assert flash[:alert] == "Invalid email or password"
    end

    test "client logout" do
        session["user_id"] = 1
        get :destroy
        assert_redirected_to root_url
        assert !session["user_id"]
    end


end
