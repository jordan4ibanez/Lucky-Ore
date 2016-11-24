--[[
Goals:

-use texture from all default ores and make the ore go through each one fast
-make ore glow
-make ore spawn in an entity which displays all items
-make entity go through all items with a mario cart-esk slot machine sound
-make the starting item a random number from how many items there are
-go ding ding ding when item is randomly selected
-have a half chance of a buzzer playing, along with item turning to tnt, and exploding instantly



]]--
minetest.register_node("lucky_ore:ore", {
	description = "Nether Ore",
	tiles = {
		{
			name = "lucky_ore.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.5,
			},
		},
		{
			name = "lucky_ore.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.5,
			},
		},
	},
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	use_texture_alpha = true,
	walkable = false,
	diggable = false,
	pointable = false,
	buildable_to = false,
	is_ground_content = false,
	drop = "",
	light_source = 5,
	post_effect_color = {a = 180, r = 128, g = 0, b = 128},
	alpha = 192,

	--groups = {not_in_creative_inventory = 1}
})
