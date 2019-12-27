class AddPaystackToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :paystack_last_4, :string
    add_column :users, :paystack_id, :string
  end
end
