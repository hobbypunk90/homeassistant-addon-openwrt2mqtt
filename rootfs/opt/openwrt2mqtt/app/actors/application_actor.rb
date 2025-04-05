# frozen_string_literal: true

class ApplicationActor < Actor
  def logger
    @@logger ||= Logger.new($stdout)
  end
end
