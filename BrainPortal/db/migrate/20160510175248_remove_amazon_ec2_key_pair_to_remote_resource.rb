class RemoveAmazonEc2KeyPairToRemoteResource < ActiveRecord::Migration
  def up
    remove_column :remote_resources, :amazon_ec2_key_pair
  end

  def down
    add_column :remote_resources, :amazon_ec2_key_pair, :string
  end
end
