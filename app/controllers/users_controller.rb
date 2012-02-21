class UsersController < ApplicationController
    def index
        return if !is_admin_or_oneself?

        @user ||= User.new
        @users = User.find(:all)
        render "register"
    end

    def create
        return if !is_admin_or_oneself?

        @user = User.new(params[:user])
        email_uniq = User.is_email_unique?(params[:user][:email])
        @user.errors.add(:email, "Email is not unique")

        if email_uniq && @user.save
            redirect_to register_url
        else
            index
        end
    end

    def edit
        return if !is_admin_or_oneself?(params[:id])

        @user ||= User.find(params[:id])
        render "edit", :locals => {:title => "Modify user"}
    end
    
    def update
        return if !is_admin_or_oneself?(params[:id])

        params[:user].delete(:role) if !@current_user.is_admin?

        @user = User.find(params[:id])
        if @user.update_attributes(params[:user])
            flash.now.notice = "This user has been modified"
        end
        edit
    end

    def destroy
        return if !is_admin_or_oneself?(params[:id])

        @user = User.find(params[:id])
        @user.destroy
        redirect_to register_url
    end

    private
    def is_anonymous?
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
        if !@current_user
            redirect_to login_url
            return true
        end
        return false
    end
    def is_admin_or_oneself?(id = nil)
        return false if is_anonymous?
        
        if @current_user.is_admin?
            return true
        elsif @current_user.id.to_i == id.to_i
            return true
        else
            redirect_to "/404.html"
            return false
        end
    end

end
