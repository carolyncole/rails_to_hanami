# frozen_string_literal: true

module Bookshelf
  module Repos
    class BookRepo < Bookshelf::DB::Repo
      def create(attributes)
        attributes[:created_at] = Time.now
        attributes[:updated_at] = Time.now
        books.changeset(:create, attributes).commit
      end
          
      def last = books.last
      def get(id) = books.by_pk(id).one!
    end
  end
end
