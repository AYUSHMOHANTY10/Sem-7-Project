import pickle

# Load the pickled model and vectorizer
filename = "logistic.pickle"
loaded_model = pickle.load(open(filename, "rb"))
loaded_vectorizer = pickle.load(open('vectorizer.pickle',"rb"))

# Get the input URL from the user
string = input("Enter a url: ")

# Transform the input URL into a TF-IDF vector
test_x_d = loaded_vectorizer.transform([string])

# Make a prediction using the loaded model
y_pred = loaded_model.predict(test_x_d)

# Get the predicted label and domain name
predicted_label = y_pred[0]
domain = string.split("//")[1].split("/")[0]

# Print the output in the specified format
print("Prediction:", predicted_label)
print("Final URL:", string)
print("Domain:", domain)

