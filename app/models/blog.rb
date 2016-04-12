class Blog < ActiveRecord::Base
  validates :title, presence: true
  validates :confirming, presence: true

  attr_accessor :confirming
  after_validation :check_confirming

  def check_confirming
    errors.delete(:confirming)
    self.confirming = errors.empty? ? '1' : ''
  end
end
