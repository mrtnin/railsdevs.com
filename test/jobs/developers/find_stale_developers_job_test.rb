require "test_helper"

class Developers::FindStaleDevelopersJobTest < ActiveJob::TestCase
  include DevelopersHelper

  test "succesfully scheduled cron job" do
    assert Sidekiq::Cron::Job.find "find_stale_developers_job"
  end

  test "it runs succesfully" do
    travel_to 31.days.ago
    create_developer
    travel_back

    assert_performed_jobs 1, only: Developers::FindStaleDevelopersJob do
      Developers::FindStaleDevelopersJob.perform_later
    end
  end
end
