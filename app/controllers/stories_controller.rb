class StoriesController < ApplicationController
    def index
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
        if !@current_user
            redirect_to login_url
        else
            if @current_user.is_admin?
                admin_area
            else
                render "user_index"
            end
        end
    end

    def create
        @story = Story.new(params[:story])
        @story = Story.new if @story.save
        index
    end

    def edit
        @story ||= Story.find(params[:id])
        @users = {}
        User.find(:all).collect {|u| @users[u.email] = u.id}
        render "edit"
        #definition.states.keys
    end

    def update
        @story = Story.find(params[:id])
        if @story.update_attributes(params[:story])
            redirect_to root_url
        else
            edit
        end
    end

    private
    def admin_area
        @story ||= Story.new
        @users = {}
        User.find(:all).collect {|u| @users[u.email] = u.id}

        @stories = Story.find(:all, :include => :user)
        render :action => "admin_index"
    end
end
