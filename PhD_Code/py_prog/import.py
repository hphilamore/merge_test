import csv
import pandas



colnames = ['year', 'name', 'city', 'latitude', 'longitude']
data = pandas.read_csv('test.csv', names=colnames)


names = list(data.name)
latitude = list(data.latitude)
longitude = list(data.longitude)

print names
print longitude

print type(names)

import matplotlib.pyplot as plt
plt.plot(names, names)
plt.show()

