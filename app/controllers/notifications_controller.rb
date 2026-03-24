class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.recent
    current_user.notifications.unread.update_all(read: true)
  end
end
