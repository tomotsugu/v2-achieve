class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.references :user, index: true, foreign_key: true
      t.string :title
      t.text :content
      t.datetime :deadline
      t.integer :charge_id
      t.boolean :done
      t.integer :status

      t.timestamps null: false
    end
  end
end
