# frozen_string_literal: true

class Card
  attr_accessor :number

  CARDS_SUITS = %w[♦ ♠ ♥ ♣].freeze
  CARDS_RANKS = %w[2 3 4 5 6 7 8 9 10 Jack Queen King Ace].freeze

  class << self
    def create_cards
      all_cards = []
      CARDS_SUITS.each do |suit|
        CARDS_RANKS.each do |rank|
          name = "#{rank}#{suit}"
          number = %w[Jack Queen King Ace].include?(rank) ? 10 : rank.to_i
          all_cards << Card.new(rank, name, number)
        end
      end
      all_cards
    end
  end

  def initialize(rank, name, number)
    @rank = rank
    @name = name
    @number = rank == 'Ace' ? 11 : number
  end

  def name(name, game_over)
    name == 'Dealer' && game_over.nil? ? '**' : @name
  end
end
