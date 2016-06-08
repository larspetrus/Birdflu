class FmcController < ApplicationController
  def index
    @scramble  = params[:scramble]
    @niss_code = params[:niss]

    return unless @niss_code.present?

    @solution = FmcController.niss_to_alg(@niss_code)
    setup = @scramble || @solution
    reverse_setup = Algs.reverse(setup)

    segments = { normal: [], reverse: []}
    @steps = []
    FmcController.niss_decode(@niss_code).each do |segment|
      moves = segment.gsub('n', '')
      if segment.start_with?('n')
        reverse_setup += ' ' + moves
        setup = Algs.reverse(reverse_setup)
        @steps << OpenStruct.new(reversed: true, moves: moves, setup: reverse_setup)
        segments[:reverse].insert(0, Algs.reverse(moves))
      else
        setup += ' ' + moves
        reverse_setup = Algs.reverse(setup)
        @steps << OpenStruct.new(reversed: false, moves: moves, setup: setup)
        segments[:normal] << moves
      end
    end

    @solution_segments = segments[:normal] + segments[:reverse]
  end

  def self.niss_decode(coded)
    coded.gsub('(', '(n').split(/[\(\)]/).map(&:strip)
  end

  def self.niss_to_alg(coded)
    niss, regular  = self.niss_decode(coded).partition { |segment| segment.start_with?('n') }
    result_segments = (regular + niss.reverse.map{|moves| Algs.reverse(moves[1..-1])})
    result_segments.reduce('') {|alg, addon| ComboAlg.merge_moves(alg, addon)[:moves] }
  end

end
