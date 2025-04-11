class CollectFromOpenWRTJob < ApplicationJob
  queue_as :openwrt

  def perform(*args)
    LoadAll.call
  end
end
