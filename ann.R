
#Importing the dataset
dataset = read.csv('companyData.csv')

dataset = dataset[1:500,1:10]

#Splitting the dataset into the Training set and Test set
#install.packages('caTools')
library(caTools)
set.seed(123)
split = sample.split(dataset$Classify, SplitRatio = 0.8)
training_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)

#Feature Scaling
training_set[-10] = scale(training_set[-10])
test_set[-10] = scale(test_set[-10])

#Fitting ANN to the Training set
#install.packages('h2o')
library(h2o)
h2o.init(nthreads = -1)
model = h2o.deeplearning(y = 'Classifier',
                         training_frame = as.h2o(training_set),
                         activation = 'Rectifier',
                         hidden = c(4,4),
                         epochs = 100,
                         nfolds = 5,
                         train_samples_per_iteration = -2)


# Predicting the Test set results
y_pred = h2o.predict(model, newdata = as.h2o(test_set[-10]))
#y_pred = as.vector(y_pred)

y_pred = (y_pred > 0.7)
y_pred = as.vector(y_pred)
cm = table(test_set[, 10], y_pred)
#cm = as.data.frame(cm)
#y_pred = as.data.frame(y_pred)
#y_obs = as.data.frame(test_set[, 11])
cm





