# frozen_string_literal: true

class Dealer < Player
  def initialize(name = 'Dealer')
    super
  end

  def my_turn(game)
    if points >= 17
      stand
    else
      take_a_card(game.card_deck)
    end
    game.bankrupt << name if money.zero?
  end

  def view_points
    game_over.nil? ? '**    ' : super
  end
end
