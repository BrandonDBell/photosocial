class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :avatar, :private, :date_created, :email, :first_name, :last_login, :last_name, :username
  attr_accessor :delete_photo
  before_validation { photo.clear if delete_photo == '1' }
  has_secure_password
  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token 
  has_many :evaluations, class_name: "RSEvaluation", as: :source
  has_reputation :votes, source: {reputation: :votes, of: :photos}, aggregated_by: :sum
  has_many :photos, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :pcomments, :dependent => :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :relationships, :dependent => :destroy, :foreign_key => "follower_id"
  has_many :reverse_relationships, :dependent => :destroy,
                                   :foreign_key => "followed_id",
                                   :class_name => "Relationship"
  has_many :following, :through => :relationships, :source => :followed
  has_many :followers, :through => :reverse_relationships, :source  => :follower
  validates_presence_of :email, :first_name, :username, :last_name, :password, :on => :create
  has_attached_file :avatar, :styles => { :profileimg => "50x50>", :home => "150x150>" },
                    :url  => "/assets/photos/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/photos/:id/:style/:basename.:extension"
  validates_attachment_presence :avatar
  validates_attachment_size :avatar, :less_than => 3.megabytes
  validates_attachment_content_type :avatar, :content_type => ['image/jpeg', 'image/png']
  attr_protected :avatar_file_name, :avatar_content_type, :avatar_size
  validates :first_name,
                   :presence   => true,
                   :length     => {:in => 2..15},
                   :exclusion  => {:in => ['Admin', 'Root']}
  validates :last_name,
                   :presence   => true,
                   :length     => {:in => 2..15} ,
                   :exclusion  => {:in => ['Admin', 'Root']}
  VALID_USERNAME_REGEX = /\A\w+\Z/
  validates :username, :uniqueness => {:case_sensitive => false},
                   :presence   => true,
                   :length     => {:in => 3..15},
                   :exclusion  => {:in => ['Admin', 'Root']},
                   format: {with: VALID_USERNAME_REGEX}
  validates :password,
                   :presence   => true,
                   :length     => {:in => 5..15},
                   :confirmation => true
  validates_confirmation_of :password 
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :uniqueness => {:case_sensitive => false},
                   :presence   => true,
                   :length     => {:in => 5..45},
                   format: { with: VALID_EMAIL_REGEX }

  def to_s
    username
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  def self.find_by_id(id)
    find(:id) rescue nil
  end

  def voted_for?(photo)
    evaluations.where(target_type: photo.class, target_id: photo.id).present?
  end

  def self.search(search)
      if search
        find(:all, :conditions => ['username LIKE ?', "%#{search}%"])
      else
        find(:all)
      end
  end

  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end