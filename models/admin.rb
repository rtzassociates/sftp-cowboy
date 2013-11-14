class Admin < ActiveRecord::Base
  include Manageable

  validate       :user_exists?
  before_create  :create_account
  before_destroy :delete_account

  validates :username, :presence => true, :length => { :minimum => 4, :maximum => 24 }
  validates :password, :presence => true, :length => { :minimum => 8, :maximum => 24 }

  def add_user
    `sudo useradd #{self.username} -p #{encrypted_password} -g #{ADMIN_GROUP} --home #{user_home_dir} -m -k /etc/skel`
  end
end
