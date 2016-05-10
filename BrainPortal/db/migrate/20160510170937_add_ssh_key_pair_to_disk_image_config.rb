class AddSshKeyPairToDiskImageConfig < ActiveRecord::Migration
  def change
    add_column :disk_image_configs, :ssh_key_pair, :string
  end
end
