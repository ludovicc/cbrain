class AddBootTimeoutToDiskImageConfig < ActiveRecord::Migration
  def change
    add_column :disk_image_configs, :boot_timeout, :string
  end
end
