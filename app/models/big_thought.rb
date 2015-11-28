class BigThought

  def self.populate_db()
    initial_run = (Position.count == 0)

    if initial_run
      ActiveRecord::Base.transaction { Position.generate_all }
    end
  end

  def self.combine(new_alg)
    RawAlg.where(combined: true).each do |old|
      ComboAlg.make_4(old, new_alg)
      ComboAlg.make_4(new_alg, old)
    end
    ComboAlg.make_4(new_alg, new_alg)
    new_alg.update(combined: true)
  end

  def self.combine_many(raw_algs)
    timed_transaction do
      raw_algs.each do |alg|
        combine(alg) unless alg.combined
      end
    end
    update_positions
  end

  # Update Positions table after adding RawAlgs
  def self.update_positions
    alg_counts = RawAlg.group(:position_id).count
    Position.find_each do |pos|
      pos.update(alg_count: alg_counts[pos.id], best_combo_alg_id: nil)
    end
  end

  # Run once and for all when we have optimal RawAlgs for all positions
  def self.initialize_positions
    puts "Initializing Position: best_alg_id, optimal_alg_length, inverse_id"
    timed_transaction do
      Position.find_each do |pos|
        optimal_alg = pos.raw_algs.first
        inverse_ll_code = Cube.new(Algs.reverse(optimal_alg.moves)).standard_ll_code
        inverse_id = Position.find_by_ll_code(inverse_ll_code).id
        pos.update(best_alg_id: optimal_alg.id, optimal_alg_length: optimal_alg.length, inverse_id: inverse_id)
      end
    end
  end

  def self.timed_transaction
    t1 = Time.now
    ActiveRecord::Base.transaction do
      yield
    end
    puts "Done in #{'%.2f' % (Time.now - t1)}"
  end

end