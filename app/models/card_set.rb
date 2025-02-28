class CardSet < ApplicationRecord
  has_many :cards
  has_many :card_set_cards, dependent: :destroy

  validates :name, presence: true

  SET_NAMES = ["Alpha", "Beta", "Unlimited", "Arabian Nights", "Antiquities", "Legends", "The Dark", "Fallen Empires",
    "Fourth Edition", "Ice Age", "Chronicles", "Homelands", "Alliances", "Mirage", "Visions", "Weatherlight", "Tempest",
    "Stronghold", "Exodus", "Urza's Saga", "Urza's Legacy", "Urza's Destiny", "Mercadian Masques", "Nemesis",
    "Prophecy", "Invasion", "Planeshift", "Apocalypse", "Odyssey", "Torment", "Judgment", "Onslaught", "Legions",
    "Scourge", "Mirrodin", "Darksteel", "Fifth Dawn", "Champions of Kamigawa", "Betrayers of Kamigawa",
    "Saviors of Kamigawa", "Ravnica: City of Guilds", "Guildpact", "Dissension", "Coldsnap", "Time Spiral",
    "Planar Chaos", "Future Sight", "Lorwyn", "Morningtide", "Shadowmoor", "Eventide", "Shards of Alara"]

    
  def self.search(query)
    where('name ILIKE ?', "%#{query}%")
  end

  def self.by_game(game_id)
    where(game_id: game_id)
  end
  def self.by_name(name)
    where('name ILIKE ?', "%#{name}%")
  end

  def self.by_date(date)
    where('created_at >= ?', date)
  end

  def self.by_card_count(count)
    joins(:cards).group('card_sets.id').having('COUNT(cards.id) = ?', count)
  end

  def self.by_card_set_id(card_set_id)
    where(id: card_set_id)
  end
end
