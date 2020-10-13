class NotificationsController < ApplicationController
  def index
    @trips = Trip.where(user: current_user, notify: true).order(updated_at: :desc)

    @alpha_codes = {
      "Austria" => 'at',
      "Belgium" => 'be',
      "Bulgaria" => 'bg',
      "Croatia" => 'hr',
      "Cyprus" => 'cy',
      "Czech Republic" => 'cz',
      "Denmark" => 'dk',
      "Estonia" => 'ee',
      "Finland" => 'fi',
      "France" => 'fr',
      "Germany" => 'de',
      "Greece" => 'gr',
      "Hungary" => 'hu',
      "Iceland" => 'is',
      "Ireland" => 'ie',
      "Italy" => 'it',
      "Latvia" => 'lv',
      "Lithuania" => 'lt',
      "Luxembourg" => 'lu',
      "Malta" => 'mt',
      "Netherlands" => 'nl',
      "Norway" => 'no',
      "Poland" => 'pl',
      "Portugal" => 'pt',
      "Romania" => 'ro',
      "Slovakia" => 'sk',
      "Slovenia" => 'si',
      "Spain" => 'es',
      "Sweden" => 'se',
      "Switzerland" => 'ch'
    }
  end
end
