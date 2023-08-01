# frozen_string_literal: true

class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :source
      t.json :payload

      t.timestamps
    end
  end
end
