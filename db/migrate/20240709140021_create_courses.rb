class CreateCourses < ActiveRecord::Migration[7.0]
  def up
    return if table_exists? :courses

    create_table :courses do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.datetime :deleted_at

      t.timestamps
    end
  end

  def down
    drop_table :courses if table_exists? :courses
  end
end
