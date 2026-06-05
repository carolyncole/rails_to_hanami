# frozen_string_literal: true

module Bookshelf
  module Repos
    class BookRepo < Bookshelf::DB::Repo
      def create(attributes)
        attributes[:created_at] = Time.now
        attributes[:updated_at] = Time.now
        books.changeset(:create, attributes).commit
      end

      def update(id, attributes)
        books.by_pk(id).changeset(:update, attributes).commit
      end

      def delete(id)
        books.by_pk(id).changeset(:delete).commit
      end

      def last = books.last
      def count = books.count
      def get(id) = books.by_pk(id).one!
    end
  end
end
