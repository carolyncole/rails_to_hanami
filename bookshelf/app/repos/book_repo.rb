# frozen_string_literal: true

module Bookshelf
  module Repos
    class BookRepo < Bookshelf::DB::Repo

      def all = books.to_a

      def create(attributes)
        attributes[:created_at] = Time.now
        attributes[:updated_at] = Time.now
        books.changeset(:create, attributes).commit
      end

      def count = books.count

      def delete(id)
        books.by_pk(id).changeset(:delete).commit
      end

      def get(id) = books.by_pk(id).one!

      def last = books.last

      def update(id, attributes)
        attributes[:updated_at] = Time.now
        books.by_pk(id).changeset(:update, attributes).commit
      end
    end
  end
end
