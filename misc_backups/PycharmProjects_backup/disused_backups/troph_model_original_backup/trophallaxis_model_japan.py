from collections import namedtuple
from collections import OrderedDict
from enum import Enum
from matplotlib import pyplot as plt
import os
import csv
import numpy as np
import copy
import random
import time

start_time = time.time()
count = 0
# trophallaxis_count_explore = 0
# trophallaxis_count_store = 0
# food_cells_depleted_count = 0
# forage_success_count_explore = 0
# forage_success_count_store = 0
# forage_success_dont_stop_count = 0
# forage_unsuccessful_count = 0


# Set model parameters

n_cells = 900
n_agents = 50

global use_chains

plot_output = True              #  plots and saves output data
show_plot = False                #  displays data during simulation
use_chains = False              #  use chain mechanism
use_relay_chains = False        #  use relay chain mechanism
use_trophallaxis = True         #  use trophallaxis mechanism

bot_map_style = "new_random_map" #  options:
                                   #  "existing_map": import from previous data
                                   #  "pre_designed_map": design map
                                   #  "new_random_map"

food_map_style = "designed_map" #  options:
                                    #  "existing_map"
                                    #  "cellular_automata_map"
                                    #  "designed_map"

# if using existing map, name of previous data
bot_map_dir = "Data.07-02-2016_00_25_05_JST"
food_map_dir = "Data.07-02-2016_00_25_05_JST"
bot_map_name = "Data.07-02-2016_00_25_05_JST"
food_map_name = "Data.07-02-2016_00_25_05_JST"

# random seed is random choice
seed_np = np.random.randint(0, 2**32 - 1)
seed_random = np.random.randint(0, 2**32 - 1)
# or
# random seed is selected for np and random libraries
# seed_np, seed_random = (5, 5)
# seed_np, seed_random = (26, 300) nice example

np.random.seed(seed_np)
random.seed(seed_random)

BOT_DEFAULTS = OrderedDict([
    ("base_metabolism", 1),
    ("e_consumed_per_feed", 5),
    ("e_stored_initial", 5),
    ("e_cost_per_step", 1),
    ("e_threshold_store", 7),
    ("e_threshold_explore", 15),
    ("e_threshold_trophallaxis", 0),
    ("sense_range", 1),
    ("transmission_range" , 2),
    ("trophallaxis", use_trophallaxis),
    ("trophallaxis_mode", "equalise"),
    # options:
    # "equalise",
    # "top_up_recipient_cautious"
    # "top_up_recipient_selfless"
    ("relay", use_relay_chains),
    ("e_stored_max", 30),
    ])

BOT_DEFAULTS['e_stored_initial'] = BOT_DEFAULTS["e_consumed_per_feed"]
BOT_DEFAULTS['e_threshold_store'] = BOT_DEFAULTS["e_threshold_trophallaxis"]

"""dict: Default values for bot construction."""

# output data file
dateStr = time.strftime(
    '%Y-%m-%d')
timeStr = time.strftime(
    '%Y-%m-%d_%H_%M_%S')

if use_relay_chains == True:
    relay = "_relay"
else:
    relay = ""

if use_trophallaxis == True:
    troph = "_troph"
else:
    troph = ""


dirname = "output_data/" + "{0}{1}".format("Data_", dateStr)
subdirname = "{0}{1}".format("Data_", timeStr) + troph + relay


os.makedirs(dirname + "/"+ subdirname)
os.makedirs(dirname + "/"+ subdirname + "/video_files")

data_per_timestep = dirname + "/"+ subdirname + "/" \
                    + subdirname + '_per_timestep.csv'
data_summary = dirname + "/"+ subdirname + "/" \
                    + subdirname + '_summary.csv'

SENSING_TARGETS = {
    "has_food": 2,
    "has_no_food": 1,
    "neighbouring_recruits" : 1,
    "neighbouring_bot" : 1,
    "neighbouring_space": 0,
}
"""dict: Potential targets that can be sensed."""

BotOpmode = Enum("BotOpmode", ["explore", "store"])
Location = namedtuple("Location", ("x", "y"))

def divide_matrices(dividend, divisor):
    """
    Ignore division by zero.

    Parameters
    ----------
    dividend : Sequence
        The dividend array.
    divisor : Sequence
        The divisor array.

    Returns
    -------
    np.ndarray
        The quotient, with extraneous values set to zero.

    Examples
    --------
    >>> divide_matrices([-1, 0, 1, 6], [0, 0, 0, 4])
    array([0, 0, 0, 1.5])

    References
    ----------
    .. [#] np: Return 0 with devide by zero. StackOverflow.
       http://stackoverflow.com/questions/26248654/np-return-0-with-divide-by-zero

    """
    with np.errstate(divide='ignore', invalid='ignore'):
        quotient = np.divide(dividend, divisor)
        quotient[~np.isfinite(quotient)] = 0  # -inf inf NaN
    return quotient

class Food(object):
    """
    Maps the distribution of food over the grid space.

    Parameters
    ----------
    n_food_cells : int
       The number of cells with individual values that the food map is
       discretised into.
    max_food_per_cell : int
       The maximum value of a food cell.

    Attributes
    ----------
    n_food_cells : int
       The number of cells with individual values that the food map is
       discretised into.
    map_size : int
        The length of each side of the food map in grid cells.
    max_food_per_cell : int
       The maximum value of a food cell.
    food_map : array
       The distribution of food across the grid space, food cell discretisation.
    ratio_full_to_empty
    food_generation_threshold
        If an empty cell has neighbours exceeding this number, a cell is born
    food_elimination_threshold
        If a full cell has neighbours exceeding this number, the cell dies
    food_map_iterations
        The number of iterations to cycle through

    """
    def __init__(self, *,
                 n_cells,
                 max_food_per_cell,
                 ratio_full_to_empty = 0,
                 food_generation_threshold = 0,
                 food_elimination_threshold = 0,
                 food_map_iterations = 0):

        self.food_map_style = food_map_style
        self.n_cells = n_cells
        self.map_size = int(np.sqrt(self.n_cells))
        self.max_food_per_cell = max_food_per_cell
        self.food_map = np.zeros(self.n_cells)

        if food_map_style == "existing_map":

            self.food_map = np.load(food_map_dir + "/"
                                    + food_map_name + "/"
                                    + food_map_name + "_food.npy")

            food_map_name = dirname + "/"+ subdirname + "/" \
                                    + food_map_name

        if food_map_style == "cellular_automata_map":
            self.ratio_full_to_empty = ratio_full_to_empty
            self.n_food_cells = n_cells * self.ratio_full_to_empty
            self.food_generation_threshold = food_generation_threshold
            self.food_elimination_threshold = food_elimination_threshold
            self.food_map_iterations = food_map_iterations
            self._cellular_automata_map()

            food_map_name = dirname + "/" + subdirname + "/" \
                            + subdirname

        if food_map_style == "designed_map":
            self._designed_map()

            food_map_name = dirname + "/" + subdirname + "/" \
                            + subdirname

        np.save(food_map_name + "_food", self.food_map)

        self.total_food_initial = np.sum(self.food_map)
        self.total_food_cells_initial = len(np.argwhere(self.food_map))

    def _cellular_automata_map(self):

        self.food_map[0: self.n_food_cells] = 1
        np.random.shuffle(self.food_map)
        self.food_map = np.reshape(self.food_map,
                                   (self.map_size, self.map_size))

        for i in range(self.food_map_iterations):

            N = (self.food_map[0:-2, 0:-2] + self.food_map[0:-2,
                                             1:-1] + self.food_map[0:-2, 2:] +
                 self.food_map[1:-1, 0:-2] + self.food_map[1:-1, 2:] +
                 self.food_map[2:, 0:-2] + self.food_map[2:,
                                           1:-1] + self.food_map[2:, 2:])

            birth = (N > self.food_generation_threshold) & (
            self.food_map[1:-1, 1:-1] == 0)
            survive = ((N > self.food_elimination_threshold) & (
            self.food_map[1:-1, 1:-1] == 1))
            self.food_map[...] = 0
            self.food_map[1:-1, 1:-1][birth | survive] = 1

        x, y = np.nonzero(self.food_map)
        food_cell_values = range(0, self.max_food_per_cell + 1,
                                 BOT_DEFAULTS['e_consumed_per_feed'])

        for X, Y in zip(x, y):
            self.food_map[X, Y] = random.choice(food_cell_values)

        # ... + this for REALLY nice islands (total map size 30x30)
        # self.food_map = np.reshape(self.food_map,
        #                            (self.map_size, self.map_size))
        # for cell in self.food_map[100:300, 100:50]:
        #     cell = random.choice(food_cell_values)

    def _designed_map(self):
        self.food_map = np.reshape(self.food_map,
                                   (self.map_size, self.map_size))

        food_cell_values = range(BOT_DEFAULTS['e_consumed_per_feed'],
                                 self.max_food_per_cell + 1,
                                 BOT_DEFAULTS['e_consumed_per_feed'])

        #self.food_map[3:22, 5:10] = 1    # area covered by food
        #self.food_map[11:19, 9:21] = 1  # area covered by food
        self.food_map[11:19, 11:19] = 1  # area covered by food

        # food on each cell
        x, y = np.nonzero(self.food_map)
        for X, Y in zip(x, y):
            self.food_map[X, Y] = self.max_food_per_cell
            # self.food_map[X, Y] = random.choice(food_cell_values)
        print(self.food_map)
        plt.matshow(self.food_map)
        plt.show()

    def __repr__(self):
        return "Food({}, {}, {})".format(
            self.n_food_cells,
            self.map_size,
            self.max_food_per_cell,)

    def __str__(self):
        return str(self.food_map)


