class Orphan < ActiveRecord::Base

  include Initializer
  after_initialize :default_status_to_active,
                   :default_sponsorship_status_to_unsponsored

  validates :name, presence: true
  validates :father_name, presence: true
  validates :father_is_martyr, boolean: true
  validates :father_date_of_death, date_not_in_future: true
  validates :mother_name, presence: true
  validates :mother_alive, boolean: true
  validates :date_of_birth, date_not_in_future: true
  validates :gender, inclusion: {in: %w(Male Female) } # TODO: DRY list of allowed values
  validates :contact_number, presence: true
  validates :sponsored_by_another_org, boolean: true
  validates :minor_siblings_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :original_address, presence: true
  validates :current_address, presence: true
  validates :orphan_status, presence: true
  validate :orphans_dob_within_1yr_of_fathers_death

  has_one :original_address, foreign_key: 'orphan_original_address_id', class_name: 'Address'
  has_one :current_address, foreign_key: 'orphan_current_address_id', class_name: 'Address'
  has_many :sponsorships
  has_many :sponsors, through: :sponsorships

  belongs_to :orphan_status
  belongs_to :orphan_sponsorship_status

  accepts_nested_attributes_for :current_address, allow_destroy: true
  accepts_nested_attributes_for :original_address, allow_destroy: true

  scope :active,
        -> { Orphan.joins(:orphan_status).
            where(orphan_statuses: { name: 'Active' }) }
  scope :unsponsored,
        -> { Orphan.joins(:orphan_sponsorship_status).
            where(orphan_sponsorship_statuses: { name: 'Unsponsored' }) }


  def full_name
    [name, father_name].join(' ')
  end

  def orphans_dob_within_1yr_of_fathers_death
    # gestation is considered vaild if within 1 year of a fathers death
    if (father_date_of_death + 1.year) < date_of_birth
      errors.add(:date_of_birth, "date of birth must be within the gestation period of fathers death")
    end
  end

  def set_status_to_sponsored
    sponsored_status = OrphanSponsorshipStatus.find_by_name('Sponsored')
    self.update!(orphan_sponsorship_status: sponsored_status)
  end

  def set_status_to_unsponsored
    unsponsored_status = OrphanSponsorshipStatus.find_by_name('Unsponsored')
    self.update!(orphan_sponsorship_status: unsponsored_status)
  end
end
