require 'test_helper'

class UsersControllerTest < ActionController::TestCase
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

    #
    # Index
    #
    test "check index anonimous" do
        get :index
        assert_redirected_to "/login"
    end

    test "check index viewer" do
        login_viewer
        get :index
        assert_redirected_to "/404.html"
    end

    test "check index member" do
        login_member
        get :index
        assert_redirected_to "/404.html"
    end

    test "check index admin" do
        login_admin
        get :index
        assert_response :success
        assert_template "register"
        assert assigns(:users).count == User.all.count
    end

    #
    #   Create
    #
    test "check create anonimous" do
        get :create
        assert_redirected_to "/login"
    end

    test "check create viewer" do
        login_viewer
        get :create
        assert_redirected_to "/404.html"
    end

    test "check create member" do
        login_member
        get :create
        assert_redirected_to "/404.html"
    end

    test "check create admin" do
        login_admin
        
        get :create, :user => {:email => "test@test.ru", :password_confirmation => 1, :password => 1, :role => 'admin'}
        assert_redirected_to register_url

        get :create
        assert_response :success
        assert_template "register"
        assert assigns(:users).count == User.all.count
        user = assigns(:user)
        assert user.errors.any?

        get :create, :user => {:email => "", :password_confirmation => "", :password => "", :role => ""}
        assert_response :success
        assert_template "register"
        assert assigns(:users).count == User.all.count
        user = assigns(:user)
        assert user.errors.any?

        get :create, :user => {:email => "viewer@viewer.ru", :password_confirmation => 1, :password => 1, :role => 'admin'}
        assert_response :success
        assert_template "register"
        assert assigns(:users).count == User.all.count
        user = assigns(:user)
        assert user.errors.any?
    end

    #
    # Edit
    #
    test "check edit anonimous" do
        get :edit
        assert_redirected_to "/login"
    end

    test "check edit viewer" do
        login_viewer

        id = User.find_by_email("viewer@viewer.ru").id
        get :edit, {:id => id}
        assert_response :success
        assert_template "edit"
        assert_not_nil assigns(:user)
 
        get :edit, {:id => 199}
        assert_redirected_to "/404.html"
    end

    test "check edit member" do
        login_member

        id = User.find_by_email("member@member.ru").id
        get :edit, {:id => id}
        assert_response :success
        assert_template "edit"
        assert_not_nil assigns(:user)
 
        get :edit, {:id => 199}
        assert_redirected_to "/404.html"
    end

    test "check edit admin" do
        login_admin

        id = User.find_by_email("admin@admin.ru").id
        get :edit, {:id => id}
        assert_response :success
        assert_template "edit"
        assert_not_nil assigns(:user)
 
        get :edit, {:id => 199}
        assert_response :success
        assert_template "edit"
        assert_not_nil assigns(:user)
    end

    #
    # Update
    #
    test "check update anonimous" do
        get :update
        assert_redirected_to "/login"
    end

    test "check update viewer" do
        login_viewer

        id = User.find_by_email("viewer@viewer.ru").id
        get :update, {:id => id, :user => {:email => "test@test.ru", :password_confirmation => 1, :password => 1, :role => :admin }}
        assert_response :success
        assert_template "edit"
        user = assigns(:user)
        assert user.role == "viewer"
        assert flash[:notice] == "This user has been modified"

        get :update, {:id => id, :user => {:email => "test@test.ru", :password_confirmation => 1}}
        assert_response :success
        assert_template "edit"
        assert assigns(:user)
        assert flash[:notice] != "This user has been modified"

        get :update, {:id => id, :user => {:email => "admin@admin.ru"}}
        assert_response :success
        assert_template "edit"
        assert assigns(:user)
        assert flash[:notice] != "This user has been modified"
    end

    test "check update member" do
        login_member

        id = User.find_by_email("member@member.ru").id
        get :update, {:id => id, :user => {:email => "test@test.ru", :password_confirmation => 1, :password => 1, :role => :admin }}
        assert_response :success
        assert_template "edit"
        user = assigns(:user)
        assert user.role == "member"
        assert flash[:notice] == "This user has been modified"

        get :update, {:id => id, :user => {:email => "test@test.ru", :password_confirmation => 1}}
        assert_response :success
        assert_template "edit"
        assert assigns(:user)
        assert flash[:notice] != "This user has been modified"

        get :update, {:id => id, :user => {:email => "admin@admin.ru"}}
        assert_response :success
        assert_template "edit"
        assert assigns(:user)
        assert flash[:notice] != "This user has been modified"
    end

    test "check update admin" do
        login_admin

        id = User.find_by_email("admin@admin.ru").id
        get :update, {:id => id, :user => {:email => "test@test.ru", :password_confirmation => 1, :password => 1}}
        assert_response :success
        assert_template "edit"
        assert assigns(:user)
        assert flash[:notice] == "This user has been modified"

        get :update, {:id => User.find_by_email("member@member.ru").id, :user => {:email => "test1@test1.ru", :password_confirmation => 1, :password => 1}}
        assert_response :success
        assert_template "edit"
        assert assigns(:user)
        assert flash[:notice] == "This user has been modified"

        get :update, {:id => id, :user => {:email => "test@test.ru", :password_confirmation => 1}}
        assert_response :success
        assert_template "edit"
        assert assigns(:user)
        assert flash[:notice] != "This user has been modified"

        get :update, {:id => id, :user => {:email => "viewer@viewer.ru"}}
        assert_response :success
        assert_template "edit"
        assert assigns(:user)
        assert flash[:notice] != "This user has been modified"
    end

    #
    # Destroy
    #
    test "check destroy anonimous" do
        get :destroy
        assert_redirected_to "/login"
    end

    test "check destroy viewer" do
        login_viewer
        get :destroy
        assert_redirected_to "/404.html"
    end

    test "check destroy member" do
        login_member
        get :destroy
        assert_redirected_to "/404.html"
    end

    test "check destroy admin" do
        login_admin
        id = User.find_by_email("member@member.ru").id
        get :destroy, {:id => id }
        assert_redirected_to register_url
        assert !User.find_by_id(id)
    end

end
