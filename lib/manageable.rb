module Manageable

  USERS_DIRECTORY='/home/sftpuser'
  USERS_GROUP='sftponly'
  ADMIN_GROUP='sftpadmin'
  SALT = 'assault'

  def update_password!
    `sudo usermod -p #{encrypted_password} #{self.username}`
  end

  private

  def delete_account
    `sudo userdel #{self.username}`
  end

  def user_home_dir
    File.join(USERS_DIRECTORY, self.username)
  end
  
  def user_uploads_dir
    File.join(USERS_DIRECTORY, self.username, "uploads")
  end

  def encrypted_password
    self.password.crypt(SALT)
  end

  def create_account
    add_user unless user_exists?
    create_home_dir unless home_dir_exists?
  end

  def create_home_dir
    `sudo chown root #{user_home_dir}`
    `sudo mkdir #{user_uploads_dir}`
    `sudo chown #{self.username} #{user_uploads_dir}`
    `sudo chgrp -R #{ADMIN_GROUP} #{user_home_dir}`
    `sudo chmod -R 755 #{user_home_dir}`
  end

  def user_exists?
    if `id #{self.username} 2>&1` =~ /No such user/
      false
    else
      errors.add(:user, "already exists")
      true
    end
  end

  def home_dir_exists?
    true if FileTest.exists?(user_uploads_dir)
  end

end
