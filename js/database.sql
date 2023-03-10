

require_once('vendor/autoload.php');
\Stripe\Stripe::setApiKey('your_api_key_here');


if ($_SERVER['REQUEST_METHOD'] == 'POST') {
  // Get payment details from the form
  $paymentDetails = array(
    'name' => $_POST['cardholder-name'],
    'email' => $_POST['email'],
    'cardNumber' => $_POST['cardnumber'],
    'expMonth' => $_POST['exp-month'],
    'expYear' => $_POST['exp-year'],
    'cvv' => $_POST['cvv']
  );
  $charge = \Stripe\Charge::create(array(
    'amount' => 1000, // Amount in cents
    'currency' => 'usd',
    'source' => $paymentDetails['cardNumber'],
    'description' => 'Payment for product X'
  ));

  // Save the payment details to your MySQL database
  $conn = new mysqli('localhost', 'username', 'password', 'database_name');
  $stmt = $conn->prepare("INSERT INTO payments (name, email, card_number, exp_month, exp_year, cvv, amount, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
  $stmt->bind_param('ssssssis', $paymentDetails['name'], $paymentDetails['email'], $paymentDetails['cardNumber'], $paymentDetails['expMonth'], $paymentDetails['expYear'], $paymentDetails['cvv'], $charge->amount, $charge->status);
  $stmt->execute();
}
