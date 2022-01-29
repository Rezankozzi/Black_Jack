# frozen_string_literal: true

class Player
  attr_reader :name, :my_cards
  attr_accessor :money, :game_over

  def initialize(name)
    @name = name
    @money = 100
    @my_cards = []
  end

  def take_a_card(card_deck)
    puts "#{name} take a card."
    card = card_deck.take_card
    my_cards << card
  end

  def make_a_bet(object)
    self.money -= 10
    object.bank += 10
  end

  def stand
    puts "#{name} skip turn!"
  end

  def reset_attr
    my_cards.clear
    self.game_over = nil
  end

  def win(game)
    self.money += game.bank
    game.bank = 0
  end

  def my_turn(game)
    game.menu(self)
    game.too_match_points(name) if counting_cards > 21
    game.bankrupt << name if money.zero?
  end

  def view_cards
    cards = []
    my_cards.each { |card| cards << card.name(name, game_over) }
    cards.join('  ').ljust(20)
  end

  def view_points
    counting_cards.to_s.ljust(6)
  end

  def points
    @points = 0
    my_cards.each { |card| @points += card.number }
    @points
  end

  def counting_cards
    return points if points <= 21

    ace = my_cards.find_all { |card| card.number == 11 }
    ace.each { |card| card.number = 1 if points > 21 }
    points
  end
end
