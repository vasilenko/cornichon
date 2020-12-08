class CreateLinks < ActiveRecord::Migration[6.0]
  def change
    create_table :links do |t|
      t.string :url, null: false
      t.string :slug, limit: 6, null: false
      t.integer :visit_count, null: false, default: 0
    end

    add_index :links, :url, unique: true
    add_index :links, :slug, unique: true
  end
end
