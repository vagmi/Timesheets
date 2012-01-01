class CreateTimeEntries < ActiveRecord::Migration
  def change
    create_table :time_entries do |t|
      t.integer :project_id
      t.integer :category_id
      t.text :description
      t.integer :minutes
      t.integer :user_id
      t.date :date
      t.boolean :billable

      t.timestamps
    end
  end
end
