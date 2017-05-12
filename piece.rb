# require_relative 'board.rb'
require 'byebug'
class Piece
  attr_reader :color
  attr_accessor :position, :board
  def initialize(position, color, board)
    @position = position
    @color = color
    @board = board

    board[position] = self
  end

  def inspect
    [self.class,self.color,self.position]
  end

  def to_s
    symbol
  end

  def symbol
    self.symbol
  end

  def valid_moves
    moves.reject{|move| move_into_check?(move)}
  end

  def move_into_check?(end_pos)
    test_board = board.dup
    test_board.move_piece(self.position,end_pos)
    test_board.in_check?(self.color)
  end

end

module Slideable
  def moves
    grow_unblocked_moves_in_dir
  end

  private
  def move_dirs
    move_dirs
  end

  def horizontal_dirs
    [[1,0],
     [-1,0],
     [0,1],
     [0,-1]]
  end

  def diagonal_dirs
    [[-1,-1],
     [1,-1],
     [1,1],
     [-1,1]]
  end

  def capturable?(move,color)
    board[move] != nil && board[move].color != color
  end

  def on_board?(move)
    move[0] >= 0 && move[0] <= 7 && move[1] >= 0 && move[1] <= 7
  end

  def grow_unblocked_moves_in_dir
    total_moves = []
    move_dirs.each do |dir|
      dir_complete = false
      move = [self.position[0]+dir[0],self.position[1]+dir[1]]
      while on_board?(move) && !dir_complete
        # debugger
        until board[move].class != NullPiece
          # debugger
          total_moves << move if on_board?(move)
          move = [move[0]+dir[0],move[1]+dir[1]]
        end
        total_moves << move if on_board?(move) && capturable?(move,self.color)
        dir_complete = true
      end
    end
    total_moves
  end

end

module Stepable
  def on_board?(move)
    move[0] >= 0 && move[0] <= 7 && move[1] >= 0 && move[1] <= 7
  end

  def moves
    list_of_moves = move_diffs.map do |move|
      [self.position[0]+move[0],self.position[1]+move[1]]
    end
    list_of_moves.select! { |move| on_board?(move) }
    list_of_moves.reject! { |move| board.color_at(move) == self.color }

  end

  private
  def move_diffs
    move_diffs
  end
end