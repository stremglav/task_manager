require 'test_helper'

class StoriesControllerTest < ActionController::TestCase

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

    def test_filter(set_user_func)
        set_user_func.call()

        id =  User.find_by_email("admin@admin.ru").id
        state = :started

        filter = {"user_id" => id}
        get :index, :filter => filter
        assert_response :success
        assert assigns(:stories).count == Story.where(filter).count

        filter = {"state" => state}
        get :index, :filter => filter
        assert_response :success
        assert assigns(:stories).count == Story.where(filter).count
        
        filter = {"user_id" => id, "state" => state}
        get :index, :filter => filter
        assert_response :success
        assert assigns(:stories).count == Story.where(filter).count

        filter = {"user_id" => "", "state" => ""}
        get :index, :filter => filter
        assert_response :success
        assert assigns(:stories).count == Story.all.count
    end

    def test_index(set_user_func)
        set_user_func.call()

        get :index
        assert_response :success
        assert_template "index"
        assert_not_nil assigns(:story)
        assert assigns(:stories).count == Story.all.count
        assert @response.body =~ /Add\snew\sstory/
        assert @response.body =~ /data-confirm\=\"Are\syou\ssure\?\"/
    end

    def test_create_story(set_user_func)
        set_user_func.call()
    
        id = User.find_by_email("admin@admin.ru").id
        story = {
            :text => "test text",
            :user_id => id
        }

        get :create, :story => story
        story_object = assigns(:story)
        assert story_object.errors.blank?
        assert_template :index

        get :create
        story_object = assigns(:story)
        assert story_object.errors.any?

        story[:user_id] = 0
        get :create, :story => story
        story_object = assigns(:story)
        assert story_object.errors.any?

        story[:user_id] = id
        story[:state] = "aaa"
        get :create, :story => story
        story_object = assigns(:story)
        assert story_object.errors.any?
    end

    def test_show(set_user_func)
        set_user_func.call()

        get :show, {:id => 1}
        assert_response :success
        assert_template "show"

        get :show
        assert_redirected_to "/404.html"

        get :show, {:id => 0}
        assert_redirected_to "/404.html"
    end

    def test_edit(set_user_func)
        set_user_func.call()

        get :edit, {:id => 1}
        assert_response :success
        assert_template "edit"

        get :edit
        assert_redirected_to "/404.html"
    end

    def test_update(set_user_func)
        set_user_func.call()

        id = User.find_by_email("member@member.ru").id
        get :update, {:id => 1, :story => {:text => "aaa", :user_id => id}}
        assert_redirected_to root_url

        get :update, {:id => 0}
        assert_redirected_to "/404.html"

        get :update, {:id => 1, :story => {:text => "", :user_id => 0}}
        assert_response :success
        assert_template "edit"
    end

    def test_destroy(set_user_func)
        set_user_func.call()

        get :destroy, {:id => 1}
        assert_redirected_to root_url

        get :destroy, {:id => 0}
        assert_redirected_to "/404.html"

    end


    test "should redirect to login" do
        get :index
        assert_redirected_to "/login"
    end

    test "check main page for admin and member" do
        test_index(proc {login_admin})
        test_index(proc {login_member})
    end
    
    test "check filter for users" do
        test_filter(proc { login_admin })
        test_filter(proc { login_member })
        test_filter(proc { login_viewer })
    end

    test "check main page for viewer" do
        login_viewer

        get :index
        assert_response :success
        assert_template "index"
        assert_not_nil assigns(:story)
        assert assigns(:stories).count == Story.all.count
        assert @response.body !=~ /Add\snew\sstory/
        assert @response.body !=~ /data-confirm\=\"Are\syou\ssure\?\"/
    end

    test "check create story for admin and member" do 
        test_create_story(proc { login_admin })
        test_create_story(proc { login_member })
    end

    test "check create story for viewer" do 
        login_viewer

        get :create
        assert_redirected_to "/404.html"
    end

    test "check create story for anonimous" do 
        get :create
        assert_redirected_to "/login"
    end


    test "check show story for users" do 
        test_show (proc {login_admin})
        test_show (proc {login_member})
        test_show (proc {login_viewer})
    end

    test "check show story for anonimous" do 
        get :show, {:id => 1}
        assert_redirected_to "/login"
    end


    test "check edit story for admin member" do 
        test_edit (proc {login_admin})
        test_edit (proc {login_member})
    end

    test "check edit story for viewer" do 
        login_viewer
        get :edit, {:id => 1}
        assert_redirected_to "/404.html"
    end

    test "check edit story for anonimous" do 
        get :edit, {:id => 1}
        assert_redirected_to "/login"
    end

    test "check update story for admin and member" do 
        test_update (proc {login_admin})
        test_update (proc {login_member})
    end

    test "check update story for viewer" do 
        login_viewer
        get :update, {:id => 1}
        assert_redirected_to "/404.html"
    end

    test "check update story for anonimous" do 
        get :update, {:id => 1}
        assert_redirected_to "/login"
    end

    test "check destroy story for admin" do 
        test_destroy (proc {login_admin})
    end

    test "check destroy story for viewer" do 
        login_viewer
        get :destroy, {:id => 1}
        assert_redirected_to "/404.html"
    end

    test "check destroy story for anonimous" do 
        get :destroy, {:id => 1}
        assert_redirected_to "/login"
    end

end
