class CreateProviderOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :provider_orders do |t|
      t.references :provider, null: false, foreign_key: true
      t.string :product_sku, null: false
      t.text :product_desc, null: false
      t.integer :purchase_quantity, null: false
      t.boolean :delivered, null: false, default: false
      t.string :source_event_id, null: false

      t.timestamps
    end

    add_index :provider_orders, :source_event_id, unique: true
  end
end
