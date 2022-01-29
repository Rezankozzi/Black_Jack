# frozen_string_literal: true

module CheckWinner
  private

  def who_winner?
    drawn_game?
    define_winner if drawn_game.nil?
  end

  def define_winner
    self.winner = check_range(4..21) if check_range(22..33).size == 1
    self.winner = check_range(4..21).max_by(&:counting_cards)
    game_is_over
  end

  def drawn_game?
    players_points = all_players.map(&:counting_cards)
    drawn_game! if check_range(22..33).size == 2 || players_points.uniq.size == 1
  end

  def check_range(range)
    all_players.select { |player| range.include?(player.counting_cards) }
  end
end
