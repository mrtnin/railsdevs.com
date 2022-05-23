class Developers::FindStaleDevelopersJob < ApplicationJob
  queue_as :default

  def perform
    stale_developers = StaleDevelopersQuery.stale
    stale_developers.each(&:notify_as_stale)
  end
end
