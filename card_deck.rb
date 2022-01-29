# frozen_string_literal: true

class CardDeck
  attr_reader :cards

  def initialize
    @cards = Card.create_cards
  end

  def cards_shuffle
    cards.shuffle!
    self
  end

  def take_card
    cards.delete(cards.sample)
  end
end
