class AddTaskSlotsToDiskImageConfig < ActiveRecord::Migration
  def change
    add_column :disk_image_configs, :task_slots, :string
  end
end
