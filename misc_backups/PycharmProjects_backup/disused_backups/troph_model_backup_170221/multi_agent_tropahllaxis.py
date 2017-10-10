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

# class Value:
#     """
#     Creates a Value that updates all instances as it changes.
#
#      Examples
#     --------
#     >>> v1 = Value(1)
#     >>> v2 = Value(2)
#
#     >>> d = {'a': v1, 'b': v1, 'c': v2, 'd': v2}
#     >>> d['a'].v += 1
#
#     >>> d['b'].v == 2 # True
#
#     References
#     ----------
#     .. [#] dictionary with multiple keys to one value. StackOverflow.
#        http://stackoverflow.com/questions/10123853/how-do-i-make-a-dictionary-with-multiple-keys-to-one-value
#
#
#     """
#     def __init__(self, v=None):
#         self.v = v

class slicee:
    """
       Creates an array of start and stop value pairs (with optional step
       values)

        Examples
       --------
       >>> slicee()[0, 1:2, ::5, ...]
       # '(0, slice(1, 2, None), slice(None, None, 5), Ellipsis)'

       References
       ----------
       .. [#] Python's slice notation. StackOverflow.
          http://stackoverflow.com/questions/509211/explain-pythons-slice-notation


       """
    def __getitem__(self, item):
        return item

# set model parameters
n_cells = 100                   # must be square number
n_bots = 10
max_food_per_cell = 40
individual_food_cell_value = "max_food_per_cell"   # "random", "max_food_per_cell"
set_number_agents_on_food = True
n_agents_on_food = 2
use_trophallaxis = True         #  use trophallaxis mechanism
food_map_style = "new_map"      # "existing_map", "new_map"
bot_map_style = "random_map"       # "existing_map", "new_map", "random_map"                         #  "random_map"


if food_map_style == "new_map": # set dimensions of single food patch:
    y_range = slicee()[1:2, 4:6]
    x_range = slicee()[1:2, 4:6]

if food_map_style == "existing_map": # input names of previous data
    bot_map_dir = "Data.07-02-2016_00_25_05_JST"
    food_map_dir = "Data.07-02-2016_00_25_05_JST"
    bot_map_name = "Data.07-02-2016_00_25_05_JST"
    food_map_name = "Data.07-02-2016_00_25_05_JST"

plot_output = True              #  plots and saves output data
show_plot = False               #  displays data during simulation

Eremoved_perFeed__Estored_init = 12
Eth_store__Eth_troph = 0

BOT_DEFAULTS = OrderedDict([
    ("base_metabolism", 0),
    ("Eremoved_perFeed", Eremoved_perFeed__Estored_init),
    ("Estored_init", Eremoved_perFeed__Estored_init),
    ("Ecost_perStep", 1),
    ("Eth_explore", 12),
    ("Eth_store", Eth_store__Eth_troph),
    ("Eth_troph", Eth_store__Eth_troph),
    ("Eth_battFull", 0),
    ("Estored_max", 30),
    ("senseRange", 1),
    ("troph", use_trophallaxis),
    ("trophMode", "cautious"), # "equalise", "cautious", "selfless"
    ("eff_E_conversion", 1),
    ("t_steps_to_charge", 4),
])

"""dict: Default values for bot construction."""

SENSING_TARGETS = {
    "on_food": 2,
    "not_on_food": 1,
    "neighbouring_recruits" : 1,
    "neighbouring_bot" : 1,
    "neighbouring_space": 0,
}
"""dict: Potential targets that can be sensed."""

# random seed is random choice
seed_np = np.random.randint(0, 2**32 - 1)
seed_random = np.random.randint(0, 2**32 - 1)
# or
# random seed is selected for np and random libraries
# seed_np, seed_random = (26, 300) nice example
np.random.seed(seed_np)
random.seed(seed_random)

# setup output data files
dateStr = time.strftime('%Y-%m-%d')
timeStr = time.strftime('%Y-%m-%d_%H_%M_%S')
dirname = "output_data/" + dateStr
if use_trophallaxis == True:
    troph = "_troph"
else:
    troph = ""
subdirname = timeStr + troph
os.makedirs(dirname + "/"+ subdirname + "/figures")
dataTimestep = dirname + "/"+ subdirname + "/" + subdirname + '_dataTimestep.csv'
dataSummary = dirname + "/"+ subdirname + "/" + subdirname + '_dataSummary.csv'

data_per_timestep = ["count",
                     "total_food",
                     "food_patches",
                     "bots_with_Estored",
                     "area_covered",
                     "total_steps_taken",
                    ]

start_time = time.time()

count = 0
step_count = 0
plot_number = 1

Location = namedtuple("Location", ("x", "y"))

class Food(object):
    """
    Maps the distribution of food over the grid space.

    Parameters
    ----------
    food_map_style :
        The name of the methid used to construct the food map.
    n_cells : int
       The number of cells with individual values that the food map is
       discretised into.
    max_food_per_cell : int
       The maximum value of a food cell.

    Attributes
    ----------
    n_cells : int
       The number of cells with individual values that the food map is
       discretised into.
    map_size : int
        The length of each side of the food map in grid cells.
    max_food_per_cell : int
       The maximum value of a food cell.
    food_map : array
       The distribution of food across the grid space, food cell discretisation.

    """
    def __init__(self):

        self.food_map_style = food_map_style
        self.n_cells = n_cells
        self.map_size = int(np.sqrt(self.n_cells))
        self.max_food_per_cell = max_food_per_cell
        self.food_map = np.zeros(self.n_cells)

        print("food_setup")

        if food_map_style == "existing_map":

            self.food_map = np.load(food_map_dir + "/" + food_map_name
                                    + "/" + food_map_name + "_food.npy")
            food_map_name = dirname + "/"+ subdirname + "/" + food_map_name

        if food_map_style == "new_map":

            self._new_map()

            food_map_name = dirname + "/" + subdirname + "/" + subdirname

        np.save(food_map_name + "_food", self.food_map)
        self.total_food_initial = np.sum(self.food_map)
        self.total_food_cells_initial = len(np.argwhere(self.food_map))

        plt.matshow(self.food_map)
        plt.show()
        print(self.food_map)


    def _new_map(self):
        self.food_map = np.reshape(self.food_map,
                                   (self.map_size, self.map_size))

        for y, x in zip(y_range, x_range):
            self.food_map[y, x] = 1

        # food on each cell
        y, x = np.nonzero(self.food_map)
        for X, Y in zip(x, y):

            if individual_food_cell_value == "max_food_per_cell":
                self.food_map[X, Y] = self.max_food_per_cell

            if individual_food_cell_value == "random":
            #set limits
                food_cell_values = range(BOT_DEFAULTS['Ein_perFeed'],
                                         self.max_food_per_cell + 1,
                                         BOT_DEFAULTS['Ein_perFeed'])
                self.food_map[X, Y] = random.choice(food_cell_values)

    def __repr__(self):
        return "Food({}, {}, {})".format(
            self.n_cells,
            self.map_size,
            self.max_food_per_cell,)

    def __str__(self):
        return str(self.food_map)

