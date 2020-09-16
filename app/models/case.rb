class Case < ApplicationRecord
  belongs_to :country
  after_commit :async_update

  private

  def async_update
    UpdateCasesJob.perform_later(self)
  end
end
