require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
    def login_admin
        admin = User.find_by_email("admin@admin.ru")
        session["user_id"] = admin.id
    end

    def login_member
        member = User.find_by_email("member@member.ru")
        session["user_id"] = member.id
    end

    def login_viewer
        viewer = User.find_by_email("viewer@viewer.ru")
        session["user_id"] = viewer.id
    end

    test "check create comment anonimous" do
        get :create
        assert_redirected_to "/login"

        get :create, :comment => {:text => "text"}
        assert_redirected_to "/login"
    end

    test "check create comment viewer" do
        login_viewer

        request.env["HTTP_REFERER"] = "/test"
        user_id = User.find_by_email("viewer@viewer.ru").id
        get :create, :comment => {:text => "viewer", :story_id => 1, :user_id => user_id}
        assert_redirected_to "/test"
        comment = Comment.find_by_text("viewer")
        assert_not_nil comment[:user_id] == user_id

        get :create, :comment => {:text => "viewer2", :story_id => 1, :user_id => 0}
        assert_redirected_to "/test"
        comment = Comment.find_by_text("viewer2")
        assert_not_nil comment[:user_id] == user_id
    end

    test "check create comment member" do
        login_member

        request.env["HTTP_REFERER"] = "/test"
        user_id = User.find_by_email("member@member.ru").id
        get :create, :comment => {:text => "member", :story_id => 1, :user_id => user_id}
        assert_redirected_to "/test"
        comment = Comment.find_by_text("member")
        assert_not_nil comment[:user_id] == user_id

        get :create, :comment => {:text => "member2", :story_id => 1, :user_id => 0}
        assert_redirected_to "/test"
        comment = Comment.find_by_text("member2")
        assert_not_nil comment[:user_id] == user_id
    end

    test "check create comment admin" do
        login_admin

        request.env["HTTP_REFERER"] = "/test"
        user_id = User.find_by_email("admin@admin.ru").id
        get :create, :comment => {:text => "admin", :story_id => 1, :user_id => user_id}
        assert_redirected_to "/test"
        comment = Comment.find_by_text("admin")
        assert_not_nil comment[:user_id] == user_id

        get :create, :comment => {:text => "admin2", :story_id => 1, :user_id => 0}
        assert_redirected_to "/test"
        comment = Comment.find_by_text("admin2")
        assert_not_nil comment[:user_id] == user_id
    end

end
