class Character < ApplicationRecord
  belongs_to :player
  belongs_to :game

  validates_inclusion_of :role, in: %(earther explorer)

  delegate :email, to: :player, prefix: true

  # TODO: use an enum for the role instead
  def earther?  = role.inquiry.earther?
  def explorer? = role.inquiry.explorer?
end
