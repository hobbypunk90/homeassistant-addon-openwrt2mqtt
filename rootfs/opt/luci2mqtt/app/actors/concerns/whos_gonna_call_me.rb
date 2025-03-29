# frozen_string_literal: true

module WhosGonnaCallMe
  def call
    logger.debug { "#{self.class.name}#call" } if Settings.debug
    super
  end
end
