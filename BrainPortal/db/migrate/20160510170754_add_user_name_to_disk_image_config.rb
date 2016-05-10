class AddUserNameToDiskImageConfig < ActiveRecord::Migration
  def change
    add_column :disk_image_configs, :user_name, :string
  end
end
