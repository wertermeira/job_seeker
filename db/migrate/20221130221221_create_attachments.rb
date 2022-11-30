class CreateAttachments < ActiveRecord::Migration[7.0]
  def change
    create_table :attachments do |t|
      t.references :user, null: false, foreign_key: true
      t.string :file_path
      t.string :title
      t.integer :type

      t.timestamps
    end
  end
end
