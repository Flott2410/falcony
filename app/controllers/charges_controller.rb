class ChargesController < ApplicationController
  skip_before_action :authenticate_user!
  def new
  end

  def create
    # Amount in cents
    @amount = 200

    customer = Stripe::Customer.create({
      email: params[:stripeEmail],
      source: params[:stripeToken],
    })

    charge = Stripe::Charge.create({
      # customer: customer.id,
      amount: @amount,
      description: 'Hot Coffee for the DevTeam',
      currency: 'eur',
    })

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end
end
