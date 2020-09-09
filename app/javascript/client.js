const stripeCoffee = () => {
var stripe = Stripe('pk_test_51HP7jHFjvBKJvhpwIhnOBljbfSMBvI0pXddRVQC6SG42JZikYX4xl2X6TbKE72BDGhjJkUQsxV2nLX1RztaLxFjb00X5HXG5bq');

var checkoutButton = document.querySelector('#checkout-button');
checkoutButton.addEventListener('click', function () {
  stripe.redirectToCheckout({
    lineItems: [{
      // Define the product and price in the Dashboard first, and use the price
      // ID in your client-side code.
      price: '200',
      quantity: 1
    }],
    mode: 'payment',
    successUrl: 'https://www.example.com/success',
    cancelUrl: 'https://www.example.com/cancel'
  });
});
};

export { stripeCoffee };
