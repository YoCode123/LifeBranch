class SolidQueueTestJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info "===== Solid Queue Test Job Executed! ====="
  end
end
