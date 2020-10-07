class NotificationsController < ApplicationController
  def index
  end

  def destroy
    @notification = Notification.find(params[:id])
    @trip = @notification.trip
    @trip.new_daily_cases_thresholds = 0
    @trip.save
    @notification.destroy
    redirect_to trips_path, alert: 'Notification removed'
  end
end
