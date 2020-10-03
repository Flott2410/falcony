namespace :case do
  desc "Updating cases and indications"
  task update: :environment do
    puts "Updating cases..."
    UpdateCasesJob.perform_later
    puts "Done!"
    # rake task will return when all jobs are _enqueued_ (not done).
  end
end
