class CleanUpJob < ApplicationJob
  queue_as :clean_up

  def perform
    WiFiDevice.where.not('labels LIKE \'%"persistent"%\'')
              .and(WiFiDevice.where(updated_at: ..Settings.delete_unseen_after_days.days.ago)
                             .or(WiFiDevice.where(last_seen_at: ..Settings.delete_unseen_after_days.days.ago)))
              .each(&:destroy)
    WiFiNetwork.where(updated_at: ..Settings.delete_unseen_after_days.days.ago)
               .each(&:destroy)
    Router.where(updated_at: ..Settings.delete_unseen_after_days.days.ago)
          .each(&:destroy)
  end
end
