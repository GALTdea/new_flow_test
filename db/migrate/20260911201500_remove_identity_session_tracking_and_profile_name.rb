class RemoveIdentitySessionTrackingAndProfileName < ActiveRecord::Migration[8.1]
  def up
    drop_table :user_sessions if table_exists?(:user_sessions)
    remove_column :users, :name, :string if column_exists?(:users, :name)
  end

  def down
    raise ActiveRecord::IrreversibleMigration,
          "Session tracking and profile names are intentionally outside the Starter App identity boundary."
  end
end
