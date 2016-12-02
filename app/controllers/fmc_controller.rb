class FmcController < ApplicationController

  class Segment
    attr_reader :reversed, :moves
    attr_accessor :setup

    def initialize(b_code)
      nsplit = b_code.split('!')
      @reversed =(nsplit.size == 2)
      @moves = nsplit.last
    end

    def self.from_code(niss_code)
      niss_code.gsub('(', '(!').split(SPLIT_REX).map(&:strip).reject{ |s| s.blank? }.map{|b_code| Segment.new(b_code)}
    end

    def packed
      packed = Algs.pack(@moves)
      @reversed ? "(#{packed})" : packed
    end
  end

  SPLIT_REX = /[\(\)]/

  def index
    setup_leftbar
    @example = params[:example] == '1'
    if @example
      params[:s] = 'lublbrqdqruRpnln1rDur'
      params[:n] = 'pq(pl)Pdf(qpPb)BnRUqrB(bnPURBu)'
    end
    @scramble  = params[:scramble] || Algs.unpack(params[:s])
    @niss_code = params[:niss] || FmcController.unpack(params[:n])

    return unless @niss_code.present?

    @solution = FmcController.niss_to_alg(@niss_code)
    setup = @scramble || @solution
    reverse_setup = Algs.reverse(setup)

    parts = { forward: [], reverse: [] }
    @steps = Segment.from_code(@niss_code)
    @steps.each do |segment|
      if segment.reversed
        reverse_setup += ' ' + segment.moves
        setup = Algs.reverse(reverse_setup)
        segment.setup = reverse_setup
        parts[:reverse].insert(0, Algs.reverse(segment.moves))
      else
        setup += ' ' + segment.moves
        reverse_setup = Algs.reverse(setup)
        segment.setup = setup
        parts[:forward] << segment.moves
      end
    end

    @solution_parts = parts[:forward] + parts[:reverse]
  end

  def self.niss_to_alg(niss_code)
    reversed, forward = Segment.from_code(niss_code).partition { |segment| segment.reversed }
    result_segments = (forward.map{|seg| seg.moves} + reversed.reverse.map{|seg| Algs.reverse(seg.moves)})
    result_segments.reduce('') {|alg, addon| Algs.merge_moves(alg, addon)[:moves] }
  end

  def self.unpack(packed_niss)
    return '' if packed_niss.blank?
    self.partitions(packed_niss).map{|p| p.match(SPLIT_REX) ? p : Algs.unpack(p) }.join.gsub('(', ' (').gsub(')', ') ').strip
  end

  def self.partitions(to_split)
    [].tap do |result|
      begin
        parts = to_split.partition(/[\(\)]/)
        result << parts[0] << parts[1]
        to_split = parts[2]
      end until to_split.blank?
      result.reject{|s| s.blank?}
    end
  end

end
