class DemoController < ApplicationController
  def index
    all_variations_algs = []

    all_variations_algs.concat BigThought.alg_variants("Sune",  "F U F' U F U2 F'")
    all_variations_algs.concat BigThought.alg_variants("Allan", "F2 U R' L F2 R L' U F2")
    all_variations_algs.concat BigThought.alg_variants("Bruno", "L U2 L2 U' L2 U' L2 U2 L")

    primary_algs = all_variations_algs.select { |alg| alg.primary }

    @positions = {}

    primary_algs.each do |alg1|
      add(alg1)
      all_variations_algs.each { |alg2| add(LlAlg.combo(alg1, alg2)) }
    end

    puts "-"*88
    puts @positions.size
    @positions.each do |key, value|
      puts "#{key} - #{value.map(&:nl)}"
    end

    @cube1 = Cube.new().setup_alg("F U F' U F U2 F' U2")
  end

  def add(alg)
    ll_code = alg.solves_ll_code
    @positions[ll_code] ||= []
    @positions[ll_code] << alg
    @positions[ll_code].sort! { |x,y| x.length <=> y.length }
  end
end
