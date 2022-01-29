# frozen_string_literal: true

class Game
  include Interface
  include CheckWinner
  attr_reader :all_players, :bankrupt
  attr_accessor :card_deck, :bank, :winner, :turn, :game_over, :drawn_game

  def initialize
    @bank = 0
    @bankrupt = []
  end

  def start_game
    create_players
    loop do
      all_reset
      break if any_bankrupt?

      new_game
      break unless play_again?
    end
  end

  def too_match_points(name)
    text = "#{name} has too match points!"
    open_cards(text) if game_over.nil?
  end

  private

  def any_bankrupt?
    if bankrupt.empty?
      false
    else
      total("The player #{bankrupt[0]} does not have the money to continue the game! Game over!")
      true
    end
  end

  def create_players
    @all_players ||= []
    user_name = input_user('Input your name (any 3-6 word character):', /^\w{3,6}$/)
    @all_players << Player.new(user_name) << Dealer.new
  end

  def all_reset
    all_players.each(&:reset_attr)
    self.card_deck = []
    self.winner, self.game_over, self.turn, self.drawn_game = nil
  end

  def new_game
    total('New game started!')
    preparing_game
    loop do
      check_open_cards
      break unless game_over.nil?

      players_turn
    end
  end

  def play_again?
    if input_user('Do you want play again?', /^[yYnN]$/) !~ /^[yY]$/
      puts 'The game is over! Good by!'
      false
    else
      true
    end
  end

  def preparing_game
    self.turn = [] + all_players
    create_card_deck
    deal
    all_players.each { |player| player.make_a_bet(self) }
  end

  def check_open_cards
    text = "\n 6 cards in the game! The cards will be opened!"
    open_cards(text) if cards_in_game == 6 && game_over.nil?
  end

  def players_turn
    game_status
    player = turn.first
    puts "\n Now it's the #{player.name}'s turn. "
    player.my_turn(self)
    turn.rotate!
  end

  def create_card_deck
    self.card_deck = CardDeck.new.cards_shuffle
  end

  def deal
    all_players.each do |player|
      2.times do
        player.my_cards << card_deck.take_card
      end
    end
  end

  def stand(player)
    player.stand
  end

  def take_card(player)
    player.take_a_card(card_deck)
  end

  def drawn_game!
    puts 'Drawn game! Bets are returned to the players!'
    all_players.each { |player| player.money += bank / 2 }
    self.bank = 0
    self.drawn_game = true
  end

  def game_is_over
    winner.win(self)
    puts "\n#{winner.name} is winner!!"
  end

  def cards_in_game
    cards_in_game = 0
    all_players.each do |player|
      cards_in_game += player.my_cards.size
    end
    cards_in_game
  end

  def cards_open(player)
    text = "#{player.name}`s choice is--'open cards' "
    open_cards(text)
  end

  def open_cards(text)
    puts text
    all_players.each { |player| player.game_over = true }
    self.game_over = true
    game_status
    who_winner?
    total('Total results:')
  end
end
