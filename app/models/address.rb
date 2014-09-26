class Address < ActiveRecord::Base
  validates :province, presence: true
  validates :city, presence: true
  validates :neighborhood, presence: true

  belongs_to :province

  def orphan
    orphan_id = orphan_original_address_id || orphan_current_address_id
    Orphan.find(orphan_id)
  end
end
