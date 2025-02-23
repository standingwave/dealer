class Card < ApplicationRecord
  COLOR = %w[White Blue Black Red Green Colorless].freeze
  CARD_TYPE = %w[Creature Instant Sorcery Enchantment Artifact Land Planeswalker].freeze
  CONDITIONS = %w[Mint Near-Mint Very-Good Good Played Damaged].freeze
  RARITY = %w[Rare Uncommon Common].freeze

  validates :name, :description, presence: true
  # validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  # validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :condition, inclusion: { in: CONDITIONS }

  def self.column_default(attribute)
    self.column_for_attribute(attribute).default
  end
end
# == Schema Information
#
# Table name: cards
#
#  id          :bigint           not null, primary key
#  name        :string(255)
#  description :text(65535)
#  quantity    :integer
#  price       :decimal(, )
#  condition   :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
