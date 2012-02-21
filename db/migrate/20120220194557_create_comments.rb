class CreateComments < ActiveRecord::Migration
    def change
        create_table :comments do |t|
            t.references :user, :null => false
            t.text :text, :null => false
            t.references :story, :null => false
            t.timestamps
        end
    end
end
