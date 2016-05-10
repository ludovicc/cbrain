class RemoveDefaultImageTypeToDiskImageConfig < ActiveRecord::Migration
  def up
    remove_column :disk_image_configs, :default_image_type
  end

  def down
    add_column :disk_image_configs, :default_image_type, :string
  end
end
