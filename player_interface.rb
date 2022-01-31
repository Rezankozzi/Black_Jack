# frozen_string_literal: true

module Interface
  def menu(player)
    menu = menu_modify?(player.skip)
    reg_exp = ''
    menu.each do |hash|
      reg_exp += hash[:index].to_s
      puts "#{hash[:index]}--#{hash[:title]}"
    end
    send make_choice(player.name, menu, reg_exp), player
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

  def data_menu
    [{ index: 1, title: 'Stand', action: :stand },
     { index: 2, title: 'Take card', action: :take_card },
     { index: 3, title: 'Open_cards', action: :cards_open }]
  end

  def menu_modify?(skip)
    skip == 1 ? menu_modify!(skip) : data_menu
  end

  def menu_modify!(skip)
    menu = data_menu.reject { |item| item[:index] == skip }
    menu.map do |hash|
      hash[:index] = skip
      skip += 1
    end
    menu
  end

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

  def make_choice(name, menu, reg_exp)
    choice = input_user("#{name}, choice your action:", /^[#{reg_exp}]$/)
    hash_with_method = menu.find { |item| item[:index] == choice.to_i }
    hash_with_method[:action]
  end
end
