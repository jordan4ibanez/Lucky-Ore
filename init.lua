--the ore
minetest.register_node("lucky_ore:ore", {
	description = "Lucky Ore",
	tiles = {
		{
			name = "lucky_ore.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.4,
			},
		},
		{
			name = "lucky_ore.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.4,
			},
		},
	},
	paramtype = "light",
	light_source = 5,
	groups = {cracky = 3},
	after_destruct = function(pos, oldnode)
		local item = minetest.add_entity(pos, "lucky_ore:item")

	end
})
--calculate the table items for slot machine-esk item display
local count = 0
local lucky_table = {}
for item,def in pairs(minetest.registered_items) do 
	count = count + 1
	lucky_table[count] = item
end

--the explosion for loses
local def = {
	name = "lucky_ore:explosion",
	description = "Ore Explosion (you hacker you!)",
	radius = 3,
	tiles = {
		side = "default_dirt.png",
		top = "default_dirt.png",
		bottom = "default_dirt.png",
		burning = "default_dirt.png"
	},
}
tnt.register_tnt(def)

--the entity which shows all the items
minetest.register_entity("lucky_ore:item",{
	hp_max = 1,
	visual="wielditem",
	visual_size={x=.33,y=.33},
	collisionbox = {0,0,0,0,0,0},
	physical=false,
	textures={"air"},
	count = 0, --start at zero since counter adds before showing item
	timer = 0,
	expire = 0,
	counting = true,
	on_activate = function(self, staticdata)
		self.origin = self.object:getpos()
		self.object:set_armor_groups({immortal = 1})
		self.texture = ItemStack("default:dirt_with_grass"):get_name()
		self.nodename = "default:dirt_with_grass"
		self.object:set_properties({textures={self.texture}})
		self.sound = minetest.sound_play("lucky_ore_slot", {
				max_hear_distance = 30,
				gain = 10.0,
				object = self.object,
				loop = true,
			})
		self.object:set_properties({automatic_rotate=1})
		self.expire = math.random(3,15)+math.random()
	end,
	on_step = function(self,dtime)
		self.timer = self.timer + dtime
		self.object:setvelocity({x=0,y=0,z=0})
		self.object:setpos(self.origin)
		--if it's past expiration then stop and do some particles and showcase
		if self.timer >= self.expire then
			--turn off the counting sound
			if self.counting == true then
				minetest.sound_stop(self.sound)
				self.sound = nil
				self.counting = false
			end
			--turn on the win sound
			if self.counting == false and self.sound == nil then
				self.sound = minetest.sound_play("lucky_ore_win", {
						max_hear_distance = 30,
						gain = 10.0,
						object = self.object,
					})
			end
			
			if self.timer >= self.expire + 2 then
				minetest.sound_stop(self.sound)
				
				--the fake win
				if math.random() > 0.5 then
					tnt.boom(self.object:getpos(), def)
					self.object:remove()
				else
					minetest.add_item(self.object:getpos(), lucky_table[self.count])
					self.object:remove()
				end
			end
		else --show all the items and cycle
			self.count = self.count + 1
			if self.count > count then
				self.count = 1
			end
			self.texture = ItemStack(lucky_table[self.count]):get_name()
			self.nodename = lucky_table[self.count]
			self.object:set_properties({textures={self.texture}})
		end
		

	end,
})

--ore generation
minetest.register_ore({
		ore_type       = "scatter",
		ore            = "lucky_ore:ore",
		wherein        = "default:stone",
		clust_scarcity = 8 * 8 * 8,
		clust_num_ores = 9,
		clust_size     = 3,
		y_min          = -31000,
		y_max          = 31000,
	})
