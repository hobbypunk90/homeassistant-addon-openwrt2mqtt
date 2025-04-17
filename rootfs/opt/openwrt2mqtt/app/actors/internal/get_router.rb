# frozen_string_literal: true

class Internal::GetRouter < ApplicationActor
  prepend WhosGonnaCallMe

  output :router

  def call
    id = begin
           router = Router.new
           router.valid?
           router.id
         end

    self.router = Router.find_or_initialize_by(id:)
  end
end
