class AddSupplierPartsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :supplier_parts, :integer
  end
end
