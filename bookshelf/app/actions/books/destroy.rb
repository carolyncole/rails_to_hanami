# frozen_string_literal: true

module Bookshelf
  module Actions
    module Books
      class Destroy < Bookshelf::Action
        def handle(request, response)
          response.body = self.class.name
        end
      end
    end
  end
end
