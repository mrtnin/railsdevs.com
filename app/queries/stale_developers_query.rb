class StaleDevelopersQuery
  EARLIEST_TIME = 30.days.ago.beginning_of_day

  def self.stale
    Developer.where(updated_at: ..EARLIEST_TIME)
  end

  def self.recently_notified
    developer_global_ids = Notification
      .select("params -> 'developer' -> '_aj_globalid' as developer_gid")
      .where(created_at: EARLIEST_TIME..)
      .map(&:developer_gid)
      .compact
      .uniq

    GlobalID::Locator.locate_many(developer_global_ids)
  end

  def self.stale_and_not_notified
    recently_notified_ids = recently_notified.map(&:id)
    stale.where.not(id: recently_notified_ids)
  end
end
