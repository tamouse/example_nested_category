class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      
      # Changing this to separate out the index and foreign key specification
      # because for Postgresql (maybe MySQL, too). but not Sqlite3, the table
      # needs to be defined before you can reference it with an
      # index. Rails migration generators can't figure out that you're
      # trying to make a self-reference and do the right thing. As
      # long as the other table is already defined, the usual way
      # works fine.

      # Following works in Sqlite3:
      # t.belongs_to :parent, index: true, foreign_key: true

      # Following for PG:
      t.integer :parent_id

      t.timestamps null: false
    end

    # In PG, add the foreign key after the table is created:
    add_foreign_key :categories, :categories, column: :parent_id, primary_key: :id
  end
end

# It might be a better practice to do the indexes/fkeys like this all
# the time, anyway.
