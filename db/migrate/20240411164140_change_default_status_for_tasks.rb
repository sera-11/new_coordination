class ChangeDefaultStatusForTasks < ActiveRecord::Migration[7.0]
  def change
    change_column_default :tasks, :status, "Not started"
  end
end