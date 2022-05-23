class StaleDeveloperNotification < ApplicationNotification
  deliver_by :database
  deliver_by :email, mailer: "DeveloperMailer", method: :stale

  param :developer

  def developer
    params[:developer]
  end

  def title
    t("notifications.stale_developer_profile")
  end

  def url
    edit_developer_path(developer)
  end
end
