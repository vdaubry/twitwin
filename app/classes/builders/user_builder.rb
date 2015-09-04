module Builders
  class UserBuilder
    attr_reader :callback
    def initialize
      @callback = Callback.new
    end

    def update(user:, params:)
      yield callback if block_given?

      if params[:email] && params[:email].match(/\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/).nil?
        user.errors.add(:email, 'is not a valid email address')
        return callback.on_failure.call
      end

      if user.update_attributes(params)
        callback.on_success.call
      else
        callback.on_failure.call
      end
    end

  end

  class Callback
    attr_reader :on_success, :on_failure
    def success(&block)
      @on_success = block
    end

    def failure(&block)
      @on_failure = block
    end
  end
end