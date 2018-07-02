class CreateRelatiionships < ActiveRecord::Migration
  def change
    create_table :relatiionships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps null: false
    end
  end
end
