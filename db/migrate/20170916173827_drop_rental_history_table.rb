class DropRentalHistoryTable < ActiveRecord::Migration[5.1]
  def up
    drop_table :rental_histories
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
