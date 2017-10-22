# frozen_string_literal: true

module Spotify
  class SDK
    class Initialization
      CLASSES = %i[
        OAuthAccessToken
        QueryString
        URLString
        PlainString
        QueryHash
      ].freeze

      class << self
        def detect(subject)
          klasses = CLASSES.map do |klass_name|
            ("Spotify::SDK::Initialization::%s" % klass_name).constantize.new(subject)
          end

          matches = klasses.select(&:should_perform?)

          case matches.size
          when 1
            matches.first.perform
          when 0
            raise Spotify::Errors::InitializationObjectInvalidError
          else
            raise Spotify::Errors::InitializationObjectDuplicationError
          end
        end
      end
    end
  end

  class Errors
    ##
    # A Error class for when the initialization subjectect is not valid (see `initialize(subject)` for more info).
    #
    class InitializationObjectInvalidError < StandardError; end

    ##
    # A Error class for when the initialization subjectect matches against multiple selectors.
    #
    class InitializationObjectDuplicationError < StandardError; end
  end
end
