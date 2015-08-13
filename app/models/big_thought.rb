class BigThought

  def self.populate_db()
    initial_run = (Position.count == 0)

    if initial_run
      ActiveRecord::Base.transaction { Position.generate_all }

      nothing = ComboAlg.make_single(OpenStruct.new(name: "Nothing", moves: '', id: nil))
      nothing.update(single: false)
    end

    puts "Starting BigThought.populate_db(): #{BaseAlg.count} base algs"
    start_time = Time.new

    root_algs_in_db = Set.new(BaseAlg.where('id = root_base_id').map(&:name))
    RootAlg.all.each do |ra|
      unless root_algs_in_db.include?(ra.name)
        BaseAlg.create_group(ra.name, ra.moves, ra.alg_variants)
      end
    end

    if initial_run
      Position.includes(:combo_algs).find_each do |pos|
        optimal_alg = pos.combo_algs[0]
        inverse_ll_code = Cube.new(BaseAlg.reverse(optimal_alg.moves)).standard_ll_code
        pos.update(best_alg_id: optimal_alg.id, optimal_alg_length: optimal_alg.length, inverse_ll_code: inverse_ll_code)
      end
    end

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