class Bot(object):
    """
    Robot agents that travel around the grid space, eating the food.

    Parameters
    ----------
    base_metabolism : int
        The base energy consumption per simulation step of each bot
    Eremoved_perFeed : int
        The amount of energy removed from the cell on the food map on which a
        bot is located every time athe bot feeds.
    Estored_init : float
        The amount of stored energy the bots are initialised with.
    Ecost_perStep : int
        The energy consumed by the bot for each step of size = one grid space.
    Eth_explore : int
        The stored energy threshold that prompts bots to change their task from
        storing energy to exploring.
    Eth_store : int
        The stored energy threshold that prompts bots to change their task from
        exploring to storing energy and aggregating bots around the
        source of energy.
    Eth_troph : int
        The stored energy threshold at which the bot begins sharing energy with
        others.
    Eth_battFull : int
        The stored energy threshold at which a bot stops receiving energy during
        trophallaxis.
    Estored_max : int.
        The value of stored energy above which feeding does not increase the
    senseRange, : int
        The thickness of the border around the bot location within which
        cells are considered in sensing operations.
    troph : logical
        Boolean value for whether bots feed each other or not.
    trophMode : string
        The name of the method the bot uses when feeding bots.
    eff_E_conversion : int
        The efficency (maximum = 1) with which energy removed from the food
        map is converted to stored energy.
    t_steps_to_charge : int
        The number of time steps the bot takes for the converted energy to be
        stored.

    Attributes
    ----------
    base_metabolism : int
        The base energy consumption per simulation step of each bot
    Eremoved_perFeed : int
        The amount of energy removed from the cell on the food map on which a
        bot is located every time athe bot feeds.
    Estored_init : float
        The amount of stored energy the bots are initialised with.
    Ecost_perStep : int
        The energy consumed by the bot for each step of size = one grid space.
    Eth_explore : int
        The stored energy threshold that prompts bots to change their task from
        storing energy to exploring.
    Eth_store : int
        The stored energy threshold that prompts bots to change their task from
        exploring to storing energy and aggregating bots around the
        source of energy.
    Eth_troph : int
        The stored energy threshold at which the bot begins sharing energy with
        others.
    Eth_battFull : int
        The stored energy threshold at which a bot stops receiving energy during
        trophallaxis.
    Estored_max : int.
        The value of stored energy above which feeding does not increase the
    senseRange, : int
        The thickness of the border around the bot location within which
        cells are considered in sensing operations.
    troph : logical
        Boolean value for whether bots feed each other or not.
    trophMode : string
        The name of the method the bot uses when feeding bots.
    eff_E_conversion : int
        The efficency (maximum = 1) with which energy removed from the food
        map is converted to stored energy.
    t_steps_to_charge : int
        The number of time steps the bot takes for the converted energy to be
        stored.
    E_stored : float
        The cumulative energy from feeding less the energy consumed.
    location : tuple
        The x, y coordinates of the bot location on the bot map.
    new_location_generator : string
        The name of the method the bot uses to choose a new location on the bot
        map to attempt to move to.
    new_location_generators : dictionary
        The possible new location generators used by the bot.
    target_location : tuple
        The x, y coordinates of the location on the bot map that the bot will
        attempt to move to.




    bots : list
        A list of all the bots that exist.
    sense_kernel : array
        A kernel of values used in bot operations that "sense" the cells
        surrounding the bot, with the footprint of the sensed cells equal to the
        dimensions of the kernel.

    """
    bots = []

    sense_kernel = np.zeros((2 * BOT_DEFAULTS["senseRange"]+ 1) ** 2)
    sense_kernel[(len(sense_kernel) // 2)] = 1
    kernel_size = np.sqrt(len(sense_kernel))
    sense_kernel = np.reshape(sense_kernel, (kernel_size, kernel_size))

    def __init__(self, world, *,
                 base_metabolism,
                 Eremoved_perFeed,
                 Estored_init,
                 Ecost_perStep,
                 Eth_explore,
                 Eth_store,
                 Eth_troph,
                 Eth_battFull,
                 Estored_max,
                 senseRange,
                 troph,
                 trophMode,
                 eff_E_conversion,
                 t_steps_to_charge):

        # self.sense_kernel = np.zeros((2 * BOT_DEFAULTS["senseRange"]
        #                               + 1) ** 2)
        # self.sense_kernel[(len(self.sense_kernel) // 2)] = 1
        # kernel_size = np.sqrt(len(self.sense_kernel))
        # self.sense_kernel = np.reshape(self.sense_kernel,
        #                                (kernel_size, kernel_size))

        self.base_metabolism = base_metabolism
        self.Ein_perFeed = Eremoved_perFeed
        self.Estored_init = Estored_init
        self.Ecost_perStep = Ecost_perStep
        self.Eth_explore = Eth_explore
        self.Eth_store = Eth_store
        self.Eth_troph = Eth_troph
        self.Eth_battFull = Eth_battFull
        self.Estored_max = Estored_max
        self.senseRange = senseRange
        self.troph = troph
        self.trophMode = trophMode
        self.eff_E_conversion = eff_E_conversion
        self.t_steps_to_charge = t_steps_to_charge

        self.Estored = Estored_init
        self.location = None
        self.new_location_generator = None
        self.target_location = None
        self.bots.append(self)

        self.new_location_generators = {
            "random": self.new_location_random,
        }

    def sense(self, map, sensing_target):
        """
        Checks if bot has any neighbouring bots/ spaces/ recruits
        Parameters
        ----------
        map : array
            The map whose contents are ebing sensed.
        sensing_target : string
            The item to search for.

        Returns
        -------
        list[Location]
            The location of all neighbours of the target type.

        """
        # top left hand corner of kernel = i, j
        i = self.location.y - BOT_DEFAULTS["senseRange"]
        j = self.location.x - BOT_DEFAULTS["senseRange"]
        k = np.shape(Bot.sense_kernel)[0]

        neighbours = np.argwhere(map[i:i + k, j:j + k]
                                 - Bot.sense_kernel ==
                                 SENSING_TARGETS[sensing_target])

        return [Location(x + j, y + i) for y, x in neighbours]

    def evaluate_neighbours(self, world):
        """

        Parameters
        ----------
        world : object
            The world in which the bots live

        Returns
        -------

        """
        location = self.location

        neighbours = self.sense(np.ma.make_mask(world.bot_map) * 1,
                  "neighbouring_bot")

        bot_on_food = bool((np.ma.make_mask(world.food_map) * 1)
                           [location[::-1]])

        if neighbours == []:
            neighbours = {}

        else:
            neighbours = {}

            not_on_food_map = np.ma.make_mask(world.bot_map) * 1 - \
                              np.ma.make_mask(world.food_map) * 1

            on_food_map = np.ma.make_mask(world.bot_map) * 1 + \
                          np.ma.make_mask(world.food_map) * 1


            neighbours["bot1_neighbour0"] = \
                self.sense(not_on_food_map, "on_food")


                #self.sense(not_on_food_map, "on_food")

            if bot_on_food:

                neighbours["bot1_neighbour0"] = \
                    self.sense(not_on_food_map, "not_on_food")

                neighbours["bot1_neighbour1"] = \
                    self.sense(on_food_map, "on_food")

            else:  # if food cell empty

                neighbours["bot0_neighbour0"] = \
                    self.sense(not_on_food_map,"not_on_food")

                neighbours["bot0_neighbour1"] = \
                    self.sense(on_food_map, "on_food")

        return neighbours #neighbours_food





    def new_location_random(self, location, world):
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

class World(object):
    """
    Maps the distribution of food over the grid space.

    Parameters
    ----------
    n_bots : int
        The number of bots
    _food : Food
        The food distribution across the grid space.

    Attributes
    ----------
    n_bots : int
        The number of bots
    _food : object
        The food distribution across the grid space.
    n_cells :
        The number of food cells
    map_size : int
        The length of each side of the food map.
    food_map : np.ndarray
        The distribution of food across the grid space.
    bot_map : np.ndarray
        The distribution of bots across the grid space.
    bot_map_size : int
        The length of each side of the bot map in grid units.
    _bots_on_food : int
        The number of bots located on a cell containing food
    Estored_map : np.ndarray
        The map of cumulative energy stored by each bot.
    Acovered_map : np.ndarray
        A map showing the number of times a grid cell has been entered by a bot.
    trajectory_coords : Dictionary
       Coordinates of start and end point that define robots motion vector

    """

    def __init__(self, food):
        self.n_bots = n_bots
        self._food = food
        self.n_cells = n_cells
        self.map_size = self._food.map_size
        self.food_map, self.food_map_size = self._pad_map(
            self._food.food_map, BOT_DEFAULTS['senseRange'])

        self.bot_map = None
        self.bot_map_size = None
        self._populate_bot_map()
        self._bots_on_food = None

        self.Estored_map = np.ma.make_mask(self.bot_map) \
                                     * BOT_DEFAULTS["Estored_init"]

        self.Acovered_map = np.ma.make_mask(self.bot_map) * 1

        self.charge_mode_map = np.multiply( np.ma.make_mask(self.bot_map) * 1,
                                             np.ma.make_mask(self.food_map) * 1)

        self.trajectory_coords = {"x_preMove" : None,
                                  "y_preMove" : None,
                                  "y_postMove": None,
                                  "x_postMove": None}

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
                (_full_map_size) ** 2, dtype=object).reshape(_full_map_size,
                 _full_map_size)

        else:
            _full_map = np.zeros(
                (_full_map_size) ** 2).reshape(_full_map_size,_full_map_size)

        _full_map[_border_width:(
                _border_width + self.map_size),
                _border_width:(_border_width + self.map_size)] = map_to_pad

        return _full_map, _full_map_size

    def _populate_bot_map(self):


        """
        Distributes n_bots start locations randomly over the grid space

        """


        if bot_map_style == "existing_map":
            self.bot_map = np.load(dirname + "/"+ bot_map_dir + "/"
                                   + bot_map_name + "bots.npy")
            self.bot_map_size = np.shape(self.bot_map)[0]
            bot_map_name = dirname + "/"+ subdirname + "/" + bot_map_name

        else:

            if bot_map_style == "new_map":
                pass

            # if bot_map_style == "random_half_map":
            #     self.bot_map = np.empty(self.n_cells, dtype=object)
            #     self.bot_map = np.reshape(self.bot_map,
            #                               (self.map_size, self.map_size))
            #     _bot_map = self.bot_map.ravel()
            #     for bot in range(self.n_bots):
            #         _bot_map[bot] = Bot(self, **BOT_DEFAULTS)
            #     np.random.shuffle(_bot_map[:0.5 * self.n_cells])
            #     self.bot_map = np.transpose(self.bot_map)

            if bot_map_style == "random_map":


                self._random_map()

                if set_number_agents_on_food == True:

                    while len(self._bots_on_food) != n_agents_on_food:
                        self._random_map()

            # give each bot a location identity
            y, x = np.where(self.bot_map)
            for Y, X in zip(y, x):
                self.bot_map[Y, X].location = Location(X, Y)

            bot_map_name = (dirname + "/" + subdirname +
                            "/" + subdirname)

        np.save(bot_map_name + "bots", self.bot_map)

        print(np.ma.make_mask(self.bot_map)*1)

    def _random_map(self):

        self.bot_map = np.empty(self.n_cells, dtype=object)

        for i in range(self.n_bots):
            self.bot_map[i] = Bot(self, **BOT_DEFAULTS)

        np.random.shuffle(self.bot_map)
        self.bot_map = np.reshape(self.bot_map, (self.map_size, self.map_size))  # record index of each bot on a food patch

        self.bot_map, self.bot_map_size = self._pad_map(
            self.bot_map, BOT_DEFAULTS['senseRange'])

        self._bots_on_food = np.where(
            (np.ma.make_mask(self.bot_map) * 1 > 0) &
            (self.food_map > 0))

        print(len(self._bots_on_food))

    def save_data_per_timestep(self):

        # log data to data per cycle
        with open(dataTimestep, 'a') as c:
            writer = csv.writer(c)
            writer.writerow([

                # count
                count,

                # total food
                np.sum(self.food_map),

                # number of food patches
                len(np.where(self.food_map)[0]),

                # _bots_with_Estored
                len(np.where(self.Estored_map)[0]),

                # total area covered
                len(np.where(self.Acovered_map)[0]),

                # total steps taken
                step_count,

            ])

    def save_data_init(self, food_map):

        """
        Creates a dictionary of the attributes of the World object and the
        default properties of the bots. Saves these and other global data and
        parameters of the World object to a new csv file.
        Defines heaidings of parameters to be recorded at each timestep to a new
        csv file and calculates and saves initial values.

        Parameters
        ----------
        food_map : array
            An attribute to remove from the dictionary.
        """

        attributes = food_map.__dict__
        del attributes["food_map"]
        attributes.update(BOT_DEFAULTS)

        # write data to data summary
        with open(dataSummary, 'w') as s:
            writer = csv.writer(s)
            for key, value in attributes.items():
                writer.writerow([key, value])
            writer.writerow(["n_bots", self.n_bots])
            writer.writerow(["seed np:", seed_np])
            writer.writerow(["seed random:", seed_random])

        # setup data per timestep file
        with open(dataTimestep, 'w') as c:
            writer = csv.writer(c)
            #writer.writerow(self.data_to_log)
            writer.writerow(data_per_timestep)

        self.save_data_per_timestep()

    def plot(self, plot_trajectory):

        global plot_number

        f, ax = plt.subplots()

        # plot food
        ax.matshow(self.food_map,
                   cmap='Greens',
                   vmin=0,
                   vmax=self._food.max_food_per_cell)

        # plot stored energy
        y, x = np.where(self.bot_map)
        ax.scatter(
            x, y, 70,
            c = self.Estored_map[y, x],
            cmap = "Reds",
            vmin = 0,
            # vmax=self.e_threshold_explore)
            vmax = BOT_DEFAULTS["Estored_max"])

        # vectors showing bot trajectory
        if plot_trajectory == True:
            for y_pre, x_pre, y_post, x_post in zip(
                    self.trajectory_coords["y_preMove"],
                    self.trajectory_coords["x_preMove"],
                    self.trajectory_coords["y_postMove"],
                    self.trajectory_coords["x_postMove"]
            ):
                ax.plot([x_pre, x_post], [y_pre, y_post], c='r')

        plt.ylim((0, self.bot_map_size ))
        plt.xlim((0, self.bot_map_size))

        plotname = dirname + "/" + subdirname \
                   + "/figures/" + str(plot_number).zfill(4)

        plot_number += 1

        f.savefig(plotname + '.pdf', orientation='landscape')
        f.savefig(plotname + '.png', orientation='landscape')


    def feed(self):
        """
        Decreases food map by 1 unit in every grid cell newly occupied by a bot
        Updates the bot charging map with new occupants
        Updates the stored energy map of all charging bots with the energy from
        feeding divided by the number of time steps taken to charge.
        """
        _food_consumed = BOT_DEFAULTS["Eremoved_perFeed"]

        _newcharge_bot_map = np.multiply(np.ma.make_mask(self.bot_map) * 1,
                                          np.ma.make_mask(self.food_map) * 1) \
                              - self.charge_mode_map

        self.charge_mode_map += _newcharge_bot_map

        np.clip(self.food_map - (_newcharge_bot_map * _food_consumed),
                0, float("inf"),
                self.food_map)

        #self.charge(_food_consumed)

    def charge(self, _food_consumed):
        """
        Updates the stored energy map of all charging bots with the energy from
        feeding divided by the number of time steps taken to charge.

        """
        food_consumed = _food_consumed
        eff_E_conversion = BOT_DEFAULTS["eff_E_conversion"]
        t_steps_to_charge = BOT_DEFAULTS["t_steps_to_charge"]

        # self.Estored_map = np.add(self.Estored_map,
        #                                 (self.charge_mode_map
        #                                 * eff_E_conversion
        #                                 * food_consumed
        #                                 / _t_steps_to_charge))

        # self.Estored_map = np.clip(self.Estored_map
        #                            + (_food_consumed_map * food_consumed),
        #                            0, BOT_DEFAULTS["Estored_max"],
        #                            self.Estored_map)

        self.Estored_map = np.clip(self.Estored_map
                                   + (self.charge_mode_map
                                        * eff_E_conversion
                                        * food_consumed
                                        / t_steps_to_charge),
                                   0, BOT_DEFAULTS["Estored_max"],
                                   self.Estored_map)

    def base_metabolism(self):
        """

        """
        np.clip(
            self.Estored_map - BOT_DEFAULTS["base_metabolism"],
            0, float("inf"), self.Estored_map)

    def functioning_bots(self):

        functioning_bots = []

        incapacitated_bots = self.incapacitated_bots()
        _bots = np.copy(self.bot_map)
        _bots[incapacitated_bots] = None
        _functioning_bots = np.argwhere(_bots)
        for _functioning_bot in _functioning_bots:
            bot = self.bot_map[_functioning_bot[0], _functioning_bot[1]]
            functioning_bots.append(bot)

        return functioning_bots


    def incapacitated_bots(self):
        incapacitated_bots = np.where((self.bot_map != None)
                                      and self.Estored_map == 0)
        return incapacitated_bots


#
#     def feed_hungry_neighbour(self, location_bot_feed, location_bot_receive):
#
#         """
#         Transfers stored energy from one bot to another.
#
#         Parameters
#         ----------
#         location_bot_feed : tuple
#          The x,y coordinates of the bot which is the energy donor.
#
#         location_bot_receive : tuple
#          The x,y coordinates of the bot which is the energy recipiant.
#         """
#         # TODO: include energy transfer effiency
#
#         # global trophallaxis_count_explore
#         # global trophallaxis_count_store
#
#         if self.Estored_map[location_bot_feed[::-1]] \
#                      > BOT_DEFAULTS["e_threshold_trophallaxis"]:
#
#             _e_donor = copy.copy(
#                 int(self.Estored_map[location_bot_feed[::-1]]))
#             #_e_recipiant = self.Estored_map[location_bot_receive[::-1]]
#             _e_recipiant = copy.copy(
#                 int(self.Estored_map[location_bot_receive[::-1]]))
#
#             if BOT_DEFAULTS["trophallaxis_mode"] == "equalise":
#                 if ( _e_donor - (np.average([_e_donor, _e_recipiant])) > 0):
#                     food_transferred = int(_e_donor - (
#                         np.average([_e_donor, _e_recipiant])))
#                     # if food_transferred:
#                     #     if self.explore_mode_map[location_bot_feed[::-1]]:
#                     #         trophallaxis_count_explore += 1
#                     #     else:
#                     #         trophallaxis_count_store += 1
#                 else:
#                     food_transferred = 0
#
#             if BOT_DEFAULTS["trophallaxis_mode"] == "top_up_recipiant_cautious":
#
#                 _e_desired = np.clip((BOT_DEFAULTS["e_threshold_full"] -
#                                       _e_recipiant),
#                                        0, float("inf"))
#
#                 _e_available = np.clip((_e_donor -
#                                     BOT_DEFAULTS["e_threshold_trophallaxis"]),
#                                     0, float("inf"))
#
#                 food_transferred = int(np.clip(_e_desired, 0, _e_available))
#                 # if food_transferred:
#                 #     if self.explore_mode_map[location_bot_feed[::-1]]:
#                 #         trophallaxis_count_explore += 1
#                 #     else:
#                 #         trophallaxis_count_store += 1
#         else:
#             food_transferred = 0
#
#         #print("food_transferred", food_transferred)
#
#         self.Estored_map[location_bot_feed[::-1]] -= food_transferred
#         self.Estored_map[location_bot_receive[::-1]] += food_transferred
#
#         # _e_donor = self.Estored_map[location_bot_feed[::-1]]
#         # _e_recipiant = self.Estored_map[location_bot_receive[::-1]]
#         #
#         # print("feed", location_bot_feed,  _e_donor)
#         # print("receive",location_bot_receive, _e_recipiant )
#
#         # if the bot is on the bot move map, decrease the number of steps it
#         # should take.
#         if self.bot_move_map[location_bot_feed[::-1]]:
#             self.bot_move_map[location_bot_feed[::-1]] = np.clip(
#                 (self.bot_move_map[location_bot_feed[::-1]] -
#                  int(food_transferred * BOT_DEFAULTS["e_cost_per_step"])
#                  ), 0, float("inf"))
#
#         # if bot was fed, and not by robot in chain...
#         if food_transferred:
#
#             # if ((self.bot_map[location_bot_receive[::-1]].chain == None) and
#             #     (self.bot_map[location_bot_receive[::-1]].relay_chain == None)):
#
#                 # if the bot had energy when fed, move towards the feeder
#                 # if _e_recipiant > 0:
#
#             _heading = \
#                 Location((location_bot_feed.x - location_bot_receive.x),
#                          (location_bot_feed.y - location_bot_receive.y))
#
#             self.setup_move("step_towards_feeder", location_bot_receive,
#                             _heading)
#
#                 # otherwise, if bot being fed on start-up move away from donor
#                 # else: # if _e_recipiant == 0
#                 #
#                 #     # if (self.bot_map[location_bot_feed[::-1]].relay_chain or
#                 #     #     self.bot_map[location_bot_feed[::-1]].chain or
#                 #     #     self.food_map[location_bot_feed[::-1]]):
#                 #
#                 #     _heading = \
#                 #         Location((location_bot_receive.x - location_bot_feed.x),
#                 #                  (location_bot_receive.y - location_bot_feed.y))
#                 #
#                 #     print("move away from feeder")
#                 #     self.setup_move("step_towards_feeder",
#                 #                         location_bot_receive,
#                 #                         _heading)
#                     # else:
#                     #
#                     #     _heading = \
#                     #         Location((location_bot_feed.x - location_bot_receive.x),
#                     #                  (location_bot_feed.y - location_bot_receive.y))
#                     #
#                     #     self.setup_move("step_towards_feeder",
#                     #                         location_bot_receive,
#                     #                         _heading)
#
#                     # self.setup_move("new_location_random",
#                     #                     location_bot_receive,
#                     #                     None,
#                     #                     np.clip(self.Estored_map[
#                     #                     location_bot_receive[::-1]],
#                     #                     0, float("inf")))
#
#     def setup_move(self, new_location_generator,
#                    location, target_location,
#                    units_moved = 1):
#
#         print("location1", location)
#         print("target location1", target_location)
#
#         if (location and target_location
#             and (int(location.x) == int(target_location.x))
#             and (int(location.y) == int(target_location.y))):
#
#                 print("already at target loc.", location)
#                 pass
#
#         else:
#
#             self.bot_map[location[::-1]]. \
#                 new_location_generator = new_location_generator
#
#             self.bot_move_map[location[::-1]] = units_moved
#
#             if (self.bot_map[location[::-1]].
#                 new_location_generator == "new_location_towards_neighbour" or
#                 self.bot_map[location[::-1]].
#                     new_location_generator == "new_location_towards_signal"):
#
#                 # # if there is energy to move
#                 # if self.Estored_map[location[::-1]]:
#
#                 self.bot_map[location[::-1]].target_location = target_location
#
#             # elif self.bot_map[location[::-1]]. \
#             #     new_location_generator == "step_to_explore":
#
#             elif (self.bot_map[location[::-1]].
#                   new_location_generator == "step_to_explore" or
#                                   self.bot_map[location[::-1]].
#                   new_location_generator == "step_towards_feeder"):
#
#                 self.bot_map[location[::-1]].target_location = \
#                 Location(location.x + target_location.x,
#                          location.y + target_location.y)
#
#
#
#     # def attempt_connect_neighbours(self, location, equal_neighbour):
#     #     #print("attempting connnection")
#     #
#     #     def connect_chains(_chain, _other_chain, max_to_add):
#     #         _chain.chain_map = _chain.chain_map + _other_chain.chain_map
#     #
#     #         for Y, X in zip(y, x):
#     #             _chain.chain_map[Y, X] += max_to_add
#     #
#     #         #_chain.connected_bots += _other_chain.connected_bots
#     #         #print("_chain.connected_bots", _chain.connected_bots)
#     #         _chain.connected_bots.extend(_other_chain.connected_bots[:])
#     #         #print("_chain.connected_bots", _chain.connected_bots)
#     #         # for bot in _other_chain.connected_bots:
#     #         for bot in _chain.connected_bots:
#     #             bot.chain = _chain
#     #             #print(bot)
#     #             #print(bot.chain)
#     #
#     #         _other_chain.chain_map = []
#     #         #print("remaining chains")
#     #         Chain.chains.remove(_other_chain)
#     #
#     #         #_other_chain.dissolve_chain() - THIS RESETS ALL NEW CHAIN MEMBERS' bot.chain value to 0
#     #         # Chain.chains.remove(_other_chain)
#     #         # print("connected chain to chain", _chain)
#     #
#     #     # case 1: two single bots
#     #     if not self.bot_map[location[::-1]].chain \
#     #             and not self.bot_map[equal_neighbour[::-1]].chain:
#     #         #print("case 1: two single bots")
#     #         #print("connected single bots", self.bot_map[location[::-1]].chain)
#     #         Chain(self.food_map, [self.bot_map[location[::-1]],
#     #                               self.bot_map[equal_neighbour[::-1]]])
#     #
#     #     # case 2: connect single bot to bot in chain
#     #     elif bool(self.bot_map[location[::-1]].chain) != \
#     #             bool(self.bot_map[equal_neighbour[::-1]].chain):
#     #         #print("case 2: connect single bot to bot in chain")
#     #
#     #         if self.bot_map[location[::-1]].chain:
#     #             _chain = self.bot_map[location[::-1]].chain
#     #             _bot = location
#     #             _other_bot = equal_neighbour
#     #
#     #         else:
#     #             _chain = self.bot_map[equal_neighbour[::-1]].chain
#     #             _bot = equal_neighbour
#     #             _other_bot = location
#     #
#     #         # connect to min of chain
#     #         if _chain.chain_map[_bot[::-1]] == \
#     #                 np.min(_chain.chain_map[np.nonzero(_chain.chain_map)]):
#     #             y, x = np.nonzero(_chain.chain_map)
#     #             _chain.chain_map[y, x] += 1
#     #             # add new bot at min of chain
#     #             _chain.chain_map[_other_bot[::-1]] = 1
#     #             _chain.connected_bots.append(self.bot_map[_other_bot[::-1]])
#     #             self.bot_map[_other_bot[::-1]].chain = _chain
#     #
#     #         # connect to max of chain
#     #         if _chain.chain_map[_bot[::-1]] == \
#     #                 np.max(_chain.chain_map[np.nonzero(_chain.chain_map)]):
#     #             # add new bot at max of chain
#     #             _chain.chain_map[_other_bot[::-1]] = \
#     #                 np.max(_chain.chain_map[np.nonzero(_chain.chain_map)]) + 1
#     #             _chain.connected_bots.append(self.bot_map[_other_bot[::-1]])
#     #             self.bot_map[_other_bot[::-1]].chain = _chain
#     #             #print("connected single to chain")
#     #
#     #     # case 3: both bots in chains
#     #     # TODO: simpler decision matrix
#     #     elif self.bot_map[location[::-1]].chain \
#     #             and self.bot_map[equal_neighbour[::-1]].chain:
#     #         # and it is not the same chain
#     #         if (self.bot_map[location[::-1]].chain.connected_bots !=
#     #                 self.bot_map[equal_neighbour[::-1]].chain.connected_bots):
#     #
#     #             #print("case 3: both bots in different chains")
#     #
#     #             _bot = location
#     #             _other_bot = equal_neighbour
#     #             _chain = self.bot_map[location[::-1]].chain
#     #             _other_chain = self.bot_map[equal_neighbour[::-1]].chain
#     #
#     #             # min of chain to max of other chain
#     #             if (_chain.chain_map[_bot[::-1]] == np.min(_chain.chain_map
#     #                                                        [np.nonzero(
#     #                     _chain.chain_map)])
#     #                 and _other_chain.chain_map
#     #                 [_other_bot[::-1]]
#     #                     == np.max(_other_chain.chain_map
#     #                               [np.nonzero(
#     #                             _other_chain.chain_map)])):
#     #                 y, x = np.nonzero(_chain.chain_map)
#     #                 max_to_add = np.max(_other_chain.chain_map
#     #                                     [np.nonzero(_other_chain.chain_map)])
#     #                 connect_chains(_chain, _other_chain, max_to_add)
#     #
#     #                 # print("min of chain to max of other chain", _chain)
#     #
#     #             # max of chain to min of other chain
#     #
#     #             if (_chain.chain_map[_bot[::-1]] == np.max(_chain.chain_map
#     #                                                        [np.nonzero(
#     #                     _chain.chain_map)])
#     #                 and _other_chain.chain_map[
#     #                     _other_bot[::-1]]
#     #                     == np.min(_other_chain.chain_map[np.nonzero(
#     #                         _other_chain.chain_map)])):
#     #                 # print("max of chain to min of other chain")
#     #
#     #                 y, x = np.nonzero(_other_chain.chain_map)
#     #                 max_to_add = np.max(_chain.chain_map[np.nonzero(
#     #                     _chain.chain_map)])
#     #                 connect_chains(_chain, _other_chain, max_to_add)
#     #
#     #             # min of chain to min of other chain
#     #
#     #             if (_chain.chain_map[_bot[::-1]] ==
#     #                     np.min(_chain.chain_map[np.nonzero(
#     #                         _chain.chain_map)])
#     #                 and
#     #                         _other_chain.chain_map[_other_bot[::-1]] ==
#     #                         np.min(_chain.chain_map[np.nonzero(
#     #                             _chain.chain_map)])):
#     #
#     #                 # print("min of chain to min of other chain")
#     #
#     #                 y, x = np.nonzero(_other_chain.chain_map)
#     #
#     #                 max_to_add = np.max(_other_chain.chain_map[np.nonzero(
#     #                     _other_chain.chain_map)])
#     #
#     #                 # reverse order of other_chain
#     #                 for Y, X in zip(y, x):
#     #                     _other_chain.chain_map[Y, X] = max_to_add + 1 - \
#     #                                                    _other_chain.chain_map[
#     #                                                        Y, X]
#     #
#     #                 y, x = np.nonzero(_chain.chain_map)
#     #                 connect_chains(_chain, _other_chain, max_to_add)
#     #
#     #             # max of chain to max of other chain
#     #
#     #             if _chain.chain_map[_bot[::-1]] == \
#     #                     np.max(_chain.chain_map
#     #                            [np.nonzero(_chain.chain_map)]) \
#     #                     and \
#     #                             _other_chain.chain_map[
#     #                                 _other_bot[::-1]] == np.max(
#     #                         _other_chain.chain_map[np.nonzero(
#     #                             _other_chain.chain_map)]):
#     #
#     #                 # print("max of chain to max of other chain")
#     #
#     #                 y, x = np.nonzero(_other_chain.chain_map)
#     #
#     #                 max_to_add = np.max(_other_chain.chain_map
#     #                                     [np.nonzero(
#     #                         _other_chain.chain_map)])
#     #
#     #                 # reverse order of other_chain
#     #                 for Y, X in zip(y, x):
#     #                     _other_chain.chain_map[Y, X] = max_to_add + 1 - \
#     #                                                    _other_chain.chain_map[
#     #                                                        Y, X]
#     #
#     #                 y, x = np.nonzero(_chain.chain_map)
#     #                 connect_chains(_chain, _other_chain, max_to_add)
#

#
#     def save_data_init(self, food_map):
#
#         attributes = food_map.__dict__
#         del attributes["food_map"]
#         attributes.update(BOT_DEFAULTS)
#
#         # write data to data summary
#         with open(data_summary, 'w') as s:
#             writer = csv.writer(s)
#             for key, value in attributes.items():
#                 writer.writerow([key, value])
#             writer.writerow(["n_bots", self.n_bots])
#             writer.writerow(["seed np:", seed_np])
#             writer.writerow(["seed random:", seed_random])
#
#         # self.data_to_log = ["count", "bots_alive",
#         #                   "bots_on_food_left", "bots_on_food_right",
#         #                   "total_food_on_left", "total_food_on_right",
#         #                   "food_patches", "total_food",
#         #                   "bots_in_chain", "bots_in_relay_chain"]
#
#         # count
#         # bots alive before / after move
#         # total food n_cells
#         # total food
#         # bots on food before move that do not move (stop on food) bots on food not on move map
#         # bots on food before move that do move (walk explore) bots on food not on move map OR transitioning explore bots
#         # explore bots that moved in last run tht end up not on food (stop not on food)
#         # explore bots that moved in last run tht end up not on food (stop not on food)
#         # fed bots
#         # occupied food cells depleted
#         # fed bots + occupied food cells depleted
#
#         self.data_to_log = ["count", "total_food", "food_patches",
#                             "_bots_with_Estored", "bots_alive_after_move",
#                             #"bots_on_food_move", "bots_on_food_no_move",
#                             "troph_by_storers", "troph_by_explorers",
#                             "success_forage_storers",
#                             "success_forage_explorers",
#                             "successful_forage_dont_stop",
#                             "unsuccessful_foragers",
#                             "depleted_food_cells",
#                             #"moved_to_food", "moved_to_empty",
#                             "area_covered",
#                             "nbots_walk_search", "nbots_walk_explore",
#                             "nbots_stop_on_food", "nbots_stop_off_food",
#                             "transition_to_store_count",
#                             "transition_to_explore_count",
#                             # "bots_in_chain", "bots_in_relay_chain"
#                             ]
#
#         with open(data_per_timestep, 'w') as c:
#             writer = csv.writer(c)
#             writer.writerow(self.data_to_log)
#
#         _bots_with_Estored = len(np.where(self.Estored_map)[0])
#
#         _food_cells = np.copy(
#             len(np.where(np.ma.make_mask(self.food_map) * 1)[0]))
#
#
#         nbots_walk_search = len(np.where(
#                                 (np.ma.make_mask(self.store_mode_map) * 1 > 0)
#                                 & (np.ma.make_mask(self.bot_move_map) * 1 < 1)
#                                 )[0])
#         nbots_walk_explore = len(np.where(
#                                 (np.ma.make_mask(self.explore_mode_map) > 0)
#                                 )[0])
#         nbots_stop_on_food = len(np.where(
#                                 (np.ma.make_mask(self.bot_map) * 1 > 0)
#                                 & (np.ma.make_mask(self.food_map) * 1 > 0)
#                                 & (np.ma.make_mask(self.bot_move_map) * 1 < 1)
#                                 )[0])
#
#         nbots_stop_off_food = len(np.where(
#                                 (np.ma.make_mask(self.bot_map) * 1 > 0)
#                                 & (np.ma.make_mask(self.food_map) * 1 < 1)
#                                 & (np.ma.make_mask(self.bot_move_map) * 1 < 1)
#                                 )[0])
#
#         self.save_data_per_timestep(_bots_with_Estored,
#                                     # 0,
#                                     # 0,
#                                     _food_cells,
#                                      nbots_walk_search,
#                                      nbots_walk_explore,
#                                      nbots_stop_on_food,
#                                      nbots_stop_off_food)
#

#
#     def save_data_final(self):
#
#         if np.any(self.Estored_map):
#             s = csv.writer(open(data_summary, 'a'))
#             s.writerow(["area_covered",
#                         len(np.argwhere(self.area_covered_map))])
#             s.writerow(["count", count])
#             s.writerow(["all food eaten"])
#             s.writerow(
#                 ["bots_still_alive", len(np.argwhere(self.Estored_map))])
#             print("all food eaten")
#
#         elif np.any(self.food_map):
#             s = csv.writer(open(data_summary, 'a'))
#             s.writerow(["area_covered",
#                         len(np.argwhere(self.area_covered_map))])
#             s.writerow(["count", count])
#             s.writerow(["all_bots_dead"])
#             s.writerow(
#                 ["total_food_end", np.sum(self.food_map)])
#             s.writerow(
#                 ["n_food_cells_end", len(np.argwhere(self.food_map))])
#             print("all bots dead")
#
#     def plot_data_per_time_step(self):
#
#         data = np.genfromtxt(data_per_timestep, delimiter=',',
#                              skip_header=2, skip_footer=0,
#                              names= self.data_to_log)
#
#         fig, ax1 = plt.subplots()
#         ax2 = ax1.twinx()
#
#         lns1 = ax2.plot(data['count'], data['bots_alive'], marker='o',
#                         linestyle='-', color='k', label='Robots alive')
#         lns3 = ax2.plot(data['count'], data['bots_on_food_left'], marker='.',
#                         linestyle='-', color='k', label='Robots on food, left')
#         lns5 = ax2.plot(data['count'], data['bots_on_food_right'], marker='^',
#                         linestyle='-', color='k', label='Robots on food, right')
#         lns7 = ax1.plot(data['count'], data['total_food'], marker='x',
#                         linestyle='-', color='k', label='Total Food Remaining')
#
#         lns = lns1 + lns3 + lns5 + lns7
#         labels = [l.get_label() for l in lns]
#         ax1.legend(lns, labels, loc=0, frameon=False)
#         ax1.set_xlabel('Cycles')
#         ax1.set_ylabel('Total Food Units')
#         ax2.set_ylabel('Number of Robots')
#
#         plotname = dirname + "/"+ subdirname + "/" \
#                     + subdirname + '_per_timestep'
#
#        fig.savefig(plotname + '.pdf', orientation='landscape')



def main():

    global count

    food_map = Food()

    # # populate world with agents
    world = World(food_map)

    world.save_data_init(food_map)

    if plot_output:
        world.plot(False)

    # loop until all bots incapacitated by hunger OR all food removed
    while (np.any(world.Estored_map) and np.any(world.food_map)):
        count += 1
        print (count)

        # energy in
        world.feed()

        # energy out
        world.base_metabolism()

        functioning_bots = world.functioning_bots()

        if functioning_bots != []:

            random.shuffle(functioning_bots)

            for bot in functioning_bots:

                #world.state_transition()

                neighbours = bot.sense(np.ma.make_mask(world.bot_map) * 1,
                                       "neighbouring_bot")

                # TODO: better name
                neighbours = bot.evaluate_neighbours(world)

                # if no neighbours
                if bool(neighbours) == False:
                    pass
                    #print("neighbours" , neighbours)
                # if neighbours
                else:
                    pass
                    #print("neighbours" , neighbours)
                    # if bool(neighbours["bot1_neightbour_1"] != []:
                    #     do something



            # if neighbours_less_food:
            #     for neighbour in neighbours_less_food:
            #         if BOT_DEFAULTS["trophallaxis"] == True:
            #             world.feed_hungry_neighbour(location, neighbour)

            # if neighbours_same_food_none:
            #     if world.explore_mode_map[location[::-1]]:
            #         for neighbour in neighbours_same_food_none:
            #             print("hungry explorer:try to feed hungry neighbour")

            #         if BOT_DEFAULTS["trophallaxis"] == True:
            #             world.feed_hungry_neighbour(location, neighbour)
            #
            # else:
            #     print(
            #         " store bot neighbour has same food (empty): random walk",
            #         location)
            #     world.setup_move("new_location_random",
            #                      location, None,
            #                      np.clip(world.stored_energy_map[
            #                                  location[::-1]],
            #                              0, float("inf")))

            # note: random walk command comes first so that it is overidden by
            # command to move to fed nieghbour if neighbours are available

            # if neighbours_more_food:
            #     neighbour = random.choice(neighbours_more_food)
            #
            #     # # if bot is not explorer
            #     if not world.explore_mode_map[location[::-1]]:
            #         if world.stored_energy_map[location[::-1]]:
            #             world.setup_move("new_location_towards_neighbour",
            #                              location, neighbour)




                # bot = world.bot_map[functioning_bot[0], functioning_bot[1]]
                # location = bot.location
                # neighbours = bot.sense(np.ma.make_mask(world.bot_map) * 1,
                #                        "neighbouring_bot")



if __name__ == '__main__':
    try:
        main()
    finally:
        print("end")
        #print("count:", count)
