class RemoveCostFactorToRemoteResource < ActiveRecord::Migration
  def up
    remove_column :remote_resources, :cost_factor
  end

  def down
    add_column :remote_resources, :cost_factor, :string
  end
end
