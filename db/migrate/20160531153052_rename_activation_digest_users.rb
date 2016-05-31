class RenameActivationDigestUsers < ActiveRecord::Migration
  def change
  	rename_column :users, :activation_diges, :activation_digest
  end
end