class Bot(object):
    """
    Robot agents that travel around the grid space, eating the food.

    Parameters
    ----------
    base_metabolism : Optional[int]
        The base energy consumption per simulation step of each bot
    e_cost_per_step : Optional[int]
        The energy consumed by the bot for each step of size = one grid space.
    e_threshold_trophallaxis : Optional[int]
        The stored energy threshold at which the bot begins sharing energy with
        others.
    e_threshold_explore : Optional[int]
        The stored energy threshold that prompts bots to change their task from
        storing energy to exploring.
    e_threshold_store : int
        The stored energy threshold that prompts bots to change their task from
        exploring to storing energy and aggregating bots around the
        source of energy.
    recruit range : Optional [int]
        The width of the border around each bot within which it can recruit
        other bots to a relay chain if it is the tail end a relay chain.
    sense_range : Optional [int]
        The width of the border around each bot within which it can sense other
        bots.

    Attributes
    ----------
    base_metabolism : int
        The base energy consumption per simulation step of each bot
    chain : Chain
        The chain in which the bot is connected.
    e_cost_per_step : int
        The energy consumed by the bot for each step of size = one grid space.
    e_threshold_trophallaxis : int
        The stored energy threshold at which the bot begins sharing energy with
        others.
    e_threshold_explore : int
        The stored energy threshold that prompts bots to change their task from
        storing energy to exploring.
    e_threshold_store : int
        The stored energy threshold that prompts bots to change their task from
        exploring to storing energy and aggregating bots around the
        source of energy.
    e_stored : float
        The cumulative energy from feeding less the energy consumed.
    location : tuple
        The x, y coordinates of the bot location on the bot map.
    recruit range : Optional [int]
        The width of the border around each bot within which it can recruit
        other bots to a relay chain if it is the tail end a relay chain.

    """
    bots = []

    #TODO: function that generates both sense and transmission kernels
    sense_kernel = np.zeros((2 * BOT_DEFAULTS["sense_range"] + 1) ** 2)
    sense_kernel[(len(sense_kernel) // 2)] = 1
    kernel_size = np.sqrt(len(sense_kernel))
    sense_kernel = np.reshape(sense_kernel, (kernel_size, kernel_size))

    transmission_kernel = np.zeros((2 * BOT_DEFAULTS["transmission_range"] + 1) ** 2)
    transmission_kernel[(len(transmission_kernel) // 2)] = 1
    kernel_size = np.sqrt(len(transmission_kernel))
    transmission_kernel = np.reshape(transmission_kernel, (kernel_size, kernel_size))

    def __init__(self, world, *, base_metabolism, e_consumed_per_feed,
                 e_stored_initial, e_cost_per_step, e_threshold_store,
                 e_threshold_explore, e_threshold_trophallaxis,
                 sense_range, transmission_range, trophallaxis,
                 trophallaxis_mode, e_stored_max, relay):
        self.base_metabolism = base_metabolism
        self.e_cost_per_step = e_cost_per_step
        self.e_threshold_trophallaxis = e_threshold_trophallaxis
        self.e_threshold_explore = e_threshold_explore
        self.e_threshold_store = e_threshold_store
        self.location = None
        self.e_stored = e_consumed_per_feed
        self.chain = None
        self.relay_chain = None
        self.operating_mode = BotOpmode.explore
        self.new_location_generator = None
        self.target_location = None
        self.bots.append(self)

        self.new_location_generators = {
            "random_step": self.random_step,
            "step_towards_neighbour": self.step_towards_neighbour,
            "step_towards_signal": self.step_towards_signal,
            "step_to_explore": self.step_towards_signal,
            "step_towards_feeder": self.step_towards_signal,
            }

    def evaluate_neighbours(self, world, location, neighbours):
        """

        Parameters
        ----------
        world : object
            The world in which the bots live
        location :
        neighbours

        Returns
        -------

        """
        # locations of neighbours, excluding those in Explore mode
        unfed_neighbours =      (np.ma.make_mask(world.bot_map)*1 - \
                                 np.ma.make_mask(world.food_map)*1)\
                                - np.ma.make_mask(world.explore_mode_map)*1

        fed_neighbours =        np.ma.make_mask(world.bot_map) * 1 +\
                                np.ma.make_mask(world.food_map) * 1\
                                - np.ma.make_mask(world.explore_mode_map) * 1

        local_energy = (np.ma.make_mask(world.food_map) * 1)[location[::-1]]

        if local_energy:
            neighbours_less_food = self.sense(unfed_neighbours, "has_no_food")
            if neighbours_less_food:
                for neighbour in neighbours_less_food:
                    if BOT_DEFAULTS["trophallaxis"] == True:
                        world.feed_hungry_neighbour(location, neighbour)

            neighbours_same_food_full = self.sense(fed_neighbours, "has_food")
            if neighbours_same_food_full:
                if world.store_mode_map[location[::-1]]:
                    for neighbour in neighbours_same_food_full:
                        #print("neighbours same food full attempt connect...")
                        #global use_chains
                        if use_chains:
                            world.attempt_connect_neighbours(location,
                                                             neighbour)
        else:  # if food cell empty
            neighbours_same_food_none = self.sense(
                unfed_neighbours, "has_no_food")
            if neighbours_same_food_none:
                #if world.explore_mode_map[location[::-1]] != None:
                if world.explore_mode_map[location[::-1]]:
                    for neighbour in neighbours_same_food_none:
                        print("hungry explorer:try to feed hungry neighbour")
                              #location)

                        if BOT_DEFAULTS["trophallaxis"] == True:
                            world.feed_hungry_neighbour(location, neighbour)

                # if bot is in store mode
                else:
                    print(" store bot neighbour has same food (empty): random walk",location)
                    world.setup_for_move("random_step",
                                         location, None,
                                         np.clip(world.stored_energy_map[
                                                     location[::-1]],
                                                 0, float("inf")))
            # note: random walk command comes first so that it is overidden by
            # command to move to fed nieghbour if neighbours are available
            neighbours_more_food = self.sense(fed_neighbours, "has_food")
            if neighbours_more_food:
                neighbour = random.choice(neighbours_more_food)

                # # if bot is not explorer
                if not world.explore_mode_map[location[::-1]]:
                    if world.stored_energy_map[location[::-1]]:
                        world.setup_for_move("step_towards_neighbour",
                                             location, neighbour)

                # if the bot is an explorer and is head of a relay chain...

                # if (world.explore_mode_map[location[::-1]] and
                #             self.new_location_generator == "step_to_explore"):

                if (self.relay_chain and
                              self.relay_chain.chain_map[location[::-1]]==1):

                # if (self.new_location_generator == "step_to_explore"):

                # elif (self.relay_chain and
                #           self.relay_chain.chain_map[location[::-1]]==1):

                    self.relay_chain.heading = \
                        Location((neighbour.x - location.x),
                                 (neighbour.y - location.y))
                    # change heading to move towards neighbour
                    # print("tell relay chain to explore", location)
                    # print("explorer map", world.explore_mode_map[location[::-1]])
                    world.setup_for_move("step_to_explore",
                                         location, self.relay_chain.heading)

    def random_step(self, location, target_location, world):

        """
        Determines the next space the bot will attempt to move to.

        Parameters
        ----------
        initial_location: named tuple
            The x,y coordinates of position the bot will attempt to move from.

        Returns
        -------
        new_location : name tuple
            The x,y coordinates of next position the bot will attempt to move to.
        """

        new_location = Location(
            np.clip(location.x + random.randint(-1, 1), 1,
                    world.bot_map_size - 2),
            np.clip(location.y + random.randint(-1, 1), 1,
                    world.bot_map_size - 2))

        return new_location

    def step_towards_neighbour(self, location,
                               target_location, world):

        map_limit = np.maximum(BOT_DEFAULTS["transmission_range"],
                               BOT_DEFAULTS["sense_range"])

        if location.y == target_location.y:
            new_y = np.clip(
                (location.y +
                 random.choice([-1, 1])),
                1, world.bot_map_size - (map_limit + 1))
            new_location = Location(target_location.x, new_y)

        elif location.x == target_location.x:
            new_x = np.clip(
                (location.x +
                 random.choice([-1, 1])),
                1, world.bot_map_size - (map_limit + 1))
            new_location = Location(new_x, target_location.y)

        else:
            new_location = random.choice(
                [Location(target_location.x,
                          location.y),
                 Location(location.x,
                          target_location.y)])

        return new_location


    def step_towards_signal(self, location,
                            target_location, world):
        """
        Determines the next space the bot will attempt to move to.

        Parameters
        ----------
        location : Named Tuple
            The x,y coordinates of the starting position of the bot.
        target_location : Named Tuple
            The x,y coordinates the bot is moving towards.

        Returns
        -------
        new_location : Named Tuple
            The x,y, coordiantes of the new location to move to.

        """
        # returns unit vector
        def normalise(value):
            return value / np.absolute(value)

        print("target_location", target_location)
        print("location", location)

        dx = target_location.x - location.x
        dy = target_location.y - location.y

        new_x = np.clip(location.x + normalise(dx),
                1, world.bot_map_size - 2)
        new_y = np.clip(location.y + normalise(dy),
                1, world.bot_map_size - 2)

        # new_location = location
        #
        # if dy and (np.absolute(dy) >= np.absolute(dx)): # !=0
        #     new_location = Location(new_location.x, new_y)
        #
        # if dx and (np.absolute(dx) >= np.absolute(dy)):
        #     new_location = Location(new_x, new_location.y)
        #
        # return new_location

            #print("not alligned x or y, move x direction")

        # move x direction
        if location.y == target_location.y:
            new_location = Location(new_x, location.y)
            #print("move x direction")

        # move y direction
        elif location.x == target_location.x:
            new_location = Location(location.x, new_y)
            #print("move y direction")

        # move diagonal
        elif np.absolute(dx) == np.absolute(dy):
            new_location = Location(new_x, new_y)
            #print("move diagonal")

        elif np.absolute(dx) > np.absolute(dy):
            new_location = Location(new_x, location.y)

            #print("not alligned x or y, move y direction")

        else:  # (np.absolue(dx)\> np.absolute(dy))
            new_location = Location(location.x, new_y)
            #print("not alligned x or y, move x direction")

        print("new location", new_location)
        return new_location

    def move(self, world, location):
        """
        Moves the bot and updates the stroed energy accordingly.

        Parameters
        ----------
        new_location : Location
            The location to move to.
        """
        print("")
        print("MOVE")
        print(location, self.new_location_generator)
        if self.chain:
            print("Chain", self.chain)
        if self.relay_chain:
            print("Relay Chain", self.relay_chain)
        print("explore_map", world.explore_mode_map[location[::-1]])
        print("store_map", world.store_mode_map[location[::-1]])

        # generate a new location
        new_location =  self.new_location_generators[
                        str(self.new_location_generator)](
                        location,
                        self.target_location,
                        world)

        print(self.new_location_generator)
        print("location", location)
        #print("location", world.bot_map[location[::-1]])
        print(self.new_location_generator)
        print("new location", new_location)

        # if the new location is not free...
        if world.bot_map[new_location[::-1]]:
            # obstacle avoidance
            if (self.new_location_generator == "step_towards_signal" or
                        self.new_location_generator == "step_to_explore" or
                        self.new_location_generator == "step_towards_feeder"):

                obstacle = new_location
                # generate a new location
                new_location = self.new_location_generators[
                    "step_towards_neighbour"](location,
                                                obstacle,
                                                world)
                print("obstacle avoidance, new location", new_location)

        # if the new location is still not free...
        if world.bot_map[new_location[::-1]]:
           print("new location occupied")

           _maps = [[world.bot_move_map, True, False],
                    [world.stored_energy_map, True, False]]

           for _map in _maps:
               world.bot_map[location[::-1]].update_map(location,
                                                        location,
                                                        _map[0],
                                                        _map[1],
                                                        _map[2])

        # if the new location is free...
        elif world.bot_map[new_location[::-1]] == None:
            bot_moved = 1
            print("new location free", new_location)

            # data for plot of bot movement vectors
            #***
            before_move_y, before_move_x = np.where(
                np.ma.make_mask(world.bot_map) * 1)

            for y, x in zip(before_move_y, before_move_x):
                world.before_move_x.append(x)
                world.before_move_y.append(y)
            #
            world.before_move = world.bot_map[before_move_y,
                                              before_move_x]

            # if the bot is in a chain, remove it from the chain
            if world.bot_map[location[::-1]].chain:
                #print(world.bot_map[location[::-1]].chain)
                #print(Chain.chains)
                _check_bots = world.bot_map[location[::-1]].chain.connected_bots[:]
                world.bot_map[location[::-1]].chain.remove_bot(location, world)
                #print("removed bot from chain")
                #print(Chain.chains)
                #for bot in _check_bots:
                    #print(bot.chain)

            # if bot is head of a relay chain, move all bots in relay chain
            if (world.bot_map[location[::-1]] \
                        .new_location_generator == "step_to_explore"
                and
                    world.bot_map[location[::-1]].relay_chain):

                    print("moving relay chain")

                    bot_moved = world.bot_map[location[::-1]]. \
                        relay_chain.follow_leader(world, location, new_location)
                    print("bot_move2?", bot_moved)

                # # changed from index:location - correct?
                # RelayChain.all_relay_bots[new_location[::-1]] = 1

            else:
                _maps = [[world.bot_move_map, True, True],
                         [world.stored_energy_map, True, True],
                         [world.explore_mode_map, False, True],
                         [world.store_mode_map, False, True],
                         [world.bot_map, False, True],]

                for _map in _maps:
                    world.bot_map[location[::-1]].update_map(new_location,
                                                             location,
                                                             _map[0],
                                                             _map[1],
                                                             _map[2])



            # data for plot of bot movement vectors
            #***
            for B in world.before_move:
                y, x = np.where(world.bot_map == B)
                world.after_move_x.append(x)
                world.after_move_y.append(y)

            if bot_moved == 1:
                # print("relay chain moved, updating bot location data")
                # print("relay chains", RelayChain.relay_chains)

                # update stored location information
                world.bot_map[new_location[::-1]].location = new_location

                # evaluate e local area and stop if food found
                if np.ma.make_mask(world.food_map)[new_location[::-1]]:
                    self.stop_moving_broadcast_location(new_location, world)

                # is foraging was unsuccessful, store this info
                if (world.bot_move_map[new_location[::-1]] == 0 and
                   (world.food_map)[new_location[::-1]] == 0):
                    global forage_unsuccessful_count
                    forage_unsuccessful_count += 1


                # # if there are steps remaining, evaulate neighbours between steps
                # if world.bot_move_map[new_location[::-1]] != 0:
                #     neighbours = self.sense(np.ma.make_mask(world.bot_map) * 1,
                #                                "neighbouring_bot")
                #     if neighbours:
                #         self.evaluate_neighbours(world, new_location, neighbours)

                # if there are steps remaining,
                if world.bot_move_map[new_location[::-1]] != 0:
                    # evaulate neighbours between steps
                    neighbours = self.sense(
                        np.ma.make_mask(world.bot_map) * 1,
                        "neighbouring_bot")
                    if neighbours:
                        self.evaluate_neighbours(world, new_location,
                                                 neighbours)

        # add to map of area covered during simulation run
        world.area_covered_map += np.copy(np.ma.make_mask(world.bot_map) * 1)


    def update_map(self, new_location, initial_location,
                   _map, consume, initial_location_zero):

        if consume:
            if _map[new_location[::-1]] <= BOT_DEFAULTS["e_cost_per_step"]:
                global food_cells_depleted_count
                food_cells_depleted_count += 1

            _map[new_location[::-1]] = np.clip((_map[initial_location[::-1]]
                     - BOT_DEFAULTS["e_cost_per_step"]),
                     0, float("inf"))

            # if new_location != location:
            if initial_location_zero:
                _map[initial_location[::-1]] = 0

        else:
            _map[new_location[::-1]] = _map[initial_location[::-1]]

            # if new_location != location:
            if initial_location_zero:
                _map[initial_location[::-1]] = None

    def stop_moving_broadcast_location(self, new_location, world):
        """
        Overrides the commands given for the bot to move.

        Parameters
             ----------
        new_location : named tuple
            The x,y coordinates of where the moving bot is halted.
        """
        # remove from bots move map
        #print("found food! stop!")
        if world.explore_mode_map[new_location[::-1]]:
            if (world.bot_move_map[new_location[::-1]] >=
                    BOT_DEFAULTS["e_threshold_explore"] -
                        BOT_DEFAULTS["e_cost_per_step"]):
                global forage_success_dont_stop_count
                forage_success_dont_stop_count +=1
            else:
                global forage_success_count_explore
                forage_success_count_explore += 1
        else:
            global forage_success_count_store
            forage_success_count_store += 1

        world.bot_move_map[new_location[::-1]] = 0
        #print("found food! stop moving!")

        if world.explore_mode_map[new_location[::-1]]:
            #print("tell others!")
            # if relay chain exists, remove bot from chain
            if world.bot_map[new_location[::-1]].relay_chain:
                #print(world.bot_map[new_location[::-1]].relay_chain)
                #print(RelayChain.relay_chains)
                _check_bots = world.bot_map[new_location[::-1]].\
                    relay_chain.connected_bots[:]
                world.bot_map[new_location[::-1]].relay_chain.relay_chain_map = []
                world.bot_map[new_location[::-1]].relay_chain.dissolve_chain()


            # propogate relay signal to all neighbouring explorer bots
            relay_signal = new_location

            _map = world.explore_mode_map
            _map = np.array(_map, dtype=bool) * 1

            neighbours = [(-1, -1), (-1, 0), (-1, 1), (0, 1), (1, 1), (1, 0),
                          (1, -1), (0, -1)]

            mask = np.zeros_like(_map, dtype=bool)
            stack = [(relay_signal.y, relay_signal.x)]

            while stack:
                x, y = stack.pop()
                mask[x, y] = True
                for dx, dy in neighbours:
                    nx, ny = x + dx, y + dy
                    if (0 <= nx < _map.shape[0] and 0 <= ny < _map.shape[1]
                        and not mask[nx, ny]
                        and abs(_map[nx, ny] -
                                    _map[x, y]) < 1):
                        stack.append((nx, ny))

            mask[(relay_signal.y, relay_signal.x)] = False

            y, x = np.nonzero(mask * 1)

            for Y, X in zip(y, x):
                if world.bot_map[Y,X].relay_chain:
                    world.bot_map[Y,X].relay_chain.relay_chain_map = []
                    world.bot_map[Y,X].relay_chain.dissolve_chain()

                # if the bot recieving the signal is on food, stay put and
                # change to store mode
                if world.food_map[Y,X]:
                    world.store_mode_map[Y,X] = world.bot_map[Y,X]
                    world.explore_mode_map[Y,X] = None

                # ...otherwise move towards the signal
                else:
                    location = Location(X,Y)
                    print("moving towards food signal", location)

                    world.setup_for_move("step_towards_signal",
                                   location, relay_signal,
                                   world.stored_energy_map[location[::-1]]
                                    - BOT_DEFAULTS["e_threshold_store"])

            # finally move bot from explore to store mode
            world.store_mode_map[new_location[::-1]] = \
                world.bot_map[new_location[::-1]]
            world.explore_mode_map[new_location[::-1]] = None

            # The locations of neightbours on full food cells.
            fed_neighbours = np.ma.make_mask(world.bot_map) * 1 + \
                             np.ma.make_mask(world.food_map) * 1 \
                             - np.ma.make_mask(
                            world.explore_mode_map) * 1

            # form new chains of store bots if possible
            y = list(y)
            x = list(x)
            y.append(new_location.y)
            x.append(new_location.x)

            for Y, X in zip(y, x):
                location = Location(X, Y)

                # ...and if it has any neighbours join up with them
                neighbours_same_food_full = world.bot_map[location[::-1]]\
                    .sense(fed_neighbours,"has_food")

                if neighbours_same_food_full:
                    if world.store_mode_map[location[::-1]]:
                        # print("neighbours same food full attempt connect...")
                        for neighbour in neighbours_same_food_full:
                            # print("neighbours same food full attempt connect...")
                            #global use_chains
                            if use_chains:
                                world.attempt_connect_neighbours(location,
                                                                 neighbour)

    def sense(self, _map, sensing_target):
        """
        Checks if bot has any neighbouring bots/ spaces/ recruits
        Parameters
        ----------
        world : World
            The gridspace in which the robot operates.
        location : Location
            The current location of the robot.
        sensing_target : string
            The item to search for.

        Returns
        -------
        list[Location]
            The location of all neighbours of the target type.

        """
        # top left hand corner of kernel = i, j
        i = self.location.y - BOT_DEFAULTS["sense_range"]
        j = self.location.x - BOT_DEFAULTS["sense_range"]
        k = np.shape(Bot.sense_kernel)[0]

        neighbours = np.argwhere(_map[i:i + k, j:j + k]
                                 - Bot.sense_kernel ==
                                 SENSING_TARGETS[sensing_target])

        return [Location(x + j, y + i) for y, x in neighbours]

    def broadcast_relay_tail(self, world, _map, sensing_target):
        """
            Does a tetris-style shuffle of explorer bots to maintain the
            reservoir of recruitable agents at tail end of the relay chain.

            Parameters
            ----------
            tail : named tuple
                The x,y, cooridnates of the tail end of the relay chain.
            all_relay_bots : array
                A map of all bots currently employed in relay chains.

            """

        i = self.location.y - BOT_DEFAULTS["transmission_range"]
        j = self.location.x - BOT_DEFAULTS["transmission_range"]
        k = np.shape(Bot.transmission_kernel)[0]

        neighbours = np.argwhere(_map[i:i + k, j:j + k]
                                 - Bot.transmission_kernel ==
                                 SENSING_TARGETS[sensing_target])

        neighbours = [Location(x + j, y + i) for y, x in neighbours]

        #print("BROADCAST SIGNAL", self.location)

        for neighbour in neighbours:

            # if not in a chain, any bot can move towards the help signal
            if world.bot_map[neighbour[::-1]].chain == None:
                print("moving towards help signal, signal:", self.location,
                      "neighbour", neighbour)

                print(Bot.transmission_kernel)

                world.setup_for_move("step_towards_signal",
                                    neighbour, self.location,
                                    world.stored_energy_map[self.location[::-1]]
                                    - BOT_DEFAULTS["e_threshold_store"])

    def __repr__(self):
        return "Bot({})".format(self.location)

    def __str__(self):
        return str(self.location)

class RelayChain(object):
    """
    Recruits a bot in explorer mode to a relay chain of other bots in explorer
    mode in order to extend it.

    Parameters
    ----------
    food_map : np.ndarray
        The food map.
    bot : Bot
        The x,y coordinates of the leader of the chain
    heading_x : int
        The distance the leader should move per step in the x direction.
    heading_y : int
        The distance the leader should move per step in the y direction.

    Attributes
    ----------
    connected_bots : list
        All bots in the chain.
    chain_map : array
        The mapped locations of all bots in the chain, presented as an array,
        numbered low to high to indicate sequence.
    recruit : tuple
        The initial location of the new recruit to be added.

    """
    all_relay_bots = None
    relay_chains = []

    def __init__(self, food_map, bot, heading):
        self.chain_map = np.zeros_like(food_map)
        self.relay_chain_count = 1
        self.heading = heading
        self.heading_x = heading.x
        self.heading_y = heading.y
        self.connected_bots = [bot]
        self.relay_chains.append(self)
        self.recruit = None
        #self.all_relay_bots = None

        for bot in self.connected_bots:
            self.chain_map[bot.location[::-1]] = self.relay_chain_count
            self.new_location_generator = "step_to_explore"
            bot.relay_chain = self
            self.relay_chain_count += 1


    def new_recruit(self, world):

        y, x = np.where(
            self.chain_map ==
            np.max(self.chain_map[
                       np.nonzero(self.chain_map)]))
        tail = Location(x[0], y[0])

        neighbouring_recruits = world.bot_map[tail[::-1]].sense(
            (np.ma.make_mask(world.explore_mode_map) * 1
             - np.ma.make_mask(self.all_relay_bots) * 1),
            "neighbouring_recruits")

        if len(neighbouring_recruits) < 1:
            #print("shuffle bots")
            world.bot_map[tail[::-1]].broadcast_relay_tail(world, (

            # any bot on food, not in chain
               # np.multiply((np.ma.make_mask(world.food_map) * 1)
               # (np.ma.make_mask(world.stored_energy_map) * 1))
               #  - RelayChain.all_relay_bots),"neighbouring_bot")

                # any bot not in chain
                (np.ma.make_mask(world.stored_energy_map) * 1)
                - RelayChain.all_relay_bots), "neighbouring_bot")

            self.recruit = None

        else:
        # if len(neighbouring_recruits) >= 1:
            self.recruit = random.choice(neighbouring_recruits)

    def follow_leader(self, world, location, new_location):

        bots_with_energy = np.where(world.stored_energy_map
                                    * np.ma.make_mask(self.chain_map) * 1
                                    > 0)

        relay_bots = np.nonzero(self.chain_map)

        # if all bots have enough energy to move
        if (len(bots_with_energy[0]) == len((relay_bots)[0]) and
            np.nonzero(bots_with_energy) != False):
            print("enough energy to move relay chain")

            # appoint a recruit
            self.new_recruit(world)
            print("new recruit", self.recruit)

            if self.recruit:
                print("good to go")
                if world.bot_move_map[self.recruit[::-1]]:
                    # print("removing recruit from move bot map")
                    world.bot_move_map[self.recruit[::-1]] \
                        = 0

                print("following leader")
                print("nominated recruit", self.recruit)

                _maps = [[world.bot_move_map, True, True],
                         [world.stored_energy_map, True, True],
                         [world.explore_mode_map, False, True],
                         [world.store_mode_map, False, True],
                         [world.bot_map, False, True], ]

                for _map in _maps:
                    world.bot_map[location[::-1]].update_map(new_location,
                                                             location,
                                                             _map[0],
                                                             _map[1],
                                                             _map[2])

                self.connected_bots.append(world.bot_map[self.recruit[::-1]])
                print(self.connected_bots)
                recruit_initial_location = self.connected_bots[-1].location
                self.connected_bots[-1].relay_chain = self

                for bot, next_bot in zip(
                                        self.connected_bots[:-1],
                                        self.connected_bots[1:]):

                    _maps = [[world.explore_mode_map, False, False],
                             [world.stored_energy_map, True, False],
                             [world.bot_map, False, False]]

                    for _map in _maps:
                        world.bot_map[self.recruit[::-1]].update_map(bot.location,
                                                                 next_bot.location,
                                                                 _map[0],
                                                                 _map[1],
                                                                 _map[2])

                RelayChain.all_relay_bots[new_location[::-1]] = 1
                print("extended relay chain")
                print("connected bots", self.connected_bots)
                print("relay chains", RelayChain.relay_chains)

                for bot, next_bot in zip(reversed(self.connected_bots[:-1]),
                                         reversed(self.connected_bots[1:])):
                    next_bot.location = bot.location

                # remove new recruit from original position on all maps
                world.bot_map[recruit_initial_location[::-1]] = None
                world.explore_mode_map[recruit_initial_location[::-1]] = None
                world.stored_energy_map[recruit_initial_location[::-1]] = 0
                world.bot_move_map[recruit_initial_location[::-1]] = 0

                # update chain_map
                self.chain_map = \
                    self.chain_map + np.ma.make_mask(self.chain_map) * 1

                self.chain_map[new_location[::-1]] = 1

                bot_moved = 1
                return bot_moved

            else:
                print("relay chain did not move")
                print("relay chains", RelayChain.relay_chains)
                #print("chain map", self.chain_map[np.nonzero(self.chain_map)])

                world.bot_move_map[location[::-1]] = 0

                bot_moved = 2
                return bot_moved


    def dissolve_chain(self):
        #print("dissolve chain", self.connected_bots)
        self.chain_map  = []
        for bot in self.connected_bots:
            bot.relay_chain = None
        RelayChain.relay_chains.remove(self)

    def remove_bot(self, location, world):
        """
        Remove a bot from the chain it is in.

        Bots severed from the end of the chain when a bot in the chain enters
        store mode are given a random walk command.

        Parameters
        ----------
        location : Location
            The x, y coordinates of the bot in the grid space.
        world : World
            The world in which the bots live.

        """
        #print("remove_bot_from_relay_chain", self.connected_bots)
        break_point = copy.copy(int(self.chain_map[location[::-1]]))
        bots_to_sever = np.where((self.chain_map < break_point) & (self.chain_map > 0))
        print("bots to sever", self.chain_map[bots_to_sever])
        for Y, X in zip(bots_to_sever[0], bots_to_sever[1]):
            self.connected_bots.remove(world.bot_map[Y, X])
            #print("chain with bot severed", self)
            world.bot_map[Y, X].relay_chain = None
            _location = Location(X,Y)
            #print("severed from relay chain, random walk", location)
            world.setup_for_move("random_step",
                                 _location, None,
                                 np.clip(world.stored_energy_map[
                                 _location[::-1]] -
                                 BOT_DEFAULTS["e_threshold_store"],
                                 0, float("inf")))

        # remove the transitioning bot
        world.bot_map[location[::-1]].relay_chain = None
        self.connected_bots.remove(world.bot_map[location[::-1]])

        # decrease all bot numbers on chain map by value of break point
        #print("chain_map_initial", self.chain_map[np.where(self.chain_map)])
        self.chain_map = np.clip(
            (self.chain_map - break_point),
            0, float("inf"))

        # if noone is left on the map, dissolve the chain.
        if not self.chain_map.any():
            #print("no one left, dissolve chain")
            self.dissolve_chain()

    def __repr__(self):
        return "Chain({})".format(self.connected_bots)

    def __str__(self):
        return str(self.connected_bots)


class Chain(object):
    """
    Describes serially connected bots in storage mode.

    Parameters
    ----------
    food_map : np.ndarray
        The food map.
    connected_bots : list
        All bots in the chain.

    Attributes
    ----------
    connected_bots : list
        All bots in the chain.
    chain_map : np.ndarray
        The mapped locations of all bots in the chain, presented as an array,
        numbered low to high to indicate sequence.

    """
    chains = []

    def __init__(self, food_map, connected_bots):
        self.connected_bots = connected_bots
        self.chain_map = np.zeros_like(food_map)

        for chain_count, bot in enumerate(self.connected_bots, 1):
            bot.chain = self
            self.chain_map[bot.location[::-1]] = chain_count

        self.chains.append(self)

    def remove_bot(self, location, world):
        """
        Remove a bot from the chain it is in.

        Bots severed from the end of the chain are formed into a new chain if
        there are more than one of them.

        Parameters
        ----------
        location : Location
            The x, y coordinates of the bot in the grid space.
        world : World
            The world in which the bots live.

        """

        break_point = self.chain_map[location[::-1]]

        # TODO: there MUST be a better way to find the intersection of two 2d
        # arrays,replace this temp solution:
        y, x = np.where(self.chain_map < break_point)
        v, u = np.nonzero(self.chain_map)
        z = [Location(X, Y) for X, Y in zip(x, y)]
        w = [Location(U, V) for U, V in zip(u, v)]
        bots = list((set(w) & set(z)))

        # TODO: the following code repeats: encapsulate in function
        if len(bots) >= 2:
            _bots_to_connect = []
            for bot in bots:
                _bots_to_connect.append(world.bot_map[bot[::-1]])
            Chain(world.food_map, _bots_to_connect)

        elif len(bots) == 1:
            for bot in bots:
                world.bot_map[bot[::-1]].chain = None

        y, x = np.where(self.chain_map > break_point)
        bots = [Location(X, Y) for X, Y in zip(x, y)]

        if len(bots) >= 2:
            _bots_to_connect = []
            for Y, X in zip(y, x):
                _bots_to_connect.append(world.bot_map[Y, X])
            Chain(world.food_map, _bots_to_connect)

        elif len(bots) == 1:
            for bot in bots:
                world.bot_map[bot[::-1]].chain = None

        world.bot_map[location[::-1]].chain = None
        # print("trying to fix error1")
        # print("chain", self)
        # print("chains", Chain.chains)
        # print("bots", world.bot_map[np.where(self.chain_map)])
        Chain.chains.remove(self)

        # print("chain map after", world.bot_map[np.nonzero(self.chain_map)])
        # print("chain after", self.connected_bots])
        # print(Chain.chains)

    def dissolve_chain(self, world):
        # print("trying to fix error2")
        # print(self)
        # print(Chain.chains)
        # print(world.bot_map[np.where(self.chain_map)])
        self.chain_map = []
        for bot in self.connected_bots:
            bot.chain = None

        Chain.chains.remove(self)

    def appoint_leader(self, world):
        """
        Appoint the bot as a leader of a chain.

        Parameters
        ----------
        world : World
            The world that that bots operate in.

        """
        #print("appoint leader")
        #print("before appoint leader")
        j, i = np.nonzero(self.chain_map)
        #print("chain map", np.argwhere(self.chain_map))
        #print("chain", self.connected_bots)
        #print("Chains", Chain.chains)
        #print("RelayChains", RelayChain.relay_chains)

        # identify bots in chain with space around them as potential leaders
        potential_leaders = []
        potential_headings = []

        # transition all bots in chain from store mode to explore mode
        #for J, I in zip(j, i):
        # attempt bug fix by searching for chain bots in a different way
        for bot in self.connected_bots:
            I = bot.location.x
            J = bot.location.y

            #print("bot", I, J)
            world.explore_mode_map[J, I] = world.bot_map[J, I]
            world.store_mode_map[J, I] = None
            #print("chain bot to explore bot", world.explore_mode_map[J, I] )

            neighbouring_spaces = world.bot_map[J, I].sense(
                np.ma.make_mask(world.bot_map) * 2,
                "neighbouring_space")

            if neighbouring_spaces:
                _heading = None
            # if len(neighbouring_spaces) >= 3:
                for neighbour in neighbouring_spaces:
                    # if there is a bot on the opposite side, make heading
                    if world.bot_map[J-(J - neighbour.y), I-(I - neighbour.x)]:
                        #print("bot", I, J)
                        #print("neighbour", neighbour)
                        # _heading = Location(J-(J - neighbour.y),
                        #                     I-(I - neighbour.x))
                        _heading = Location(J + (J - neighbour.y),
                                            I + (I - neighbour.x))

                    #print("neighbouring space", world.bot_map[neighbour[::-1]])

                #print("")
                potential_leaders.append(Location(I, J))

                if _heading:
                    potential_headings.append(_heading)
                else:
                    potential_headings.append(neighbouring_spaces)

        # randomly select potential leader as leader
        if potential_leaders:
            leader = random.choice(potential_leaders)

            print("leader", leader)
            print("explorer map", world.explore_mode_map[leader[::-1]])
            world.bot_map[leader[::-1]].new_location_generator = "step_to_explore"


            # and select one of its neighbouring spaces at random as the
            # heading to move on
            heading = random.choice(
                potential_headings
                [potential_leaders.index(leader)])
            #print("heading", heading)

            # change heading to be 1 variable

            heading = Location((heading.x - leader.x), (heading.y - leader.y))

            RelayChain(
                world.food_map,
                world.bot_map[leader[::-1]],
                heading)

            # and finally dissolve the chain
            self.dissolve_chain(world)

            # print("chain map", np.argwhere(self.chain_map))
            # print("chain", self.connected_bots)
            # print(Chain.chains)
            # print("Relay Chain", RelayChain.relay_chains)

    def __repr__(self):
        return "RelayChain({})".format(self.connected_bots)

    def __str__(self):
        return str(self.connected_bots)


class World(object):
    """
    Maps the distribution of food over the grid space.

    Parameters
    ----------
    n_bots : int
        The number of bots
    food : Food
        The food distribution across the grid space.

    Attributes
    ----------
    n_bots : int
        The number of bots
    food : object
        The food distribution across the grid space.
    n_food_cells :
        The number of food cells
    map_size : int
        The length of each side of the food map.
    food_map : np.ndarray
        The distribution of food across the grid space.
    bot_map : np.ndarray
        The distribution of bots across the grid space.
    bot_map_size : int
        The length of each side of the bot map in grid units.
    stored_energy_map : np.ndarray
        The map of cumulative energy stored by each bot.
    data_to_log

    """
    sense_range = BOT_DEFAULTS["sense_range"]
    transmission_range = BOT_DEFAULTS["transmission_range"]

    def __init__(self, n_bots, food):
        self.n_bots = n_bots
        self._food = food
        self.n_cells = self._food.n_cells
        self.map_size = self._food.map_size
        self.food_map, self.food_map_size = self._pad_map(self._food.food_map,
                                                np.maximum(self.transmission_range,
                                                       self.sense_range))
        self.bot_move_map = self.food_map * 0
        self.bot_map = None
        self.bot_map_size = None
        self._populate_bot_map()

        self.e_threshold_explore = BOT_DEFAULTS["e_threshold_explore"]
        # self.store_mode_map = np.empty(
        #     self.bot_map_size ** 2, dtype=object
        #     ).reshape(self.bot_map_size,
        #     self.bot_map_size)
        self.store_mode_map = np.copy(self.bot_map) # initialise bots in store mode
        # plt.matshow(np.ma.make_mask(self.store_mode_map))
        # plt.show()

        self.explore_mode_map = np.empty(
            self.bot_map_size ** 2, dtype=object
            ).reshape(self.bot_map_size,
            self.bot_map_size)

        # Convert to integer mask. dtype=int does not work.
        self.stored_energy_map = np.ma.make_mask(self.bot_map) \
                                 * BOT_DEFAULTS["e_stored_initial"]

        self.area_covered_map = np.copy(np.ma.make_mask(self.bot_map)*1)
        self.before_move_x = None
        self.before_move_y = None
        self.after_move_x = None
        self.after_move_y = None
        self.before_move = None

        self.move_bots_cycle = []

        self.frame = 0

    def _pad_map(self, map_to_pad, _border_width):
        """
        Creates a border of width = _border_width around the map as dictated by
        the sense range of the bots. This is to prevent errors generated by
        functions that use elements of a window around each bot, the size of
        which is defined  by the robot sense range.

        Parameters
        ----------
        map_to_pad : array
            The map to pad.

        _border_width :
            The border width in grid units
        """
        _full_map_size = int(self.map_size + 2*_border_width)

        if map_to_pad.dtype == object:
            _full_map = np.empty(
                (_full_map_size) ** 2, dtype=object).reshape\
                (_full_map_size,
                 _full_map_size)

        else:
            _full_map = np.zeros(
                (_full_map_size) ** 2).reshape\
                (_full_map_size,
                 _full_map_size)

        _full_map[_border_width:(
                _border_width + self.map_size),
                _border_width:(
                _border_width
                + self.map_size)] = map_to_pad

        return _full_map, _full_map_size

    def _populate_bot_map(self):

        """
        Distributes n_bots start locations randomly over the grid space

        """
        if bot_map_style == "existing_map":
            self.bot_map = np.load(dirname + "/"+ bot_map_dir + "/" + bot_map_name + "bots.npy")
            self.bot_map_size = np.shape(self.bot_map)[0]
            bot_map_name = dirname + "/"+ subdirname + "/" + bot_map_name

        else:

            if bot_map_style == "new_random_map":
                self.bot_map = np.empty(self.n_cells, dtype=object)

                for i in range(self.n_bots):
                    self.bot_map[i] = Bot(self, **BOT_DEFAULTS)

                np.random.shuffle(self.bot_map)
                self.bot_map = np.reshape(self.bot_map, (self.map_size, self.map_size))


            elif bot_map_style == "pre_designed_map":
                self.bot_map = np.empty(self.n_cells, dtype=object)
                self.bot_map = np.reshape(self.bot_map,
                                          (self.map_size, self.map_size))
                _swarm_initialisation = self.bot_map.ravel()
                for bot in range(self.n_bots):
                    _swarm_initialisation[bot] = Bot(self, **BOT_DEFAULTS)
                np.random.shuffle(_swarm_initialisation[:0.5 * self.n_cells])
                self.bot_map = np.transpose(self.bot_map)

            self.bot_map, self.bot_map_size = self._pad_map(self.bot_map,
                                                            np.maximum(
                                                                self.transmission_range,
                                                                self.sense_range))
            y, x = np.where(self.bot_map)
            for Y, X in zip(y, x):
                self.bot_map[Y, X].location = Location(X, Y)
            bot_map_name = (dirname + "/" + subdirname +
                            "/" + subdirname)

        np.save(bot_map_name + "bots", self.bot_map)

    def feed(self):
        """
        Decreases food map by 1 unit in every grid cell occupied by a bot
        Produces _e_from_food_map of all energy accumulated from feeding
        Updates the stored energy map with the energy from feeding TODO: plot at
        the end with all consumed energy condsidered: base metabolic energy
        expenditure etc

        """
        _units_consumed = BOT_DEFAULTS["e_consumed_per_feed"]

        np.clip(self.food_map -
                (np.ma.make_mask(self.bot_map) * _units_consumed),
                0, float("inf"), self.food_map)

        _e_from_food_map = np.clip(divide_matrices(self.food_map,
                np.ma.make_mask(self.bot_map)),
                0, 1)

        self.stored_energy_map = np.clip(self.stored_energy_map +
            (_e_from_food_map * _units_consumed),
            0, BOT_DEFAULTS["e_stored_max"], self.stored_energy_map)

    def base_metabolism(self):
        """
        Decreases food map by 1 unit in every grid cell occupied by a bot
        Produces _e_from_food_map of all energy accumulated from feeding
        Updates the stored energy map with the energy from feeding.

        """
        np.clip(
            self.stored_energy_map - BOT_DEFAULTS["base_metabolism"],
            0, float("inf"), self.stored_energy_map)

    def transition_bots(self):

        transition_to_store =  np.where((np.ma.make_mask(self.bot_map)*1>0) &
                                        (self.stored_energy_map <= BOT_DEFAULTS["e_threshold_store"]) &
                                             (np.ma.make_mask(self.store_mode_map) * 1 < 1))

        self.store_mode_map[transition_to_store] = \
            self.bot_map[transition_to_store]
        self.explore_mode_map[transition_to_store] = \
            None

        if transition_to_store[0].any():
            for Y, X in zip(transition_to_store[0],
                            transition_to_store[1]):

                if self.bot_map[Y, X].relay_chain:
                    #print("transitioning store bot in relay chain:", Location(X,Y))
                    self.bot_map[Y, X].relay_chain.\
                        remove_bot(Location(X, Y), self)

            global transition_to_store_count
            transition_to_store_count += 1

        transition_to_explore = np.where(
            (self.stored_energy_map >= BOT_DEFAULTS["e_threshold_explore"]) &
            (self.store_mode_map != None))

        self.explore_mode_map[transition_to_explore] = \
            self.bot_map[transition_to_explore]
        self.store_mode_map[transition_to_explore] = \
            None

        # bots transitioning to explorer bots behave according to wether they
        # are in a chain.
        if transition_to_explore[0].any():
            for Y,X in zip(transition_to_explore[0],
                           transition_to_explore[1]):
                location = Location(X,Y)

                if self.bot_map[Y, X].relay_chain:
                    # print("transitioning bot in relay chain:", location)
                    # print(self.bot_map[location[::-1]].relay_chain.connected_bots)
                    # print(RelayChain.relay_chains)
                    pass

                elif self.bot_map[location[::-1]].chain:
                    if use_relay_chains == True:
                        self.bot_map[Y, X].chain.appoint_leader(self)
                    #pass

                else:
                   # print("transitioning bot not in any chain:", location)
                    #print("random walk")

                    location = Location(X,Y)
                    # if there is not food
                    if not ((np.ma.make_mask(self.food_map) * 1)[location[::-1]]):
                        self.setup_for_move("random_step",
                                             location, None,
                                             np.clip(self.stored_energy_map[
                                                         location[::-1]],
                                                     0, float("inf")))
            global transition_to_explore_count
            transition_to_explore_count += 1

        # exclude incapacitated bots (0 stored energy) from store and explore
        # modes
        incapacitated_bots = np.where(
            (self.bot_map != None) and
            (self.stored_energy_map == 0))
        # self.explore_mode_map[incapacitated_bots] = None
        # self.store_mode_map[incapacitated_bots ] = None

        return incapacitated_bots

    def feed_hungry_neighbour(self, location_bot_feed, location_bot_receive):

        """
        Transfers stored energy from one bot to another.

        Parameters
        ----------
        location_bot_feed : tuple
         The x,y coordinates of the bot which is the energy donor.

        location_bot_receive : tuple
         The x,y coordinates of the bot which is the energy recipiant.
        """
        # TODO: include energy transfer effiency

        global trophallaxis_count_explore
        global trophallaxis_count_store

        if self.stored_energy_map[location_bot_feed[::-1]] \
                     > BOT_DEFAULTS["e_threshold_trophallaxis"]:

            _e_donor = self.stored_energy_map[location_bot_feed[::-1]]
            #_e_recipiant = self.stored_energy_map[location_bot_receive[::-1]]
            _e_recipiant = copy.copy(
                int(self.stored_energy_map[location_bot_receive[::-1]]))

            if BOT_DEFAULTS["trophallaxis_mode"] == "equalise":
                if ( _e_donor - (np.average([_e_donor, _e_recipiant])) > 0):
                    food_transferred = int(_e_donor - (
                        np.average([_e_donor, _e_recipiant])))
                    if food_transferred:
                        if self.explore_mode_map[location_bot_feed[::-1]]:
                            trophallaxis_count_explore += 1
                        else:
                            trophallaxis_count_store += 1
                else:
                    food_transferred = 0

            if BOT_DEFAULTS["trophallaxis_mode"] == "top_up_recipiant_cautious":

                _e_desired = BOT_DEFAULTS["e_threshold_store"] - _e_recipiant

                available_energy = np.clip((_e_donor -
                                    BOT_DEFAULTS["e_threshold_trophallaxis"]),
                                    0, float("inf"))

                food_transferred = int(np.clip(_e_desired, 0, available_energy))
                if food_transferred:
                    if self.explore_mode_map[location_bot_feed[::-1]]:
                        trophallaxis_count_explore += 1
                    else:
                        trophallaxis_count_store += 1
        else:
            food_transferred = 0

        #print("food_transferred", food_transferred)

        self.stored_energy_map[location_bot_feed[::-1]] -= food_transferred
        self.stored_energy_map[location_bot_receive[::-1]] += food_transferred

        # _e_donor = self.stored_energy_map[location_bot_feed[::-1]]
        # _e_recipiant = self.stored_energy_map[location_bot_receive[::-1]]
        #
        # print("feed", location_bot_feed,  _e_donor)
        # print("receive",location_bot_receive, _e_recipiant )

        # if the bot is on the bot move map, decrease the number of steps it
        # should take.
        if self.bot_move_map[location_bot_feed[::-1]]:
            self.bot_move_map[location_bot_feed[::-1]] = np.clip(
                (self.bot_move_map[location_bot_feed[::-1]] -
                 int(food_transferred * BOT_DEFAULTS["e_cost_per_step"])
                 ), 0, float("inf"))

        # if bot was fed, and not by robot in chain...
        if food_transferred:

            # if ((self.bot_map[location_bot_receive[::-1]].chain == None) and
            #     (self.bot_map[location_bot_receive[::-1]].relay_chain == None)):

                # if the bot had energy when fed, move towards the feeder
                # if _e_recipiant > 0:

            _heading = \
                Location((location_bot_feed.x - location_bot_receive.x),
                         (location_bot_feed.y - location_bot_receive.y))

            self.setup_for_move("step_towards_feeder", location_bot_receive,
                                _heading)

                # otherwise, if bot being fed on start-up move away from donor
                # else: # if _e_recipiant == 0
                #
                #     # if (self.bot_map[location_bot_feed[::-1]].relay_chain or
                #     #     self.bot_map[location_bot_feed[::-1]].chain or
                #     #     self.food_map[location_bot_feed[::-1]]):
                #
                #     _heading = \
                #         Location((location_bot_receive.x - location_bot_feed.x),
                #                  (location_bot_receive.y - location_bot_feed.y))
                #
                #     print("move away from feeder")
                #     self.setup_for_move("step_towards_feeder",
                #                         location_bot_receive,
                #                         _heading)
                    # else:
                    #
                    #     _heading = \
                    #         Location((location_bot_feed.x - location_bot_receive.x),
                    #                  (location_bot_feed.y - location_bot_receive.y))
                    #
                    #     self.setup_for_move("step_towards_feeder",
                    #                         location_bot_receive,
                    #                         _heading)

                    # self.setup_for_move("random_step",
                    #                     location_bot_receive,
                    #                     None,
                    #                     np.clip(self.stored_energy_map[
                    #                     location_bot_receive[::-1]],
                    #                     0, float("inf")))

    def setup_for_move(self, new_location_generator,
                       location, target_location,
                       units_moved = 1):

        print("location1", location)
        print("target location1", target_location)

        if (location and target_location
            and (int(location.x) == int(target_location.x))
            and (int(location.y) == int(target_location.y))):

                print("already at target loc.", location)
                pass

        else:

            self.bot_map[location[::-1]]. \
                new_location_generator = new_location_generator

            self.bot_move_map[location[::-1]] = units_moved

            if (self.bot_map[location[::-1]].
                new_location_generator == "step_towards_neighbour" or
                self.bot_map[location[::-1]].
                    new_location_generator == "step_towards_signal"):

                # # if there is energy to move
                # if self.stored_energy_map[location[::-1]]:

                self.bot_map[location[::-1]].target_location = target_location

            # elif self.bot_map[location[::-1]]. \
            #     new_location_generator == "step_to_explore":

            elif (self.bot_map[location[::-1]].
                  new_location_generator == "step_to_explore" or
                                  self.bot_map[location[::-1]].
                  new_location_generator == "step_towards_feeder"):

                self.bot_map[location[::-1]].target_location = \
                Location(location.x + target_location.x,
                         location.y + target_location.y)



    def attempt_connect_neighbours(self, location, equal_neighbour):
        #print("attempting connnection")

        def connect_chains(_chain, _other_chain, max_to_add):
            _chain.chain_map = _chain.chain_map + _other_chain.chain_map

            for Y, X in zip(y, x):
                _chain.chain_map[Y, X] += max_to_add

            #_chain.connected_bots += _other_chain.connected_bots
            #print("_chain.connected_bots", _chain.connected_bots)
            _chain.connected_bots.extend(_other_chain.connected_bots[:])
            #print("_chain.connected_bots", _chain.connected_bots)
            # for bot in _other_chain.connected_bots:
            for bot in _chain.connected_bots:
                bot.chain = _chain
                #print(bot)
                #print(bot.chain)

            _other_chain.chain_map = []
            #print("remaining chains")
            Chain.chains.remove(_other_chain)

            #_other_chain.dissolve_chain() - THIS RESETS ALL NEW CHAIN MEMBERS' bot.chain value to 0
            # Chain.chains.remove(_other_chain)
            # print("connected chain to chain", _chain)

        # case 1: two single bots
        if not self.bot_map[location[::-1]].chain \
                and not self.bot_map[equal_neighbour[::-1]].chain:
            #print("case 1: two single bots")
            #print("connected single bots", self.bot_map[location[::-1]].chain)
            Chain(self.food_map, [self.bot_map[location[::-1]],
                                  self.bot_map[equal_neighbour[::-1]]])

        # case 2: connect single bot to bot in chain
        elif bool(self.bot_map[location[::-1]].chain) != \
                bool(self.bot_map[equal_neighbour[::-1]].chain):
            #print("case 2: connect single bot to bot in chain")

            if self.bot_map[location[::-1]].chain:
                _chain = self.bot_map[location[::-1]].chain
                _bot = location
                _other_bot = equal_neighbour

            else:
                _chain = self.bot_map[equal_neighbour[::-1]].chain
                _bot = equal_neighbour
                _other_bot = location

            # connect to min of chain
            if _chain.chain_map[_bot[::-1]] == \
                    np.min(_chain.chain_map[np.nonzero(_chain.chain_map)]):
                y, x = np.nonzero(_chain.chain_map)
                _chain.chain_map[y, x] += 1
                # add new bot at min of chain
                _chain.chain_map[_other_bot[::-1]] = 1
                _chain.connected_bots.append(self.bot_map[_other_bot[::-1]])
                self.bot_map[_other_bot[::-1]].chain = _chain

            # connect to max of chain
            if _chain.chain_map[_bot[::-1]] == \
                    np.max(_chain.chain_map[np.nonzero(_chain.chain_map)]):
                # add new bot at max of chain
                _chain.chain_map[_other_bot[::-1]] = \
                    np.max(_chain.chain_map[np.nonzero(_chain.chain_map)]) + 1
                _chain.connected_bots.append(self.bot_map[_other_bot[::-1]])
                self.bot_map[_other_bot[::-1]].chain = _chain
                #print("connected single to chain")

        # case 3: both bots in chains
        # TODO: simpler decision matrix
        elif self.bot_map[location[::-1]].chain \
                and self.bot_map[equal_neighbour[::-1]].chain:
            # and it is not the same chain
            if (self.bot_map[location[::-1]].chain.connected_bots !=
                    self.bot_map[equal_neighbour[::-1]].chain.connected_bots):

                #print("case 3: both bots in different chains")

                _bot = location
                _other_bot = equal_neighbour
                _chain = self.bot_map[location[::-1]].chain
                _other_chain = self.bot_map[equal_neighbour[::-1]].chain

                # min of chain to max of other chain
                if (_chain.chain_map[_bot[::-1]] == np.min(_chain.chain_map
                                                           [np.nonzero(
                        _chain.chain_map)])
                    and _other_chain.chain_map
                    [_other_bot[::-1]]
                        == np.max(_other_chain.chain_map
                                  [np.nonzero(
                                _other_chain.chain_map)])):
                    y, x = np.nonzero(_chain.chain_map)
                    max_to_add = np.max(_other_chain.chain_map
                                        [np.nonzero(_other_chain.chain_map)])
                    connect_chains(_chain, _other_chain, max_to_add)

                    # print("min of chain to max of other chain", _chain)

                # max of chain to min of other chain

                if (_chain.chain_map[_bot[::-1]] == np.max(_chain.chain_map
                                                           [np.nonzero(
                        _chain.chain_map)])
                    and _other_chain.chain_map[
                        _other_bot[::-1]]
                        == np.min(_other_chain.chain_map[np.nonzero(
                            _other_chain.chain_map)])):
                    # print("max of chain to min of other chain")

                    y, x = np.nonzero(_other_chain.chain_map)
                    max_to_add = np.max(_chain.chain_map[np.nonzero(
                        _chain.chain_map)])
                    connect_chains(_chain, _other_chain, max_to_add)

                # min of chain to min of other chain

                if (_chain.chain_map[_bot[::-1]] ==
                        np.min(_chain.chain_map[np.nonzero(
                            _chain.chain_map)])
                    and
                            _other_chain.chain_map[_other_bot[::-1]] ==
                            np.min(_chain.chain_map[np.nonzero(
                                _chain.chain_map)])):

                    # print("min of chain to min of other chain")

                    y, x = np.nonzero(_other_chain.chain_map)

                    max_to_add = np.max(_other_chain.chain_map[np.nonzero(
                        _other_chain.chain_map)])

                    # reverse order of other_chain
                    for Y, X in zip(y, x):
                        _other_chain.chain_map[Y, X] = max_to_add + 1 - \
                                                       _other_chain.chain_map[
                                                           Y, X]

                    y, x = np.nonzero(_chain.chain_map)
                    connect_chains(_chain, _other_chain, max_to_add)

                # max of chain to max of other chain

                if _chain.chain_map[_bot[::-1]] == \
                        np.max(_chain.chain_map
                               [np.nonzero(_chain.chain_map)]) \
                        and \
                                _other_chain.chain_map[
                                    _other_bot[::-1]] == np.max(
                            _other_chain.chain_map[np.nonzero(
                                _other_chain.chain_map)]):

                    # print("max of chain to max of other chain")

                    y, x = np.nonzero(_other_chain.chain_map)

                    max_to_add = np.max(_other_chain.chain_map
                                        [np.nonzero(
                            _other_chain.chain_map)])

                    # reverse order of other_chain
                    for Y, X in zip(y, x):
                        _other_chain.chain_map[Y, X] = max_to_add + 1 - \
                                                       _other_chain.chain_map[
                                                           Y, X]

                    y, x = np.nonzero(_chain.chain_map)
                    connect_chains(_chain, _other_chain, max_to_add)

    def plot(self, number):


            f, ax = plt.subplots()
            ax.matshow(self.food_map, cmap='Greens', vmin=0,
                        vmax=self._food.max_food_per_cell)

            # stored energy
            y, x = np.where(self.bot_map)
            ax.scatter(
                x, y, 70,
                c=self.stored_energy_map[y, x],
                cmap="Reds",
                vmin=0,
                vmax=self.e_threshold_explore)

            # explore mode
            y, x = np.where(self.explore_mode_map)
            ax.scatter(
                x, y, 80,
                edgecolor='r',
                facecolors='none',
                linewidth='2'
            )

            # store mode
            y, x = np.where(self.store_mode_map)
            ax.scatter(
                x, y, 80,
                edgecolor='k',
                facecolors='none',
                linewidth='2'
            )

            # chains
            color = iter(plt.cm.plasma(np.linspace(0, 1, 20)))
            for chain in Chain.chains:
                y, x = np.where(chain.chain_map)
                d = next(color)
                ax.scatter(
                    x, y, 80,
                    edgecolor=d,
                    facecolors='none',
                    linewidth='3'
                )

            # relay chains
            color = iter(plt.cm.viridis(np.linspace(1, 0, 20)))
            for relaychain in RelayChain.relay_chains:
                y, x = np.where(relaychain.chain_map)
                d = next(color)
                ax.scatter(
                    x, y, 80,
                    edgecolor=d,
                    facecolors='none',
                    linewidth='3'
                )

            # vectors showing bot trajectory
            if number == 1:
                for A, B, C, D in zip(
                        self.before_move_y, self.before_move_x,
                        self.after_move_y, self.after_move_x):
                    ax.plot([B, D], [A, C], c='r')

            plt.ylim((0, self.bot_map_size ))
            plt.xlim((0, self.bot_map_size))


            #self.frame += 1
            plotname = dirname + "/" + subdirname \
                       + "/video_files/" + str(self.frame).zfill(4)
            self.frame += 1

            f.savefig(plotname + '.pdf', orientation='landscape')
            f.savefig(plotname + '.png', orientation='landscape')

    def save_data_init(self, food_map):

        attributes = food_map.__dict__
        del attributes["food_map"]
        attributes.update(BOT_DEFAULTS)

        # write data to data summary
        with open(data_summary, 'w') as s:
            writer = csv.writer(s)
            for key, value in attributes.items():
                writer.writerow([key, value])
            writer.writerow(["n_bots", self.n_bots])
            writer.writerow(["seed np:", seed_np])
            writer.writerow(["seed random:", seed_random])

        # self.data_to_log = ["count", "bots_alive",
        #                   "bots_on_food_left", "bots_on_food_right",
        #                   "total_food_on_left", "total_food_on_right",
        #                   "food_patches", "total_food",
        #                   "bots_in_chain", "bots_in_relay_chain"]

        # count
        # bots alive before / after move
        # total food n_cells
        # total food
        # bots on food before move that do not move (stop on food) bots on food not on move map
        # bots on food before move that do move (walk explore) bots on food not on move map OR transitioning explore bots
        # explore bots that moved in last run tht end up not on food (stop not on food)
        # explore bots that moved in last run tht end up not on food (stop not on food)
        # fed bots
        # occupied food cells depleted
        # fed bots + occupied food cells depleted

        self.data_to_log = ["count", "total_food", "food_patches",
                            "bots_alive_before_move", "bots_alive_after_move",
                            #"bots_on_food_move", "bots_on_food_no_move",
                            "troph_by_storers", "troph_by_explorers",
                            "success_forage_storers",
                            "success_forage_explorers",
                            "successful_forage_dont_stop",
                            "unsuccessful_foragers",
                            "depleted_food_cells",
                            #"moved_to_food", "moved_to_empty",
                            "area_covered",
                            "nbots_walk_search", "nbots_walk_explore",
                            "nbots_stop_on_food", "nbots_stop_off_food",
                            "transition_to_store_count",
                            "transition_to_explore_count",
                            "bots_in_chain", "bots_in_relay_chain"
                            ]

        with open(data_per_timestep, 'w') as c:
            writer = csv.writer(c)
            writer.writerow(self.data_to_log)

        bots_alive_before_move = len(np.where(self.stored_energy_map)[0])

        _food_cells = np.copy(
            len(np.where(np.ma.make_mask(self.food_map) * 1)[0]))


        nbots_walk_search = len(np.where(
                                (np.ma.make_mask(self.store_mode_map) * 1 > 0)
                                & (np.ma.make_mask(self.bot_move_map) * 1 < 1)
                                )[0])
        nbots_walk_explore = len(np.where(
                                (np.ma.make_mask(self.explore_mode_map) > 0)
                                )[0])
        nbots_stop_on_food = len(np.where(
                                (np.ma.make_mask(self.bot_map) * 1 > 0)
                                & (np.ma.make_mask(self.food_map) * 1 > 0)
                                & (np.ma.make_mask(self.bot_move_map) * 1 < 1)
                                )[0])

        nbots_stop_off_food = len(np.where(
                                (np.ma.make_mask(self.bot_map) * 1 > 0)
                                & (np.ma.make_mask(self.food_map) * 1 < 1)
                                & (np.ma.make_mask(self.bot_move_map) * 1 < 1)
                                )[0])

        self.save_data_per_timestep(bots_alive_before_move, 0, 0,
                                    _food_cells,
                                     nbots_walk_search,
                                     nbots_walk_explore,
                                     nbots_stop_on_food,
                                     nbots_stop_off_food)

    def save_data_per_timestep(self, bots_alive_before_move,
                                     bots_on_food_move,
                                     bots_on_food_no_move,
                                     _food_cells,
                                     nbots_walk_search,
                                     nbots_walk_explore,
                                     nbots_stop_on_food,
                                     nbots_stop_off_food):



        # log data to data per cycle
        with open(data_per_timestep, 'a') as c:
            writer = csv.writer(c)
            writer.writerow([
                # count
                count,

                # total food
                np.sum(self.food_map),

                # food patches
                len(np.where(self.food_map)[0]),

                # bots_alive_before_move
                bots_alive_before_move,

                # bots_alive_after_move
                len(np.where(self.stored_energy_map)[0]),

                # # bots on food move
                # bots_on_food_move,
                #
                # # bots on food no move
                # bots_on_food_no_move,

                # trophallaxis by static bots on food
                trophallaxis_count_store,

                # trophallaxis by explorer bots
                trophallaxis_count_explore,

                # successful foraging storer bots
                forage_success_count_store,

                # successful foraging explorer bots that stop
                forage_success_count_explore,

                # sucessful foraging explorer bots that dont stop (return
                # to explore mode immediately)
                forage_success_dont_stop_count,

                # unsuccessful foragers
                forage_unsuccessful_count,

                # depleted food cells
                _food_cells - len(np.where(self.food_map)[0]),

                # # moved to food
                # forage_success_count_explore,
                #
                # # moved to empty
                # food_cells_depleted_count,

                # total area covered
                len(np.where(self.area_covered_map)[0]),

                # n walk search bots
                nbots_walk_search,

                # n walk explore bots
                nbots_walk_explore,

                # n bots stopped on food
                nbots_stop_on_food,

                # n bots stopped off food
                nbots_stop_off_food,

                # transitioned to store
                transition_to_store_count,

                # trasitioned to explore
                transition_to_explore_count,

                # bots_in_chain
                0,

                # bots_in_relay_chain
                0

                ])

    def save_data_final(self):

        if np.any(self.stored_energy_map):
            s = csv.writer(open(data_summary, 'a'))
            s.writerow(["area_covered",
                        len(np.argwhere(self.area_covered_map))])
            s.writerow(["count", count])
            s.writerow(["all food eaten"])
            s.writerow(
                ["bots_still_alive", len(np.argwhere(self.stored_energy_map))])
            print("all food eaten")

        elif np.any(self.food_map):
            s = csv.writer(open(data_summary, 'a'))
            s.writerow(["area_covered",
                        len(np.argwhere(self.area_covered_map))])
            s.writerow(["count", count])
            s.writerow(["all_bots_dead"])
            s.writerow(
                ["total_food_end", np.sum(self.food_map)])
            s.writerow(
                ["n_food_cells_end", len(np.argwhere(self.food_map))])
            print("all bots dead")

    def plot_data_per_time_step(self):

        data = np.genfromtxt(data_per_timestep, delimiter=',',
                             skip_header=2, skip_footer=0,
                             names= self.data_to_log)

        fig, ax1 = plt.subplots()
        ax2 = ax1.twinx()

        lns1 = ax2.plot(data['count'], data['bots_alive'], marker='o',
                        linestyle='-', color='k', label='Robots alive')
        lns3 = ax2.plot(data['count'], data['bots_on_food_left'], marker='.',
                        linestyle='-', color='k', label='Robots on food, left')
        lns5 = ax2.plot(data['count'], data['bots_on_food_right'], marker='^',
                        linestyle='-', color='k', label='Robots on food, right')
        lns7 = ax1.plot(data['count'], data['total_food'], marker='x',
                        linestyle='-', color='k', label='Total Food Remaining')

        lns = lns1 + lns3 + lns5 + lns7
        labels = [l.get_label() for l in lns]
        ax1.legend(lns, labels, loc=0, frameon=False)
        ax1.set_xlabel('Cycles')
        ax1.set_ylabel('Total Food Units')
        ax2.set_ylabel('Number of Robots')

        plotname = dirname + "/"+ subdirname + "/" \
                    + subdirname + '_per_timestep'

        fig.savefig(plotname + '.pdf', orientation='landscape')

def main():
    global count
    global trophallaxis_count_explore
    global trophallaxis_count_store
    global food_cells_depleted_count
    global forage_success_count_explore
    global forage_success_count_store
    global forage_success_dont_stop_count
    global forage_unsuccessful_count
    global transition_to_store_count
    global transition_to_explore_count

    trophallaxis_count_explore = 0
    trophallaxis_count_store = 0
    food_cells_depleted_count = 0
    forage_success_count_explore = 0
    forage_success_count_store = 0
    forage_success_dont_stop_count = 0
    forage_unsuccessful_count = 0
    transition_to_store_count = 0
    transition_to_explore_count = 0




    food_map = Food(n_cells = n_cells,
                    max_food_per_cell=40,
                    ratio_full_to_empty= 0.75,
                    food_generation_threshold= 3,
                    food_elimination_threshold= 6,
                    food_map_iterations= 5
                    )

    world = World(n_agents, food_map)

    world.save_data_init(food_map)
    if plot_output:
        world.plot(0)

    # loop for a given count:
    #while(count < 1000):

    # loop until:
    # a) all bots incapacitated by hunger (first condition)
    # OR
    # b) all food removed from grid space
    while (np.any(world.stored_energy_map) and np.any(world.food_map)):
        count += 1
        print("count", count)

        trophallaxis_count_explore = 0
        trophallaxis_count_store = 0
        food_cells_depleted_count = 0
        forage_success_count_explore = 0
        forage_success_count_store = 0
        forage_success_dont_stop_count = 0
        forage_unsuccessful_count = 0
        transition_to_store_count = 0
        transition_to_explore_count = 0

        # data to log
        bots_alive_before_move = len(np.where(world.stored_energy_map)[0])
        _food_cells = np.copy(
            len(np.where(np.ma.make_mask(world.food_map) * 1)[0]))

        nbots_walk_search = len(np.where(
            (np.ma.make_mask(world.store_mode_map) * 1 > 0)
            & (np.ma.make_mask(world.bot_move_map) * 1 > 0)
            )[0])
        nbots_walk_explore = len(np.where(
            (np.ma.make_mask(world.explore_mode_map) > 0)
            )[0])
        nbots_stop_on_food = len(np.where(
            (np.ma.make_mask(world.bot_map) * 1 > 0)
            & (np.ma.make_mask(world.food_map) * 1 > 0)
            & (np.ma.make_mask(world.bot_move_map) * 1 < 1)
            )[0])

        nbots_stop_off_food = len(np.where(
            (np.ma.make_mask(world.bot_map) * 1 > 0)
            & (np.ma.make_mask(world.food_map) * 1 < 1)
            & (np.ma.make_mask(world.bot_move_map) * 1 < 1)
            )[0])

        world.feed()
        world.base_metabolism()
        incapacitated_bots = world.transition_bots()
        functioning_bots = np.copy(world.bot_map)
        functioning_bots[incapacitated_bots] = None
        functioning_bots = np.argwhere(functioning_bots)

        # evaluate the current location of functioning bots in terms of food and
        # neighbouring bots
        if functioning_bots.any():

            for functioning_bot in functioning_bots:

                bot = world.bot_map[functioning_bot[0], functioning_bot[1]]
                location = bot.location
                neighbours = bot.sense(np.ma.make_mask(world.bot_map) * 1,
                                   "neighbouring_bot")

                # if no neighbours
                if neighbours == []:
                    # # ... and no local energy
                    # if not world.food_map[location[::-1]]:
                    # ... and no local energy and not in a relay chain
                    if not world.food_map[location[::-1]]:
                        print("no food and not in relay chain, random step")
                        world.setup_for_move("random_step",
                                             location, None,
                                             np.clip(world.stored_energy_map[
                                                         location[::-1]],
                                                     0, float("inf")))

                # neighbours
                else:
                    #print(location)
                    world.bot_map[location[::-1]].evaluate_neighbours(
                        world,
                        location,
                        neighbours)

                # TODO: remove step to explore if head severed
                #if( bot.new_location_generator == "step_to_explore"):

                if (bot.relay_chain and bot.relay_chain.chain_map[
                                    location[::-1]] == 1):

                    print("telling relay chain to explore")
                    world.setup_for_move("step_to_explore",
                                         location,
                                         bot.relay_chain.heading)

            # identify any relay chains that have formed
            if RelayChain.relay_chains:
                RelayChain.all_relay_bots = np.zeros_like(world.bot_map)
                for relay_chain in RelayChain.relay_chains:
                    RelayChain.all_relay_bots += np.ma.make_mask(
                        relay_chain.chain_map) * 1

            if plot_output:
                world.plot(0)

            relay_bot_count = 0
            for relaychain in RelayChain.relay_chains:
                _count  = len(np.where(relaychain.chain_map)[0])
                relay_bot_count += _count

            chain_bot_count = 0
            for relaychain in Chain.chains:
                _count = len(np.where(relaychain.chain_map)[0])
                chain_bot_count += _count

            # data to log
            bots_alive_before_move = len(np.where(world.stored_energy_map)[0])

            if np.any(world.bot_move_map):
                bots_on_food_leaving = len(
                    np.where(
                        np.multiply(np.ma.make_mask(
                            world.food_map) * 1,
                                    np.ma.make_mask(
                                        world.bot_map) * 1,
                                            np.ma.make_mask(
                                                world.bot_move_map) * 1))[0])

                # transition any bots changing state
                world.transition_bots()

            else:
                bots_on_food_leaving= 0

            bots_on_food_remain = len(
                np.where(
                    np.multiply(np.ma.make_mask(
                        world.food_map) * 1,
                                np.ma.make_mask(
                                    world.bot_map) * 1)
                                        - np.ma.make_mask(
                                            world.bot_move_map) * 1)[0])

            #move all the bots
            world.old_bot_map = np.copy(world.bot_map)

            world.before_move_x = []
            world.before_move_y = []
            world.after_move_x = []
            world.after_move_y = []

            print("move these bots", world.bot_map[np.where(world.bot_move_map)])

            #print("MOVE BOTS")
            while world.bot_move_map.any():
                y, x = np.nonzero(world.bot_move_map)

                for Y, X in zip(y,x):
                    # temporary fix, if statement checks bot has been displaced
                    # from its original location on map of bots to move before
                    # attempting to move it.
                    # if world.bot_map[Y,X]:
                    if world.bot_move_map[Y, X]:
                        location = Location(X,Y)
                        world.bot_map[location[::-1]].move(world, location)

            if plot_output:
                world.plot(1)
                if show_plot:
                    plt.show()

        world.save_data_per_timestep(bots_alive_before_move,
                                     bots_on_food_leaving,
                                     bots_on_food_remain,
                                     _food_cells,
                                     nbots_walk_search,
                                     nbots_walk_explore,
                                     nbots_stop_on_food,
                                     nbots_stop_off_food)


    # save final data
    world.save_data_final()
    #world.plot_data_per_time_step(bots_alive_before_move)
    #world.plot_data_per_time_step()

    print("seed np:", seed_np)
    print("seed random:", seed_random)
    print("count:", count)
    print("--- %s seconds ---" % (time.time() - start_time))



if __name__ == '__main__':
    try:
        main()
    finally:

        print("seed np:", seed_np)
        print("seed random:", seed_random)
        print("count:", count)
        #print("--- %s seconds ---" % (time.time() - start_time))
