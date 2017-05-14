# == Schema Information
#
# Table name: dogs
#
#  id          :integer          not null, primary key
#  name        :string
#  short_code  :text
#  image_url   :text
#  archived_at :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  age         :date
#

class Dog < ActiveRecord::Base
  paginates_per 40
  
  before_save :ensure_short_code

  validates_uniqueness_of :short_code

  has_many :statuses
  has_one :current_status, -> { order('statuses.created_at') }, class_name: 'Status'

  default_scope { includes(current_status: :user) }

  def current_user
    current_status.user
  end

  private

  def ensure_short_code
    self.short_code ||= SecureRandom.hex(3)
  end
end
