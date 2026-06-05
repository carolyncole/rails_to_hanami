# frozen_string_literal: true

module Bookshelf
  class Settings < Hanami::Settings
    # Define your app settings here, for example:
    #
    # setting :my_flag, default: false, constructor: Types::Params::Bool
    setting :session_secret, constructor: Types::String, default: "____local_development_secret_only____local_development_secret_only___"
  end
end
