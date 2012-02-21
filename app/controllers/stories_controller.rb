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

        @story = Story.new(params[:story])
        @story = Story.new if @story.save
        index
    end

    def show
        return if is_anonymous?

        @story = Story.find(params[:id])
        @comment = Comment.new
        @comments = Comment.where(:story_id => params[:id])
        render "show"
    end

    def edit
        return if !is_member?

        @story ||= Story.find(params[:id])
        @users = {}
        User.find(:all).collect {|u| @users[u.email] = u.id}
        render "edit"
    end

    def update
        return if !is_member?

        @story = Story.find(params[:id])
        if @story.update_attributes(params[:story])
            redirect_to root_url
        else
            edit
        end
    end

    def destroy
        return if !is_member?

        @story = Story.find(params[:id])
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
            PP.pp("SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS")
            redirect_to "/404.html"
            return false
        end
    end

end
