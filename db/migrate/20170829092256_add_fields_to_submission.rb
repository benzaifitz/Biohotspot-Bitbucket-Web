class AddFieldsToSubmission < ActiveRecord::Migration[5.0]
  def change
    add_column :submissions, :sample_photo, :string
    add_column :submissions, :monitoring_photo, :string
    add_column :submissions, :dieback , :string
    add_column :submissions, :leaf_tie_month , :boolean, default: false
    add_column :submissions, :seed_borer , :boolean, default: false
    add_column :submissions, :loopers , :boolean, default: false
    add_column :submissions, :grazing , :boolean, default: false
    add_column :submissions, :field_notes , :text
  end
end
