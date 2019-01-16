class CreateCompany2s < ActiveRecord::Migration[5.2]
  def change
    create_table :company_2s do |t|
      t.string :name

      t.timestamps
    end
  end
end
