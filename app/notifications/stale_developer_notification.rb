class StaleDeveloperNotification < ApplicationNotification
  deliver_by :database
  deliver_by :email, mailer: "DeveloperMailer", method: :stale

  param :developer

  def developer
    params[:developer]
  end
end
