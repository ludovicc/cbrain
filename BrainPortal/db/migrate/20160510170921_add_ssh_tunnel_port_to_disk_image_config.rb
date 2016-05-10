class AddSshTunnelPortToDiskImageConfig < ActiveRecord::Migration
  def change
    add_column :disk_image_configs, :ssh_tunnel_port, :string
  end
end
