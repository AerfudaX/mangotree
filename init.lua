local modname = "mangotree"
local modpath = minetest.get_modpath(modname)
local mg_name = minetest.get_mapgen_setting("mg_name")
local S = minetest.get_translator(minetest.get_current_modname())

minetest.register_decoration({
	name = "mangotree:wildmango",
	deco_type = "schematic",
	place_on = {"default:dirt_with_grass"},
	sidelen = 16,
	noise_params = {
		offset = 0.001,
		scale = 0.002,
		spread = {x = 250, y = 250, z = 250},
		seed = 3462,
		octaves = 3,
		persist = 0.66
	},
	biomes = {"deciduous_forest"},
	y_min = 1,
	y_max = 20,
	schematic = modpath.."/schematics/wildmango.mts",
	flags = "place_center_x, place_center_z, force_placement",
	rotation = "random",
})

minetest.register_node("mangotree:mangoleaves",{
    description = S("Mango Leaves"),
	drawtype = "plantlike",
	inventory_image = "MangoLeaves.png",
	tiles = {"MangoLeaves.png"},
	paramtype = "light",
	visual_scale = 1.35,
	waving = 1,
    sunlight_propagates = true,
    walkable = false,
	drop = {
		max_items = 1,
		items = {
			{items = {"mangotree:mangosapling"}, rarity = 20},
			{items = {"mangotree:mangoleaves"}},
		}
	},
	groups = {snappy=3, leafdecay=3, leaves=1, flammable=2},
})

local function grow_new_mangotree(pos)
if not default.can_grow(pos) then

		minetest.get_node_timer(pos):start(math.random(240,600))
		return
	end
	minetest.remove_node(pos)
	minetest.place_schematic({x = pos.x-3, y = pos.y, z = pos.z-3}, modpath.."/schematics/mangotree.mts", "0", nil, false)
end

if minetest.get_modpath("bonemeal") ~= nil then
    bonemeal:add_sapling({
	     {"mangotree:mangosapling", grow_new_mangotree, "default:dirt_with_grass"},
	})
end

minetest.register_node("mangotree:mangosapling", {
    description = S("Mango Tree Sapling"),
    drawtype = "plantlike",
    tiles = {"Mangosapling.png"},
    inventory_image = "Mangosapling.png",
    wield_image = "Mangosapling.png",
    paramtype = "light",
    sunlight_propagates = true,
    walkable = false,
	visual_scale = 1.15,
    on_timer = grow_new_mangotree,
	selection_box = {
	   type = "fixed",
	   fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 7 / 16, 4 / 16},
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
       	attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(2400,4800))
	end,
	
	on_place = function(itemstack, placer, pointed_thing)
		itemstack = default.sapling_on_place(itemstack, placer, pointed_thing,
			"mangotree:mangosapling",
			{x = -1, y = 1, z = -1},
			{x = 1, y = 0, z = 1},
			4)

		return itemstack
	end,
})

minetest.register_node("mangotree:ripenmango", {
    description = S("Mango Fruit"),
	drawtype = "plantlike",
	tiles = {"Mango.png"},
    inventory_image = "Mango.png",
    wield_image = "Mango.png",
	paramtype = "light",
	sunlight_propagates = true,
    walkable = false,
	selection_box = {
	   type = "fixed",
	   fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 7 / 16, 4 / 16},
	},
	groups = {snappy=3, flammable=2},
})

minetest.register_abm({
    nodenames = {"mangotree:halfripemango"},
	interval = 30.0,
	chance = 9,
	action = function(pos,node)
	    if minetest.find_node_near(pos, 3, {"air"}) then
		    node.name = "mangotree:ripenmango"
			minetest.swap_node(pos,node)
		end
	end
})

minetest.register_node("mangotree:halfripenmango", {
    description = S("Mango Fruit"),
	drawtype = "plantlike",
	tiles = {"Mangohalfripe.png"},
    inventory_image = "Mangohalfripe.png",
    wield_image = "Mangohalfripe.png",
	paramtype = "light",
	sunlight_propagates = true,
    walkable = false,
	selection_box = {
	   type = "fixed",
	   fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 7 / 16, 4 / 16},
	},
	groups = {snappy=3, flammable=2, not_in_creative_inventory = 1},
})

minetest.register_abm({
    nodenames = {"mangotree:unripemango"},
	interval = 30.0,
	chance = 9,
	action = function(pos,node)
	    if minetest.find_node_near(pos, 3, {"air"}) then
		    node.name = "mangotree:halfripenmango"
			minetest.swap_node(pos,node)
		end
	end
})

minetest.register_node("mangotree:unripenmango", {
    description = S("Mango Fruit"),
	drawtype = "plantlike",
	tiles = {"Mangounripe.png"},
    inventory_image = "Mangounripe.png",
    wield_image = "Mangounripe.png",
	paramtype = "light",
	sunlight_propagates = true,
    walkable = false,
	selection_box = {
	   type = "fixed",
	   fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 7 / 16, 4 / 16},
	},
	groups = {snappy=3, flammable=2, not_in_creative_inventory = 1},
})

minetest.register_craftitem("mangotree:mangoslice",{
    description = S("Mango Slice"),
	inventory_image = "Mangoslice.png",
	on_use = minetest.item_eat(2),
})

minetest.register_craft({
    output = "mangotree:mangoslice 6",
	recipe = {
	    {"mangotree:ripenmango","farming:cutting_board",""},
		{"","",""},
		{"","",""},
	},
	replacements = {
	    {"farming:cutting_board", "farming:cutting_board"}
	},
})

minetest.register_craftitem("mangotree:mangorice",{
    description = S("Mango with Rice"),
	inventory_image = "Mangorice.png",
	on_use = minetest.item_eat(8, "farming:bowl"),
})

minetest.register_craft({
    type = "shapeless",
    output = "mangotree:mangorice",
	recipe = {
	    "group:food_rice",
		"mangotree:mangoslice",
		"mangotree:mangoslice",
		"farming:bowl",
	},
})