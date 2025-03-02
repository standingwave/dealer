class CardSet < ApplicationRecord
  has_many :cards
  has_many :card_set_cards, dependent: :destroy

  validates :name, presence: true

  def self.search(query)
    where("name ILIKE ?", "%#{query}%")
  end

  def self.by_game(game_id)
    where(game_id: game_id)
  end
  def self.by_name(name)
    where("name ILIKE ?", "%#{name}%")
  end

  def self.by_date(date)
    where("created_at >= ?", date)
  end

  def self.by_card_count(count)
    joins(:cards).group("card_sets.id").having("COUNT(cards.id) = ?", count)
  end

  def self.by_card_set_id(card_set_id)
    where(id: card_set_id)
  end
end
