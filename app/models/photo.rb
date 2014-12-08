class Photo < ActiveRecord::Base
  belongs_to :user
  attr_accessible :photo, :tag_list, :date_uploaded, :description, :last_view, :num_comments, :private, :rating, :title, :view_count
  validates_presence_of :title
  acts_as_taggable
  has_many :pcomments
  has_reputation :votes, source: :user, aggregated_by: :sum
  has_attached_file :photo, :styles => {:edit => "550x550>", :small => "300x300>", :thumb => "150x150>" },
                    :url  => "/assets/photos/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/photos/:id/:style/:basename.:extension"
  validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 10.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif']
  attr_protected :photo_file_name, :photo_content_type, :photo_size
  validates :title,
                   :presence   => true,
                   :length     => {:in => 2..25} 
                   
  def delete_photo=(value)
    @delete_photo = !value.to_i.zero?
  end

  def delete_photo
    !!@delete_photo
  end
  alias_method :delete_photo?, :delete_photo

  before_validation :clear_photo
  def clear_photo
    self.photo = nil if delete_photo? && !photo.dirty?
  end
end
