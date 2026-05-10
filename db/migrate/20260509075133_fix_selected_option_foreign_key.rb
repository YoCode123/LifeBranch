class FixSelectedOptionForeignKey < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :decisions, column: :selected_option_id

    add_foreign_key :decisions,
                    :options,
                    column: :selected_option_id,
                    on_delete: :nullify
  end
end
