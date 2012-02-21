class User < ActiveRecord::Base
    has_many :story
    has_many :comment

    attr_accessible :email, :password, :password_confirmation, :role, :full_name
    has_secure_password
    validates_presence_of :password, :on => :create
    validates_presence_of :role
    validates :email, :presence => true
    validates_uniqueness_of :email

    def self.is_email_unique?(email)
      !self.exists?(:email => email)
    end

    def self.roles
        return ["admin", "member", "viewer"]
    end

    def is_admin?
        self.role == "admin"
    end

    def is_member?
        self.role == "member"
    end

    def is_viewer?
        self.role == "viewer"
    end

end
