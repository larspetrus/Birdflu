class RenameSpecialnesses < ActiveRecord::Migration
  def change
    [%w(FU RU), %w(FUB RUL), %w(LFR RFL), %w(UFD URD), %w(FDB RDL)].each do |old, new|
      execute "UPDATE raw_algs SET specialness='#{new}' WHERE specialness='#{old}'"
    end
  end
end
