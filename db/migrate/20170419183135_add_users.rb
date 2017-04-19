class AddUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :first_name
      t.string :last_name
      t.timestamps null: false
    end

    create_table :organizations do |t|
      t.string :name, null: false
      t.timestamps null: false
    end

    create_table :memberships do |t|
      t.integer :organization_id, null: false
      t.integer :user_id, null: false
      t.boolean :owner, default: false, null: false
      t.timestamps null: false
    end
    add_foreign_key :memberships, :organizations, on_delete: :cascade
    add_foreign_key :memberships, :users, on_delete: :cascade
  end
end
