class Card < ApplicationRecord
  COLOR = %w[Colorless White Blue Black Red Green].freeze
  CARD_TYPE = %w[Creature Instant Sorcery Enchantment Artifact Land Planeswalker].freeze
  CONDITION = %w[Mint Near-Mint Very-Good Good Played Damaged].freeze
  RARITY = %w[Rare Uncommon Common].freeze

  belongs_to :card_set
  delegate :name, to: :card_set, prefix: :set, allow_nil: true

  validates :name, :description, presence: true
  validates :condition, inclusion: { in: CONDITION }

  def self.column_default(attribute)
    self.column_for_attribute(attribute).default
  end

  require "csv"
  def self.to_csv
    cards = all
    CSV.generate do |csv|
      csv << column_names
      cards.each do |card|
        csv << card.attributes.values_at(*column_names)
      end
    end
  end

  def gatherer_image_url
    "https://gatherer.wizards.com/Handlers/Image.ashx?multiverseid=#{self.gatherer_id}&type=card"
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
