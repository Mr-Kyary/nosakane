class CreateCompanies < ActiveRecord::Migration[6.1]
  def change
    create_table :companies do |t|
      t.integer :company_id
      t.string :company_name

      t.timestamps
    end
  end
end
