class CreateNotificationJob < ApplicationJob
  queue_as :default

  def perform
    # Do something later
    require 'date'

    @trips = Trip.all.where(bookmarked: true)

    for trip in @trips
      if trip.new_daily_cases_threshold > 0
        if trip.destination.cases.last.new_cases > trip.new_daily_cases_threshold
          # Store the day in variable in order to use te method ordinalize
          day = trip.destination.cases.last.date.strftime("%-d %B %Y").to_i
          @notification = Notification.create!(
            trip: trip,
            subject:"New daily cases",
            content: "#{trip.destination.name} reported #{trip.destination.cases.last.new_cases.to_s.reverse.gsub(/...(?=.)/,'\& ').reverse} new cases on #{trip.destination.cases.last.date.strftime("%B #{day.ordinalize} %Y")}."
            )
          TwilioClient.new.new_daily_cases_notification(trip.user, @notification.content)
        end

      end
    end

  end
end
