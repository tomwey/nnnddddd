class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable
  
  def super_admin?
    Setting.admin_emails.include?(self.email)
  end
  
  def admin?
    SiteConfig.admin_emails.include?(self.email) or super_admin?
  end
end
