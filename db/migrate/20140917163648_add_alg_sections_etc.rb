class AddAlgSectionsEtc < ActiveRecord::Migration
  def change
    add_column :algs, :mv_start, :string
    add_column :algs, :mv_cancel1, :string
    add_column :algs, :mv_merged, :string
    add_column :algs, :mv_cancel2, :string
    add_column :algs, :mv_end, :string

    add_column :positions, :best_alg_id, :integer
  end
end
