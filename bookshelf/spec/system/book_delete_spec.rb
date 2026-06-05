require "spec_helper"
RSpec.describe "books/new", type: :system do

    it "visits the home page and shows a welcome message" do
      book = Bookshelf::Repos::BookRepo.new.create(title: "book 1", author: "author 1")
      visit "/books/#{book.id}"

      expect(page).to have_content "Title: book 1"
      expect(page).to have_content "Author: author 1"

      expect { click_on "Destroy this book" }.to change { Bookshelf::Repos::BookRepo.new.count }.by(-1)
      expect(page).to have_content("Book was successfully destroyed")
      expect(page).to have_content "Welcome to the Bookshelf"
    end
  end
