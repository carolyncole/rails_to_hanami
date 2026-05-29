# frozen_string_literal: true

module Bookshelf
  module Views
    module Books
      class New < Bookshelf::View
        include Deps["repos.book_repo"]

        expose :form_submit, default: "Create Book"
        expose :book do |context:|
          context.request.params[:book]
        end
      end
    end
  end
end
