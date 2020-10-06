class NotificationsController < ApplicationController
  def index
  end

  def destroy
    @notification = Notification.find(params[:id])
    @notification.destroy
    redirect_to trips_path, notice: 'Notification removed'
  end
end
