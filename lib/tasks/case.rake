namespace :case do
  desc "Updating cases and indications"
  task update: :environment do
    puts "Updating cases and indications..."
    UpdateCasesJob.perform_later
    UpdateIndicationsJob.perform_later
    # rake task will return when all jobs are _enqueued_ (not done).
  end
end
