class CreateTutors < ActiveRecord::Migration[7.0]
  def up
    return if table_exists? :tutors

    create_table :tutors do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.references :course, null: false, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
  end

  def down
    drop_table :tutors if table_exists? :tutors
  end
end
