require "test_helper"

class StaleDevelopersQueryTest < ActiveSupport::TestCase
  include DevelopersHelper

  test ".stale returns developers with older than 30 day profile" do
    travel_to(31.days.ago)
    stale_developer = create_developer
    travel_back
    fresh_developer = create_developer

    records = StaleDevelopersQuery.stale
    refute_includes records, fresh_developer
    assert_includes records, stale_developer
  end

  test ".recently_notified returns developers who recently received stale notifications" do
    travel_to(31.days.ago)
    stale_developer = create_developer
    notified_developer = create_developer
    travel_back
    notified_developer.notify_as_stale

    records = StaleDevelopersQuery.recently_notified
    refute_includes records, stale_developer
    assert_includes records, notified_developer
  end

  test ".stale_and_not_notified returns stale developers with no or older than 30 days notification" do
    travel_to(31.days.ago)
    stale_developer = create_developer
    notified_developer = create_developer
    travel_back
    notified_developer.notify_as_stale

    records = StaleDevelopersQuery.stale_and_not_notified
    refute_includes records, notified_developer
    assert_includes records, stale_developer
  end
end
