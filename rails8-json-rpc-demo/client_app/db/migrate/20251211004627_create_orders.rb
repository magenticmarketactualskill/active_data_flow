class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :product_name, null: false
      t.integer :quantity, default: 1
      t.integer :price_cents, null: false

      t.timestamps
    end

    # Note: Rails automatically creates an index for foreign keys
  end
end
