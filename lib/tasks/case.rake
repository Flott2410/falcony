namespace :case do
  desc "Updating cases"
  task update: :environment do
    puts "Updating cases..."
    UpdateCasesJob.perform_later
    # rake task will return when all jobs are _enqueued_ (not done).
  end

end
