class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :full_name
      t.string :email
      t.string :password_digest
      t.column :role, :enum, :limit => [:admin, :member, :viewer], :defailt => :member

      t.timestamps
    end
  end
end
