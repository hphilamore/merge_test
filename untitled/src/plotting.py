import os
import csv
import numpy as np
from matplotlib import pyplot as plt

equalise_x = []
equalise_y = []
equalise_benevolence = []
cautious_x = []
cautious_y = []
cautious_benevolence = []
NoTrophallaxis_x = []
NoTrophallaxis_y = []

# First find the data
for root, dirs, files in os.walk("/media/"):
    for file in files:
        if file.endswith("Data.07-02-2016_11_29_02_JST.csv"):
            print(os.path.join(root, file))
            data_location = os.path.join(root, file)

# # select the directory 2 steps up from current location
target_dir = os.path.sep.join(data_location.split(os.path.sep)[:-2])

values = ['total_food_initial', 'total_food_end', 'count', 'e_threshold_benevolent', 'feeding_mode']

for root, dirs, files in os.walk(target_dir):
    for file in files:
        if file.endswith("JST.csv"):
            #print(os.path.join(root, file))
            with open(os.path.join(root, file)) as file:
                reader = csv.reader(file)
                for row in reader:
                    for x in values:
                        if x in row[0]:
                            try:
                                exec("%s = %d" % (x,float(row[1])))

                            except ValueError:
                                if 'feeding_mode' in row[0]:
                                    feeding_mode = row[1]

                food_removed = (total_food_initial - total_food_end) / total_food_initial
                life_expectancy = count

                if 'NO TROPHALLAXIS' in row[0]:
                    NoTrophallaxis_x.append(life_expectancy)
                    NoTrophallaxis_y.append(food_removed)

                elif feeding_mode == "equalise":
                    equalise_x.append(life_expectancy)
                    equalise_y.append(food_removed)
                    equalise_benevolence.append(e_threshold_benevolent)

                elif feeding_mode == "top_up_recipiant_cautious":
                    cautious_x.append(life_expectancy)
                    cautious_y.append(food_removed)
                    cautious_benevolence.append(e_threshold_benevolent)

group = 3

B = np.asarray([B for (B,x,y) in sorted(zip(equalise_benevolence,
    equalise_x, equalise_y))]).reshape(-1, group).mean(axis=1)
x = np.asarray([x for (B,x,y) in sorted(zip(equalise_benevolence,
    equalise_x, equalise_y))]).reshape(-1, group).mean(axis=1)
y = np.asarray([y for (B,x,y) in sorted(zip(equalise_benevolence,
    equalise_x, equalise_y))]).reshape(-1, group).mean(axis=1)

plt.plot(B,x, color = 'r')

B = np.asarray([B for (B,x,y) in sorted(zip(cautious_benevolence,
    cautious_x, cautious_y))]).reshape(-1, group).mean(axis=1)
x = np.asarray([x for (B,x,y) in sorted(zip(cautious_benevolence,
    cautious_x, cautious_y))]).reshape(-1, group).mean(axis=1)
y = np.asarray([y for (B,x,y) in sorted(zip(cautious_benevolence,
    cautious_x, cautious_y))]).reshape(-1, group).mean(axis=1)

plt.plot(B,y)
plt.show()
