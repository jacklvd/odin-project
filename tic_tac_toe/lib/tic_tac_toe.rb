# frozen_string_literal: true

require_relative "tic_tac_toe/version"

=begin
Build a tic-tac-toe game on the command line where two human players can play against 
each other and the board is displayed in between turns.
The game should be able to detect when a player has won, or if the game is a draw.
=end

functionality = [
  "Display the tic-tac-toe board on the command line",
  "Allow two human players to take turns placing their marks (X and O) on the board",
  "Detect when a player has won by getting three of their marks in a row (horizontally, vertically, or diagonally)",
  "Detect when the game is a draw (when all spaces on the board are filled and no player has won)",
  "Provide a way for players to restart the game after it ends",
  "Allow a player to play against a bot using the Minimax algorithm"
]

func = functionality.each_with_index do |func, index|
  puts "#{index + 1}. #{func}"
end

board = [
  [" ", " ", " "],
  [" ", " ", " "],
  [" ", " ", " "]
]

module TicTacToe
  class Error < StandardError; end


  class Board
    def initialize
      @board = Array.new(3) { Array.new(3, " ") }
    end

    def display
      @board.each do |row|
        puts row.join(" | ")
        puts "--+---+--" unless row.equal?(@board.last)
      end
    end

    def place_mark(row, col, mark)
      if @board[row][col] == " "
        @board[row][col] = mark
        true
      else
        false
      end
    end

    def full?
      @board.flatten.none? { |cell| cell == " " }
    end

    def winner?
      rows = @board
      cols = @board.transpose
      diagonals = [
        [@board[0][0], @board[1][1], @board[2][2]],
        [@board[0][2], @board[1][1], @board[2][0]]
      ]

      (rows + cols + diagonals).any? { |line| line.uniq.size == 1 && line.first != " " }
    end
  end

  class Bot
    def initialize(mark)
      @mark = mark
      @opponent_mark = mark == "X" ? "O" : "X"
    end

    def best_move(board)
      best_score = -Float::INFINITY
      move = nil

      board.each_with_index do |row, i|
        row.each_with_index do |cell, j|
          if cell == " "
            board[i][j] = @mark
            score = minimax(board, false)
            board[i][j] = " "
            if score > best_score
              best_score = score
              move = [i, j]
            end
          end
        end
      end

      move
    end

    private

    def minimax(board, is_maximizing)
      return 1 if winner?(board, @mark)
      return -1 if winner?(board, @opponent_mark)
      return 0 if board.flatten.none? { |cell| cell == " " }

      if is_maximizing
        best_score = -Float::INFINITY
        board.each_with_index do |row, i|
          row.each_with_index do |cell, j|
            if cell == " "
              board[i][j] = @mark
              score = minimax(board, false)
              board[i][j] = " "
              best_score = [score, best_score].max
            end
          end
        end
        best_score
      else
        best_score = Float::INFINITY
        board.each_with_index do |row, i|
          row.each_with_index do |cell, j|
            if cell == " "
              board[i][j] = @opponent_mark
              score = minimax(board, true)
              board[i][j] = " "
              best_score = [score, best_score].min
            end
          end
        end
        best_score
      end
    end

    def winner?(board, mark)
      rows = board
      cols = board.transpose
      diagonals = [
        [board[0][0], board[1][1], board[2][2]],
        [board[0][2], board[1][1], board[2][0]]
      ]

      (rows + cols + diagonals).any? { |line| line.all? { |cell| cell == mark } }
    end
  end

  class Game
    def initialize
      @board = Board.new
      @current_player = "X"
      @bot = nil
    end

    def play
      puts "Do you want to play against a bot? (yes/no): "
      play_with_bot = gets.chomp.downcase == "yes"
      @bot = Bot.new("O") if play_with_bot

      loop do
        @board.display

        if @bot && @current_player == "O"
          row, col = @bot.best_move(@board.instance_variable_get(:@board))
          puts "Bot chooses: #{row} #{col}"
        else
          row, col = nil, nil

          loop do
            puts "Player #{@current_player}, enter your move (row and column, e.g., '1 2'): "
            input = gets.chomp.split.map(&:to_i)

            if input.size == 2 && input.all? { |num| num.between?(0, 2) }
              row, col = input
              break
            else
              puts "Invalid input. Please enter two numbers between 0 and 2, separated by a space."
            end
          end
        end

        if @board.place_mark(row, col, @current_player)
          if @board.winner?
            @board.display
            puts "Player #{@current_player} wins!"
            break
          elsif @board.full?
            @board.display
            puts "It's a draw!"
            break
          else
            switch_player
          end
        else
          puts "Invalid move. The cell is already taken. Try again."
        end
      end
    end

    private

    def switch_player
      @current_player = @current_player == "X" ? "O" : "X"
    end
  end
end

# Uncomment the lines below to play the game
game = TicTacToe::Game.new
game.play
