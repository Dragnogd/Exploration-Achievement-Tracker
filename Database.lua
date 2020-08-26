local _, core = ...
local L = core.L
local instances = {}

core.Database = {
	--Eastern Kingdom
	[2] = {
        [37] = { --Elwynn Forest
            name = 37,
            achievement1 = {
                achievement = 776,
                tactics = "Hello World",
                enabled = true,
                track = function() core._37:ExploreElwynnForest() end,
            },
        },
        [49] = { --Redridge Mountains
            name = 49,
            achievement1 = {
                achievement = 780,
                tactics = "Hello World 2",
                enabled = true,
                track = function() core._49:ExploreRedridgeMountains() end,
            },
        },
        [52] = { --Redridge Mountains
            name = 52,
            achievement1 = {
                achievement = 802,
                tactics = "Hello World 2",
                enabled = true,
                track = function() core._52:ExploreWestfall() end,
            },
        },
        [47] = { --Duskwood
            name = 47,
            achievement1 = {
                achievement = 778,
                tactics = "Hello World 2",
                enabled = true,
                track = function() core._47:ExploreDuskwood() end,
            },
        },
    },
    [3] = {
        [1] = { --Elwynn Forest
            name = 1,
            achievement1 = {
                achievement = 14023,
                tactics = "Hello World",
                track = function() core._2291:DealerXyexa() end,
            },
        },
        [2] = { --Westfall
            name = 2,
            achievement2 = {
                achievement = 14023,
                tactics = "Hello World",
                track = function() core._2291:DealerXyexa() end,
            },
        },
    },
    [4] = {
        [1] = { --Elwynn Forest
            name = 1,
            achievement1 = {
                achievement = 14023,
                tactics = "Hello World",
                track = function() core._2291:DealerXyexa() end,
            },
        },
        [2] = { --Westfall
            name = 2,
            achievement2 = {
                achievement = 14023,
                tactics = "Hello World",
                track = function() core._2291:DealerXyexa() end,
            },
        },
    },
    [5] = {
        [1] = { --Elwynn Forest
            name = 1,
            achievement1 = {
                achievement = 14023,
                tactics = "Hello World",
                track = function() core._2291:DealerXyexa() end,
            },
        },
        [2] = { --Westfall
            name = 2,
            achievement2 = {
                achievement = 14023,
                tactics = "Hello World",
                track = function() core._2291:DealerXyexa() end,
            },
        },
    },
    [6] = {
        [1] = { --Elwynn Forest
            name = 1,
            achievement1 = {
                achievement = 14023,
                tactics = "Hello World",
                track = function() core._2291:DealerXyexa() end,
            },
        },
        [2] = { --Westfall
            name = 2,
            achievement2 = {
                achievement = 14023,
                tactics = "Hello World",
                track = function() core._2291:DealerXyexa() end,
            },
        },
    },
    [7] = {
        [1] = { --Elwynn Forest
            name = 1,
            achievement1 = {
                achievement = 14023,
                tactics = "Hello World",
                track = function() core._2291:DealerXyexa() end,
            },
        },
        [2] = { --Westfall
            name = 2,
            achievement2 = {
                achievement = 14023,
                tactics = "Hello World",
                track = function() core._2291:DealerXyexa() end,
            },
        },
    },
    [8] = {
        [1] = { --Elwynn Forest
            name = 1,
            achievement1 = {
                achievement = 14023,
                tactics = "Hello World",
                track = function() core._2291:DealerXyexa() end,
            },
        },
        [2] = { --Westfall
            name = 2,
            achievement2 = {
                achievement = 14023,
                tactics = "Hello World",
                track = function() core._2291:DealerXyexa() end,
            },
        },
    },
    [9] = {
        [1] = { --Elwynn Forest
            name = 1,
            achievement1 = {
                achievement = 14023,
                tactics = "Hello World",
                track = function() core._2291:DealerXyexa() end,
            },
        },
        [2] = { --Westfall
            name = 2,
            achievement2 = {
                achievement = 14023,
                tactics = "Hello World",
                track = function() core._2291:DealerXyexa() end,
            },
        },
    },
    [10] = {
        [1] = { --Elwynn Forest
            name = 1,
            achievement1 = {
                achievement = 14023,
                tactics = "Hello World",
                track = function() core._2291:DealerXyexa() end,
            },
        },
        [2] = { --Westfall
            name = 2,
            achievement2 = {
                achievement = 14023,
                tactics = "Hello World",
                track = function() core._2291:DealerXyexa() end,
            },
        },
    },
    [11] = {
        [1] = { --Elwynn Forest
            name = 1,
            achievement1 = {
                achievement = 14023,
                tactics = "Hello World",
                track = function() core._2291:DealerXyexa() end,
            },
        },
        [2] = { --Westfall
            name = 2,
            achievement2 = {
                achievement = 14023,
                tactics = "Hello World",
                track = function() core._2291:DealerXyexa() end,
            },
        },
    },
}