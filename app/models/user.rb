class User < ActiveRecord::Base
    has_one :story

    attr_accessible :email, :password, :password_confirmation, :role, :full_name
    has_secure_password
    validates_presence_of :password, :on => :create

    def is_admin?
        self.role == :admin
    end

    def is_member?
        self.role == :member
    end

    def is_viewer?
        self.role == :viewer
    end

end
