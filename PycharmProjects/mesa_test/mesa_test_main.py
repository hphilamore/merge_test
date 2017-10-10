
# coding: utf-8

# In[65]:

from mesa import Agent, Model
from mesa.time import RandomActivation
from mesa.space import MultiGrid
from mesa.datacollection import DataCollector
from mesa.batchrunner import BatchRunner

import matplotlib.pyplot as plt
import random
import numpy as np

from mesa.visualization.modules import CanvasGrid
from mesa.visualization.ModularVisualization import ModularServer
from mesa.visualization.modules import ChartModule
# If MoneyModel.py is where your code is:
# from MoneyModel import MoneyModel


# In[66]:

def compute_gini(model):
    agent_wealths = [agent.wealth for agent in model.schedule.agents]
    x = sorted(agent_wealths)
    N = model.num_agents
    B = sum( xi * (N-i) for i,xi in enumerate(x) ) / (N*sum(x))
    return (1 + (1/N) - 2*B)


# In[67]:

def agent_portrayal(agent):
    portrayal = {"Shape": "circle",
        "Color": "red",
        "Filled": "true",
        "Layer": 0,
        "r": 0.5}

    if agent.wealth > 0:
        portrayal["Color"] = "red"
        portrayal["Layer"] = 0
    else:
        portrayal["Color"] = "grey"
        portrayal["Layer"] = 1
        portrayal["r"] = 0.2
        return portrayal

    return portrayal


# In[68]:

# parameters = {"width": 10,
#               "height": 10,
#               "N": range(10, 500, 10)}

# batch_run = BatchRunner(MoneyModel,
#                         parameters,
#                         iterations=5,
#                         max_steps=100,
#                         model_reporters={"Gini": compute_gini})
# batch_run.run_all()


# In[69]:

class MoneyAgent(Agent):
    """An agent with fixed initial wealth."""
    def __init__(self, unique_id, model):
        super().__init__(unique_id, model)
        self.wealth = 1

    def step(self):
        # The agent's step will go here.
        #print(self.unique_id)
        self.move()
        if self.wealth > 0:
            self.give_money()
#         if self.wealth == 0:
#             return
#         other_agent = random.choice(self.model.schedule.agents)
#         other_agent.wealth += 1
#         self.wealth -= 1
        pass

    def move(self):
        possible_steps = self.model.grid.get_neighborhood(
        self.pos,
        moore=True,
        include_center=False)
        new_position = random.choice(possible_steps)
        self.model.grid.move_agent(self, new_position)

    def give_money(self):
        cellmates = self.model.grid.get_cell_list_contents([self.pos])
        if len(cellmates) > 1:
            other = random.choice(cellmates)
            other.wealth += 1
            self.wealth -= 1


# In[70]:

class MoneyModel(Model):
    """A model with some number of agents."""
    def __init__(self, N, width, height):
        self.num_agents = N
        self.grid = MultiGrid(width, height, False)
        self.schedule = RandomActivation(self)
        self.running = True

    # Create agents
        for i in range(self.num_agents):
            a = MoneyAgent(i, self)
            self.schedule.add(a)

            # Add the agent to a random grid cell
            x = random.randrange(self.grid.width)
            y = random.randrange(self.grid.height)
            self.grid.place_agent(a, (x, y))

        self.datacollector = DataCollector(
            model_reporters={"Gini": compute_gini},
            agent_reporters={"Wealth": lambda a: a.wealth})

    def step(self):
        '''Advance the model by one step.'''
        self.datacollector.collect(self)
        self.schedule.step()


# In[71]:

empty_model = MoneyModel(10, 10, 10)
for i in range(2):
    empty_model.step()


# In[72]:

##get_ipython().magic(u'matplotlib inline')


# In[73]:

# agent_wealth = [a.wealth for a in empty_model.schedule.agents]
# plt.hist(agent_wealth)


# In[74]:

# all_wealth = []
# for j in range(100):

#     # Run the model
#     model = MoneyModel(10, 10, 10)
#     for i in range(10):
#         model.step()

#         # Store the results
#     for agent in model.schedule.agents:
#         all_wealth.append(agent.wealth)

# plt.hist(all_wealth, bins=range(max(all_wealth)+1))


# In[75]:

# model = MoneyModel(50, 10, 10)
# for i in range(20):
#     model.step()


# In[76]:

# agent_counts = np.zeros((model.grid.width, model.grid.height))
# for cell in model.grid.coord_iter():
#     cell_content, x, y = cell
#     agent_count = len(cell_content)
#     agent_counts[x][y] = agent_count
# plt.imshow(agent_counts, interpolation='nearest')
# plt.colorbar()


# In[77]:

# gini = model.datacollector.get_model_vars_dataframe()
# print(gini)
# gini.plot()


# In[78]:

# agent_wealth = model.datacollector.get_agent_vars_dataframe()
# agent_wealth.tail()


# In[79]:

# agent_wealth.head()


# In[80]:

#agent_wealth


# In[81]:

# #to plot the wealth of a given agent (in this example, agent 14):
# one_agent_wealth = agent_wealth.xs(14, level="AgentID")
# one_agent_wealth.Wealth.plot()


# In[82]:

# # to get a histogram of agent wealth at the model’s end
# end_wealth = agent_wealth.xs(19, level="Step")["Wealth"]
# end_wealth.hist(bins=range(agent_wealth.Wealth.max()+1))


# In[83]:

# #run 5 instantiations of the model with each number of agents, and to run each for 100 steps. We have it collect the
# #final Gini coefficient value.

# parameters = {"width": 10,
#               "height": 10,
#               "N": range(10, 500, 10)}

# batch_run = BatchRunner(MoneyModel,
#                         parameters,
#                         iterations=5,
#                         max_steps=100,
#                         model_reporters={"Gini": compute_gini})
# batch_run.run_all()


# In[84]:

# run_data = batch_run.get_model_vars_dataframe()
# run_data.head()
# plt.scatter(run_data.N, run_data.Gini)


# In[85]:

grid = CanvasGrid(agent_portrayal, 10, 10, 500, 500)

server = ModularServer(MoneyModel,
                       [grid],
                       "Money Model",
                       100, 10, 10)

chart = ChartModule([{"Label": "Gini",
                      "Color": "Black"}],
                    data_collector_name='datacollector')

server = ModularServer(MoneyModel,
[grid, chart],
"Money Model",
100, 10, 10)

server.port = 8526 #8521 # The default
server.launch()


# In[ ]:




# In[ ]:


