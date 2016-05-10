class AddInstanceTypeToDiskImageConfig < ActiveRecord::Migration
  def change
    add_column :disk_image_configs, :instance_type, :string
  end
end
