# frozen_string_literal: true

module Bookshelf
  module Views
    module Books
      class Edit < Bookshelf::View
        include Deps["repos.book_repo"]

        expose :book do |context:, id:|
          book_repo.get(id)
        end
        expose :form_submit, default: "Update Book"
        expose :form_method, default: "PATCH"

        expose :form_path do |context:, id:|
          context.routes.path(:book, id: id)
        end

        expose :errors do |context:|
          context.request.params.errors[:book] || {}
        end
      end
    end
  end
end
