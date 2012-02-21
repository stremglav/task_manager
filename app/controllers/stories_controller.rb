class StoriesController < ApplicationController
    def index
        return if is_anonymous?

        @story ||= Story.new
        @users = {}

        User.find(:all).collect {|u| @users[u.email] = u.id}
        
        if params[:filter]
            params[:filter].delete(:user_id) if params[:filter][:user_id] == ""
            params[:filter].delete(:state) if params[:filter][:state] == ""

            @stories = Story.where(params[:filter], :include => :user)
        else
            @stories = Story.find(:all, :include => :user)
        end
        render :action => "index"
    end

    def create
        return if !is_member?
        
        is_user_exist = true
        if params[:story] && params[:story][:user_id]
            is_user_exist = User.find_by_id(params[:story][:user_id])
        end
        @story = Story.new(params[:story])
        if is_user_exist
            @story = Story.new if @story.save
        else
            @story.errors.add(:user_id, "User does not exist")
        end
        
        index
    end

    def show
        return if is_anonymous?

        @story = Story.find_by_id(params[:id])
        if !@story
            redirect_to "/404.html"
            return
        end
        @comment = Comment.new
        @comments = Comment.where(:story_id => params[:id])
        render "show"
    end

    def edit
        return if !is_member?

        @story ||= Story.find_by_id(params[:id])
        if !params[:id] || !@story
            redirect_to "/404.html"
            return
        end
        @users = {}
        User.find(:all).collect {|u| @users[u.email] = u.id}
        render "edit"
    end

    def update
        return if !is_member?

        @story = Story.find_by_id(params[:id])

        if !params[:id] || !@story
            redirect_to "/404.html"
            return
        end

        if @story.update_attributes(params[:story])
            redirect_to root_url
        else
            edit
        end
    end

    def destroy
        return if !is_member?

        @story = Story.find_by_id(params[:id])

        if !params[:id] || !@story
            redirect_to "/404.html"
            return
        end

        @story.destroy
        redirect_to root_url
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
    def is_member?
        return false if is_anonymous?

        if @current_user.is_admin?
            return true
        elsif @current_user.is_member?
            return true
        else
            redirect_to "/404.html"
            return false
        end
    end

end
