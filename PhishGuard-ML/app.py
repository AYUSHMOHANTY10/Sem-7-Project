from flask import Flask, request, jsonify
import pickle
from ssl_checker import SSLChecker
import os
import scipy

#from predict import make_prediction

app = Flask(__name__)
ssl_checker = SSLChecker()

dir_name = os.path.dirname(os.path.abspath(__file__))

# Load the ML model and the vectorizer
filename = "logistic.pickle"
loaded_model = pickle.load(open(filename, "rb"))
loaded_vectorizer = pickle.load(open(dir_name+'/vectorizer.pickle',"rb"))

@app.route('/predict', methods=['GET'])
def predict():
    try:
        # Get the input URL from the URL parameter
        string = request.args.get('url')

        # Transform the input URL into a TF-IDF vector
        test_x_d = loaded_vectorizer.transform([string])

        # Make a prediction using the loaded model
        y_pred = loaded_model.predict(test_x_d)

        # Get the predicted label and domain name
        predicted_label = y_pred[0]
        domain = string.split("//")[1].split("/")[0]

        # Create a response JSON
        response = {
            "Prediction": predicted_label,
            "Final URL": string,
            "Domain": domain
        }

        return jsonify(response)

    except Exception as e:
        return jsonify({"error": str(e)}), 400


@app.route('/check_ssl', methods=['POST'])
def check_ssl():
  """Checks the SSL certificate of a host and returns information about the certificate."""
  hosts = request.args.getlist('hosts')
  if not hosts:
    return {'error': 'Please provide a list of hosts to check.'}, 400

  results = {}
  for host in hosts:
    try:
      host, port = ssl_checker.filter_hostname(host)
      cert = ssl_checker.get_cert(host, port)
      cert_info = ssl_checker.get_cert_info(host, cert)
      cert_info['tcp_port'] = int(port)
      results[host] = cert_info
    except Exception as e:
      results[host] = {'error': str(e)}

  return results, 200

if __name__ == '__main__':
  app.run()
