class CreateNotificationJob < ApplicationJob
  queue_as :default

  def perform
    # Do something later
    require 'date'

    @trips = Trip.all.where(bookmarked: true)

    for trip in @trips
      if trip.new_daily_cases_threshold > 0
        if trip.destination.cases.last.new_cases > trip.new_daily_cases_threshold
          @notification = Notification.create!(
            trip: trip,
            subject:"New daily cases",
            content: "#{trip.destination.name} reported #{trip.destination.cases.last.new_cases} new cases on #{trip.destination.cases.last.date.strftime("%-d %B %Y")}."
            )
        end

      end
    end
  end
end
