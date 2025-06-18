class ClearInBatchesJob < ApplicationJob
  def perform
    clear_in_batches
  end

  def clear_in_batches(batch_size: 500, sleep_between_batches: 0, created_at: ..1.day.ago)
    loop do
      records_deleted = SolidQueue::Job.where(created_at:).limit(batch_size).delete_all
      sleep(sleep_between_batches) if sleep_between_batches > 0
      break if records_deleted == 0
    end
  end
end
