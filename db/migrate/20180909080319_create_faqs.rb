class CreateFaqs < ActiveRecord::Migration[5.1]
  def change
    create_table :faqs do |t|
    t.string :question
    t.string :question_caps
      t.string :answer
      t.string :link

    end
  end
end
