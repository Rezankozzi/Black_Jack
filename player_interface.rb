# frozen_string_literal: true

module Interface
  DATA_MENU = [{ index: 1, title: 'Stand', action: :stand },
               { index: 2, title: 'Take card', action: :take_card },
               { index: 3, title: 'Open_cards', action: :cards_open }].freeze

  def menu(player)
    DATA_MENU.each do |hash|
      puts "#{hash[:index]}--#{hash[:title]}"
    end
    send make_choice(player.name), player
  end

  def total(text)
    puts "\n#{text}"
    puts '=============================='
    puts '||   player     |  money:   ||'
    puts '=============================='
    all_players.each do |player|
      puts "||  #{player.name.ljust(10)}  |   #{player.money.to_s.ljust(5)}$  ||"
    end
    puts '=============================='
  end

  def game_status
    puts "\nIn bank: #{bank} $."
    puts '================================================================='
    puts '||   player     |  cards:            |  points:     |   money: ||'
    puts '================================================================='
    all_players.each do |player|
      puts "||  #{player.name.ljust(10)}  | #{player.view_cards}|    #{player.view_points}    |   #{player.money}$   ||"
    end
    puts '================================================================='
  end

  private

  def input_user(text, param)
    input_valid = nil
    while input_valid != true
      print text
      input = $stdin.gets.chomp
      input_valid = input_valid?(input, param)
    end
    input
  end

  def cls
    system('cls') || system('clear')
    sleep 1
  end

  def input_valid?(text, param)
    if text !~ param
      puts "\nCheck input and return!"
    else
      true
    end
  end

  def make_choice(name)
    choice = input_user("#{name}, choice your action:", /^[123]$/)
    hash_with_method = DATA_MENU.find { |item| item[:index] == choice.to_i }
    hash_with_method[:action]
  end
end
