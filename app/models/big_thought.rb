class BigThought

  def self.populate_db()
    if Position.count == 0
      ActiveRecord::Base.transaction { Position.generate_all }
    end

    unless ComboAlg.exists?(base_alg1: nil, base_alg2: nil)
      ComboAlg.make_single(OpenStruct.new(name: "Nothing", moves: '', id: nil))
    end

    puts "Starting BigThought.populate_db(): #{BaseAlg.count} base algs"
    start_time = Time.new

    RootAlgs.all.each do |ad|
      unless BaseAlg.exists?(name: ad.name)
        BaseAlg.create_group(ad.name, ad.moves, ad.variants)
      end
    end

    Position.includes(:combo_algs).find_each {|pos| pos.update(optimal_alg_length: pos.combo_algs[0].length)}

    puts "After BigThought.populate_db(): #{BaseAlg.count} base algs. Took #{Time.new - start_time}"
  end

  def self.combine(new_base_alg)
    ActiveRecord::Base.transaction do
      BaseAlg.where(combined: true).each do |old|
        ComboAlg.make_4(old, new_base_alg)
        ComboAlg.make_4(new_base_alg, old)
      end
      ComboAlg.make_4(new_base_alg, new_base_alg)
      new_base_alg.update(combined: true)
    end
  end

  def self.alg_label(moves)
    result = ""
    moves.split(' ').each do |move|
      result += move
      break unless result.ends_with? '2'
    end
    result
  end
end