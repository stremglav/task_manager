class CommentsController < ApplicationController
    def create
        return if is_anonymous?

        if params[:comment][:text] != ""
            @comment = Comment.new(params[:comment])
            @comment.save
        end
        redirect_to :back
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
end
