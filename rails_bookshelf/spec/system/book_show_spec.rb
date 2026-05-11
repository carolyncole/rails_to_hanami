require "rails_helper"

RSpec.describe "book/", type: :system do

    it "visits the home page and shows a welcome message" do
      book = Book.create(title: "book 1", author: "author 1")
      Book.create(title: "book 2", author: "author 2")
      visit "/books/#{book.id}"
  
      expect(page).to have_content "Title: book 1"
      expect(page).not_to have_content "Title: book 2"
      expect(page).to have_content "Author: author 1"
      expect(page).not_to have_content "Author: author 2"
    end
  end
