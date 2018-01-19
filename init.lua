
lib_furniture = {}

local _lib_furniture = {}



local function top_face(pointed_thing)
	if not pointed_thing then return end
	return pointed_thing.above.y > pointed_thing.under.y
end

function lib_furniture.sit(pos, node, clicker, pointed_thing)
	if not top_face(pointed_thing) then return end
	local player_name = clicker:get_player_name()
	local objs = minetest.get_objects_inside_radius(pos, 0.1)
	local vel = clicker:get_player_velocity()
	local ctrl = clicker:get_player_control()

	for _, obj in pairs(objs) do
		if obj:is_player() and obj:get_player_name() ~= player_name then
			return
		end
	end

	if default.player_attached[player_name] then
		pos.y = pos.y - 0.5
		clicker:setpos(pos)
		clicker:set_eye_offset({x=0, y=0, z=0}, {x=0, y=0, z=0})
		clicker:set_physics_override(1, 1, 1)
		default.player_attached[player_name] = false
		default.player_set_animation(clicker, "stand", 30)

	elseif not default.player_attached[player_name] and node.param2 <= 3 and not
			ctrl.sneak and vel.x == 0 and vel.y == 0 and vel.z == 0 then

		clicker:set_eye_offset({x=0, y=-7, z=2}, {x=0, y=0, z=0})
		clicker:set_physics_override(0, 0, 0)
		clicker:setpos(pos)
		default.player_attached[player_name] = true
		default.player_set_animation(clicker, "sit", 30)

		if     node.param2 == 0 then clicker:set_look_yaw(3.15)
		elseif node.param2 == 1 then clicker:set_look_yaw(7.9)
		elseif node.param2 == 2 then clicker:set_look_yaw(6.28)
		elseif node.param2 == 3 then clicker:set_look_yaw(4.75) end
	end
end

function lib_furniture.sit_dig(pos, player)
	local pname = player:get_player_name()
	local objs = minetest.get_objects_inside_radius(pos, 0.1)

	for _, p in pairs(objs) do
		if not player or not player:is_player() or p:get_player_name() or
				default.player_attached[pname] then
			return false
		end
	end
	return true
end



function lib_furniture.register_nodes(node_name, node_desc, node_texture, node_craft_mat, node_sounds)

--BED
	lib_furniture.register_bed_basic_01(node_name .. "_bed_basic_01", node_desc .. "Basic Bed 01", node_texture, node_craft_mat, node_sounds)

--CABINET
	lib_furniture.register_cabinet_basic_01(node_name .. "_cabinet_basic_01", node_desc .. "Basic Cabinet 01", node_texture, node_craft_mat, node_sounds)

--TABLES
	lib_furniture.register_table_basic_01(node_name .. "_table_basic_01", node_desc .. "Basic Table 01", node_texture, node_craft_mat, node_sounds)
	lib_furniture.register_table_basic_02(node_name .. "_table_basic_02", node_desc .. "Basic Table 02", node_texture, node_craft_mat, node_sounds)
	lib_furniture.register_table_half_01(node_name .. "_table_half_01", node_desc .. "Basic Half Table 01", node_texture, node_craft_mat, node_sounds)
	lib_furniture.register_table_section_01(node_name .. "_table_section_01", node_desc .. "Basic Table Section 01", node_texture, node_craft_mat, node_sounds)
	
	lib_furniture.register_stool_basic_01(node_name .. "_stool_basic_01", node_desc .. "Basic Stool 01", node_texture, node_craft_mat, node_sounds)

	lib_furniture.register_chair_basic_01(node_name .. "_chair_basic_01", node_desc .. "Basic Chair 01", node_texture, node_craft_mat, node_sounds)
	
end

lib_furniture.register_bed_basic_01 = function(wall_name, wall_desc, wall_texture, wall_mat, wall_sounds)
	-- inventory node, and pole-type wall start item
	
	minetest.register_node("lib_furniture:" .. wall_name, {
		description = wall_desc,
		drawtype = "nodebox",
		tiles = { wall_texture, },
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		walkable = true,
		groups = { cracky = 3, wall = 1, stone = 2 },
		sounds = wall_sounds,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.375, -0.375, 0.5, 0, 1.375}, -- NodeBox1
			{-0.5, -0.5, 1.375, 0.5, 0.5, 1.5}, -- NodeBox2
			{-0.5, -0.5, -0.5, 0.5, 0.1875, -0.375}, -- NodeBox4
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.375, -0.375, 0.5, 0, 1.375}, -- NodeBox1
			{-0.5, -0.5, 1.375, 0.5, 0.5, 1.5}, -- NodeBox2
			{-0.5, -0.5, -0.5, 0.5, 0.1875, -0.375}, -- NodeBox4
		},
	},
	collision_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.375, -0.375, 0.5, 0, 1.375}, -- NodeBox1
			{-0.5, -0.5, 1.375, 0.5, 0.5, 1.5}, -- NodeBox2
			{-0.5, -0.5, -0.5, 0.5, 0.1875, -0.375}, -- NodeBox4
		},
	},

		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end

			local p0 = pointed_thing.under
			local p1 = pointed_thing.above
			local param2 = 0

			local placer_pos = placer:getpos()
			if placer_pos then
				local dir = {
					x = p1.x - placer_pos.x,
					y = p1.y - placer_pos.y,
					z = p1.z - placer_pos.z
				}
				param2 = minetest.dir_to_facedir(dir)
			end

			if p0.y-1 == p1.y then
				param2 = param2 + 20
				if param2 == 21 then
					param2 = 23
				elseif param2 == 23 then
					param2 = 21
				end
			end

			return minetest.item_place(itemstack, placer, pointed_thing, param2)
		end,
	})

	-- crafting recipe
	minetest.register_craft({
		output = "lib_furniture:" .. wall_name .. " 99",
		recipe = {
			{ '', '', '' },
			{ '', "lib_shapes:shape_bed_basic_01", ''},
			{ '', wall_mat, ''},
		}
	})

end

lib_furniture.register_cabinet_basic_01 = function(wall_name, wall_desc, wall_texture, wall_mat, wall_sounds)
	-- inventory node, and pole-type wall start item
	minetest.register_node("lib_furniture:" .. wall_name, {
		description = wall_desc,
		drawtype = "nodebox",
		tiles = { wall_texture, },
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		walkable = true,
		groups = { cracky = 3, wall = 1, stone = 2 },
		sounds = wall_sounds,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.3125, -0.0625, -0.3125, 0.3125, 0.5, 0.3125}, -- NodeBox1
			{-0.3125, -0.5, -0.3125, -0.1875, -0.0625, -0.1875}, -- NodeBox3
			{0.1875, -0.5, -0.3125, 0.3125, -0.0625, -0.1875}, -- NodeBox5
			{-0.3125, -0.5, 0.1875, -0.1875, -0.0625, 0.3125}, -- NodeBox6
			{0.1875, -0.5, 0.1875, 0.3125, -0.0625, 0.3125}, -- NodeBox7
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.3125, -0.0625, -0.3125, 0.3125, 0.5, 0.3125}, -- NodeBox1
			{-0.3125, -0.5, -0.3125, -0.1875, -0.0625, -0.1875}, -- NodeBox3
			{0.1875, -0.5, -0.3125, 0.3125, -0.0625, -0.1875}, -- NodeBox5
			{-0.3125, -0.5, 0.1875, -0.1875, -0.0625, 0.3125}, -- NodeBox6
			{0.1875, -0.5, 0.1875, 0.3125, -0.0625, 0.3125}, -- NodeBox7
		},
	},
	collision_box = {
		type = "fixed",
		fixed = {
			{-0.3125, -0.0625, -0.3125, 0.3125, 0.5, 0.3125}, -- NodeBox1
			{-0.3125, -0.5, -0.3125, -0.1875, -0.0625, -0.1875}, -- NodeBox3
			{0.1875, -0.5, -0.3125, 0.3125, -0.0625, -0.1875}, -- NodeBox5
			{-0.3125, -0.5, 0.1875, -0.1875, -0.0625, 0.3125}, -- NodeBox6
			{0.1875, -0.5, 0.1875, 0.3125, -0.0625, 0.3125}, -- NodeBox7
		},
	},

		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end

			local p0 = pointed_thing.under
			local p1 = pointed_thing.above
			local param2 = 0

			local placer_pos = placer:getpos()
			if placer_pos then
				local dir = {
					x = p1.x - placer_pos.x,
					y = p1.y - placer_pos.y,
					z = p1.z - placer_pos.z
				}
				param2 = minetest.dir_to_facedir(dir)
			end

			if p0.y-1 == p1.y then
				param2 = param2 + 20
				if param2 == 21 then
					param2 = 23
				elseif param2 == 23 then
					param2 = 21
				end
			end

			return minetest.item_place(itemstack, placer, pointed_thing, param2)
		end,
	})

	-- crafting recipe
	minetest.register_craft({
		output = "lib_furniture:" .. wall_name .. " 99",
		recipe = {
			{ '', '', '' },
			{ '', "lib_shapes:shape_cabinet_basic_01", ''},
			{ '', wall_mat, ''},
		}
	})

end


lib_furniture.register_table_basic_01 = function(wall_name, wall_desc, wall_texture, wall_mat, wall_sounds)
	-- inventory node, and pole-type wall start item
	minetest.register_node("lib_furniture:" .. wall_name, {
		description = wall_desc,
		drawtype = "nodebox",
		tiles = { wall_texture, },
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		walkable = true,
		groups = { cracky = 3, wall = 1, stone = 2 },
		sounds = wall_sounds,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0.375, -0.5, 0.5, 0.5, 0.5}, -- NodeBox1
			{-0.375, -0.5, -0.375, -0.25, 0.375, -0.25}, -- NodeBox3
			{0.25, -0.5, -0.375, 0.375, 0.375, -0.25}, -- NodeBox5
			{-0.375, -0.5, 0.25, -0.25, 0.375, 0.375}, -- NodeBox6
			{0.25, -0.5, 0.25, 0.375, 0.375, 0.375}, -- NodeBox7
			{-0.3125, -0.125, -0.3125, 0.3125, -0.0625, 0.3125}, -- NodeBox8
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0.375, -0.5, 0.5, 0.5, 0.5}, -- NodeBox1
			{-0.375, -0.5, -0.375, -0.25, 0.375, -0.25}, -- NodeBox3
			{0.25, -0.5, -0.375, 0.375, 0.375, -0.25}, -- NodeBox5
			{-0.375, -0.5, 0.25, -0.25, 0.375, 0.375}, -- NodeBox6
			{0.25, -0.5, 0.25, 0.375, 0.375, 0.375}, -- NodeBox7
			{-0.3125, -0.125, -0.3125, 0.3125, -0.0625, 0.3125}, -- NodeBox8
		},
	},
	collision_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0.375, -0.5, 0.5, 0.5, 0.5}, -- NodeBox1
			{-0.375, -0.5, -0.375, -0.25, 0.375, -0.25}, -- NodeBox3
			{0.25, -0.5, -0.375, 0.375, 0.375, -0.25}, -- NodeBox5
			{-0.375, -0.5, 0.25, -0.25, 0.375, 0.375}, -- NodeBox6
			{0.25, -0.5, 0.25, 0.375, 0.375, 0.375}, -- NodeBox7
			{-0.3125, -0.125, -0.3125, 0.3125, -0.0625, 0.3125}, -- NodeBox8
		},
	},

		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end

			local p0 = pointed_thing.under
			local p1 = pointed_thing.above
			local param2 = 0

			local placer_pos = placer:getpos()
			if placer_pos then
				local dir = {
					x = p1.x - placer_pos.x,
					y = p1.y - placer_pos.y,
					z = p1.z - placer_pos.z
				}
				param2 = minetest.dir_to_facedir(dir)
			end

			if p0.y-1 == p1.y then
				param2 = param2 + 20
				if param2 == 21 then
					param2 = 23
				elseif param2 == 23 then
					param2 = 21
				end
			end

			return minetest.item_place(itemstack, placer, pointed_thing, param2)
		end,
	})

	-- crafting recipe
	minetest.register_craft({
		output = "lib_furniture:" .. wall_name .. " 99",
		recipe = {
			{ '', '', '' },
			{ '', "lib_shapes:shape_table_basic_01", ''},
			{ '', wall_mat, ''},
		}
	})

end
lib_furniture.register_table_basic_02 = function(wall_name, wall_desc, wall_texture, wall_mat, wall_sounds)
	-- inventory node, and pole-type wall start item
	minetest.register_node("lib_furniture:" .. wall_name, {
		description = wall_desc,
		drawtype = "nodebox",
		tiles = { wall_texture, },
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		walkable = true,
		groups = { cracky = 3, wall = 1, stone = 2 },
		sounds = wall_sounds,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.0625, -0.5, 0.5, 0.0625, 0.5},
			{-0.4000, -0.5, -0.4000, -0.1000, -0.0625, -0.1000},
			{0.1000, -0.5, -0.4000, 0.4000, -0.0625, -0.1000},
			{-0.4000, -0.5, 0.1000, -0.1000, -0.0625, 0.4000},
			{0.1000, -0.5, 0.1000, 0.4000, -0.0625, 0.4000},
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.0625, -0.5, 0.5, 0.0625, 0.5},
			{-0.4000, -0.5, -0.4000, -0.1000, -0.0625, -0.1000},
			{0.1000, -0.5, -0.4000, 0.4000, -0.0625, -0.1000},
			{-0.4000, -0.5, 0.1000, -0.1000, -0.0625, 0.4000},
			{0.1000, -0.5, 0.1000, 0.4000, -0.0625, 0.4000},
		},
	},
	collision_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.0625, -0.5, 0.5, 0.0625, 0.5},
			{-0.4000, -0.5, -0.4000, -0.1000, -0.0625, -0.1000},
			{0.1000, -0.5, -0.4000, 0.4000, -0.0625, -0.1000},
			{-0.4000, -0.5, 0.1000, -0.1000, -0.0625, 0.4000},
			{0.1000, -0.5, 0.1000, 0.4000, -0.0625, 0.4000},
		},
	},

		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end

			local p0 = pointed_thing.under
			local p1 = pointed_thing.above
			local param2 = 0

			local placer_pos = placer:getpos()
			if placer_pos then
				local dir = {
					x = p1.x - placer_pos.x,
					y = p1.y - placer_pos.y,
					z = p1.z - placer_pos.z
				}
				param2 = minetest.dir_to_facedir(dir)
			end

			if p0.y-1 == p1.y then
				param2 = param2 + 20
				if param2 == 21 then
					param2 = 23
				elseif param2 == 23 then
					param2 = 21
				end
			end

			return minetest.item_place(itemstack, placer, pointed_thing, param2)
		end,
	})

	-- crafting recipe
	minetest.register_craft({
		output = "lib_furniture:" .. wall_name .. " 99",
		recipe = {
			{ '', '', '' },
			{ '', "lib_shapes:shape_table_basic_02", ''},
			{ '', wall_mat, ''},
		}
	})

end
lib_furniture.register_table_half_01 = function(wall_name, wall_desc, wall_texture, wall_mat, wall_sounds)
	-- inventory node, and pole-type wall start item
	minetest.register_node("lib_furniture:" .. wall_name, {
		description = wall_desc,
		drawtype = "nodebox",
		tiles = { wall_texture, },
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		walkable = true,
		groups = { cracky = 3, wall = 1, stone = 2 },
		sounds = wall_sounds,
	node_box = {
		type = "fixed",
		fixed = {
				{-0.5, 0.375, -0.5, 0.5, 0.5, 0.5}, -- NodeBox1
				{-0.375, -0.5, -0.375, -0.25, 0.375, -0.25}, -- NodeBox3
				{0.25, -0.5, -0.375, 0.375, 0.375, -0.25}, -- NodeBox6
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
				{-0.5, 0.375, -0.5, 0.5, 0.5, 0.5}, -- NodeBox1
				{-0.375, -0.5, -0.375, -0.25, 0.375, -0.25}, -- NodeBox3
				{0.25, -0.5, -0.375, 0.375, 0.375, -0.25}, -- NodeBox6
		},
	},
	collision_box = {
		type = "fixed",
		fixed = {
				{-0.5, 0.375, -0.5, 0.5, 0.5, 0.5}, -- NodeBox1
				{-0.375, -0.5, -0.375, -0.25, 0.375, -0.25}, -- NodeBox3
				{0.25, -0.5, -0.375, 0.375, 0.375, -0.25}, -- NodeBox6
		},
	},

		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end

			local p0 = pointed_thing.under
			local p1 = pointed_thing.above
			local param2 = 0

			local placer_pos = placer:getpos()
			if placer_pos then
				local dir = {
					x = p1.x - placer_pos.x,
					y = p1.y - placer_pos.y,
					z = p1.z - placer_pos.z
				}
				param2 = minetest.dir_to_facedir(dir)
			end

			if p0.y-1 == p1.y then
				param2 = param2 + 20
				if param2 == 21 then
					param2 = 23
				elseif param2 == 23 then
					param2 = 21
				end
			end

			return minetest.item_place(itemstack, placer, pointed_thing, param2)
		end,
	})

	-- crafting recipe
	minetest.register_craft({
		output = "lib_furniture:" .. wall_name .. " 99",
		recipe = {
			{ '', '', '' },
			{ '', "lib_shapes:shape_table_half_01", ''},
			{ '', wall_mat, ''},
		}
	})

end
lib_furniture.register_table_section_01 = function(wall_name, wall_desc, wall_texture, wall_mat, wall_sounds)
	-- inventory node, and pole-type wall start item
	minetest.register_node("lib_furniture:" .. wall_name, {
		description = wall_desc,
		drawtype = "nodebox",
		tiles = { wall_texture, },
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		walkable = true,
		groups = { cracky = 3, wall = 1, stone = 2 },
		sounds = wall_sounds,
	node_box = {
		type = "fixed",
		fixed = {
				{-0.5, 0.375, -0.5, 0.5, 0.5, 0.5}, -- NodeBox1
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
				{-0.5, 0.375, -0.5, 0.5, 0.5, 0.5}, -- NodeBox1
		},
	},
	collision_box = {
		type = "fixed",
		fixed = {
				{-0.5, 0.375, -0.5, 0.5, 0.5, 0.5}, -- NodeBox1
		},
	},

		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end

			local p0 = pointed_thing.under
			local p1 = pointed_thing.above
			local param2 = 0

			local placer_pos = placer:getpos()
			if placer_pos then
				local dir = {
					x = p1.x - placer_pos.x,
					y = p1.y - placer_pos.y,
					z = p1.z - placer_pos.z
				}
				param2 = minetest.dir_to_facedir(dir)
			end

			if p0.y-1 == p1.y then
				param2 = param2 + 20
				if param2 == 21 then
					param2 = 23
				elseif param2 == 23 then
					param2 = 21
				end
			end

			return minetest.item_place(itemstack, placer, pointed_thing, param2)
		end,
	})

	-- crafting recipe
	minetest.register_craft({
		output = "lib_furniture:" .. wall_name .. " 99",
		recipe = {
			{ '', '', '' },
			{ '', "lib_shapes:shape_table_half_01", ''},
			{ '', wall_mat, ''},
		}
	})

end

lib_furniture.register_stool_basic_01 = function(wall_name, wall_desc, wall_texture, wall_mat, wall_sounds)
	-- inventory node, and pole-type wall start item
	minetest.register_node("lib_furniture:" .. wall_name, {
		description = wall_desc,
		drawtype = "nodebox",
		tiles = { wall_texture, },
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		walkable = true,
		groups = { cracky = 3, wall = 1, stone = 2 },
		sounds = wall_sounds,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.3125, -0.0625, -0.3125, 0.3125, 0.0625, 0.3125},
			{-0.3125, -0.5, -0.3125, -0.1875, -0.0625, -0.1875},
			{0.1875, -0.5, -0.3125, 0.3125, -0.0625, -0.1875},
			{-0.3125, -0.5, 0.1875, -0.1875, -0.0625, 0.3125},
			{0.1875, -0.5, 0.1875, 0.3125, -0.0625, 0.3125},
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.3125, -0.0625, -0.3125, 0.3125, 0.0625, 0.3125},
			{-0.3125, -0.5, -0.3125, -0.1875, -0.0625, -0.1875},
			{0.1875, -0.5, -0.3125, 0.3125, -0.0625, -0.1875},
			{-0.3125, -0.5, 0.1875, -0.1875, -0.0625, 0.3125},
			{0.1875, -0.5, 0.1875, 0.3125, -0.0625, 0.3125},
		},
	},
	collision_box = {
		type = "fixed",
		fixed = {
			{-0.3125, -0.0625, -0.3125, 0.3125, 0.0625, 0.3125},
			{-0.3125, -0.5, -0.3125, -0.1875, -0.0625, -0.1875},
			{0.1875, -0.5, -0.3125, 0.3125, -0.0625, -0.1875},
			{-0.3125, -0.5, 0.1875, -0.1875, -0.0625, 0.3125},
			{0.1875, -0.5, 0.1875, 0.3125, -0.0625, 0.3125},
		},
	},

		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end

			local p0 = pointed_thing.under
			local p1 = pointed_thing.above
			local param2 = 0

			local placer_pos = placer:getpos()
			if placer_pos then
				local dir = {
					x = p1.x - placer_pos.x,
					y = p1.y - placer_pos.y,
					z = p1.z - placer_pos.z
				}
				param2 = minetest.dir_to_facedir(dir)
			end

			if p0.y-1 == p1.y then
				param2 = param2 + 20
				if param2 == 21 then
					param2 = 23
				elseif param2 == 23 then
					param2 = 21
				end
			end

			return minetest.item_place(itemstack, placer, pointed_thing, param2)
		end,
	})

	-- crafting recipe
	minetest.register_craft({
		output = "lib_furniture:" .. wall_name .. " 99",
		recipe = {
			{ '', '', '' },
			{ '', "lib_shapes:shape_stool_basic_01", ''},
			{ '', wall_mat, ''},
		}
	})

end


lib_furniture.register_table_special_01 = function(wall_name, wall_desc, wall_texture, wall_mat, wall_texture2, wall_mat2, wall_sounds)
	-- inventory node, and pole-type wall start item
	minetest.register_node("lib_furniture:" .. wall_name, {
		description = wall_desc,
		drawtype = "nodebox",
		tiles = {
			wall_texture2,
			wall_texture,
			"(overlay_alpha_table_side_frame.png^" .. wall_texture .. "^overlay_alpha_table_side_frame.png^[makealpha:255,126,126)^(overlay_alpha_table_side_surface.png^" .. wall_texture2 .. "^overlay_alpha_table_side_surface.png^[makealpha:255,126,126)",
			"(overlay_alpha_table_side_frame.png^" .. wall_texture .. "^overlay_alpha_table_side_frame.png^[makealpha:255,126,126)^(overlay_alpha_table_side_surface.png^" .. wall_texture2 .. "^overlay_alpha_table_side_surface.png^[makealpha:255,126,126)",
			"(overlay_alpha_table_side_frame.png^" .. wall_texture .. "^overlay_alpha_table_side_frame.png^[makealpha:255,126,126)^(overlay_alpha_table_side_surface.png^" .. wall_texture2 .. "^overlay_alpha_table_side_surface.png^[makealpha:255,126,126)",
			"(overlay_alpha_table_side_frame.png^" .. wall_texture .. "^overlay_alpha_table_side_frame.png^[makealpha:255,126,126)^(overlay_alpha_table_side_surface.png^" .. wall_texture2 .. "^overlay_alpha_table_side_surface.png^[makealpha:255,126,126)",
		},
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		walkable = true,
		groups = { cracky = 3, wall = 1, stone = 2 },
		sounds = wall_sounds,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0.375, -0.5, 0.5, 0.5, 0.5}, -- NodeBox1
			{-0.375, -0.5, -0.375, -0.25, 0.375, -0.25}, -- NodeBox3
			{0.25, -0.5, -0.375, 0.375, 0.375, -0.25}, -- NodeBox5
			{-0.375, -0.5, 0.25, -0.25, 0.375, 0.375}, -- NodeBox6
			{0.25, -0.5, 0.25, 0.375, 0.375, 0.375}, -- NodeBox7
			{-0.3125, -0.125, -0.3125, 0.3125, -0.0625, 0.3125}, -- NodeBox8
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0.375, -0.5, 0.5, 0.5, 0.5}, -- NodeBox1
			{-0.375, -0.5, -0.375, -0.25, 0.375, -0.25}, -- NodeBox3
			{0.25, -0.5, -0.375, 0.375, 0.375, -0.25}, -- NodeBox5
			{-0.375, -0.5, 0.25, -0.25, 0.375, 0.375}, -- NodeBox6
			{0.25, -0.5, 0.25, 0.375, 0.375, 0.375}, -- NodeBox7
			{-0.3125, -0.125, -0.3125, 0.3125, -0.0625, 0.3125}, -- NodeBox8
		},
	},
	collision_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0.375, -0.5, 0.5, 0.5, 0.5}, -- NodeBox1
			{-0.375, -0.5, -0.375, -0.25, 0.375, -0.25}, -- NodeBox3
			{0.25, -0.5, -0.375, 0.375, 0.375, -0.25}, -- NodeBox5
			{-0.375, -0.5, 0.25, -0.25, 0.375, 0.375}, -- NodeBox6
			{0.25, -0.5, 0.25, 0.375, 0.375, 0.375}, -- NodeBox7
			{-0.3125, -0.125, -0.3125, 0.3125, -0.0625, 0.3125}, -- NodeBox8
		},
	},

		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end

			local p0 = pointed_thing.under
			local p1 = pointed_thing.above
			local param2 = 0

			local placer_pos = placer:getpos()
			if placer_pos then
				local dir = {
					x = p1.x - placer_pos.x,
					y = p1.y - placer_pos.y,
					z = p1.z - placer_pos.z
				}
				param2 = minetest.dir_to_facedir(dir)
			end

			if p0.y-1 == p1.y then
				param2 = param2 + 20
				if param2 == 21 then
					param2 = 23
				elseif param2 == 23 then
					param2 = 21
				end
			end

			return minetest.item_place(itemstack, placer, pointed_thing, param2)
		end,
	})

	-- crafting recipe
	minetest.register_craft({
		output = "lib_furniture:" .. wall_name .. " 99",
		recipe = {
			{ '', wall_mat2, '' },
			{ '', "lib_shapes:shape_table_special_01", ''},
			{ '', wall_mat, ''},
		}
	})

end

lib_furniture.register_chair_basic_01 = function(wall_name, wall_desc, wall_texture, wall_mat, wall_sounds)
	-- inventory node, and pole-type wall start item
	minetest.register_node("lib_furniture:" .. wall_name, {
		description = wall_desc,
		drawtype = "nodebox",
		tiles = { wall_texture, },
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		walkable = true,
		groups = { cracky = 3, wall = 1, stone = 2 },
		sounds = wall_sounds,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.3125, -0.0625, -0.3125, 0.3125, 0.0625, 0.3125}, -- NodeBox1
				{-0.3125, 0, 0.1875, 0.3125, 0.5, 0.3125}, -- NodeBox2
				{-0.3125, -0.5, -0.3125, -0.1875, -0.0625, -0.1875}, -- NodeBox3
				{0.1875, -0.5, -0.3125, 0.3125, -0.0625, -0.1875}, -- NodeBox5
				{-0.3125, -0.5, 0.1875, -0.1875, -0.0625, 0.3125}, -- NodeBox6
				{0.1875, -0.5, 0.1875, 0.3125, -0.0625, 0.3125}, -- NodeBox7
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.3125, -0.0625, -0.3125, 0.3125, 0.0625, 0.3125}, -- NodeBox1
				{-0.3125, 0, 0.1875, 0.3125, 0.5, 0.3125}, -- NodeBox2
				{-0.3125, -0.5, -0.3125, -0.1875, -0.0625, -0.1875}, -- NodeBox3
				{0.1875, -0.5, -0.3125, 0.3125, -0.0625, -0.1875}, -- NodeBox5
				{-0.3125, -0.5, 0.1875, -0.1875, -0.0625, 0.3125}, -- NodeBox6
				{0.1875, -0.5, 0.1875, 0.3125, -0.0625, 0.3125}, -- NodeBox7
			},
		},
		collision_box = {
			type = "fixed",
			fixed = {
				{-0.3125, -0.0625, -0.3125, 0.3125, 0.0625, 0.3125}, -- NodeBox1
				{-0.3125, 0, 0.1875, 0.3125, 0.5, 0.3125}, -- NodeBox2
				{-0.3125, -0.5, -0.3125, -0.1875, -0.0625, -0.1875}, -- NodeBox3
				{0.1875, -0.5, -0.3125, 0.3125, -0.0625, -0.1875}, -- NodeBox5
				{-0.3125, -0.5, 0.1875, -0.1875, -0.0625, 0.3125}, -- NodeBox6
				{0.1875, -0.5, 0.1875, 0.3125, -0.0625, 0.3125}, -- NodeBox7
			},
		},

		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end

			local p0 = pointed_thing.under
			local p1 = pointed_thing.above
			local param2 = 0

			local placer_pos = placer:getpos()
			if placer_pos then
				local dir = {
					x = p1.x - placer_pos.x,
					y = p1.y - placer_pos.y,
					z = p1.z - placer_pos.z
				}
				param2 = minetest.dir_to_facedir(dir)
			end

			if p0.y-1 == p1.y then
				param2 = param2 + 20
				if param2 == 21 then
					param2 = 23
				elseif param2 == 23 then
					param2 = 21
				end
			end

			return minetest.item_place(itemstack, placer, pointed_thing, param2)
		end,

		on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
				pos.y = pos.y + 0  -- Sitting position.
				lib_furniture.sit(pos, node, clicker, pointed_thing)
		end

	})

	-- crafting recipe
	minetest.register_craft({
		output = "lib_furniture:" .. wall_name .. " 99",
		recipe = {
			{ '', '', '' },
			{ '', "lib_shapes:shape_chair_basic_01", ''},
			{ '', wall_mat, ''},
		}
	})

end


lib_furniture.register_chair01_special = function(wall_name, wall_desc, wall_texture, wall_mat, wall_texture2, wall_mat2, wall_sounds)
	-- inventory node, and pole-type wall start item
	minetest.register_node("lib_furniture:" .. wall_name, {
		description = wall_desc,
		drawtype = "nodebox",
		tiles = {
			"(overlay_alpha_chair_top_frame.png^" .. wall_texture .. "^overlay_alpha_chair_top_frame.png^[makealpha:255,126,126)^(overlay_alpha_chair_top_fabric.png^" .. wall_texture2 .. "^overlay_alpha_chair_top_fabric.png^[makealpha:255,126,126)",
			wall_texture,
			wall_texture,
			wall_texture,
			wall_texture,
			"(overlay_alpha_chair_front_frame.png^" .. wall_texture .. "^overlay_alpha_chair_front_frame.png^[makealpha:255,126,126)^(overlay_alpha_chair_front_fabric.png^" .. wall_texture2 .. "^overlay_alpha_chair_front_fabric.png^[makealpha:255,126,126)",
		},
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		walkable = true,
		groups = { cracky = 3, wall = 1, stone = 2 },
		sounds = wall_sounds,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5}, -- NodeBox1
				{-0.5, 0, 0.25, 0.5, 0.5, 0.5}, -- NodeBox2
				{-0.5, 0, -0.5, -0.375, 0.25, 0.25}, -- NodeBox3
				{0.375, 0, -0.5, 0.5, 0.25, 0.25}, -- NodeBox4
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5}, -- NodeBox1
				{-0.5, 0, 0.25, 0.5, 0.5, 0.5}, -- NodeBox2
				{-0.5, 0, -0.5, -0.375, 0.25, 0.25}, -- NodeBox3
				{0.375, 0, -0.5, 0.5, 0.25, 0.25}, -- NodeBox4
			},
		},
		collision_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5}, -- NodeBox1
				{-0.5, 0, 0.25, 0.5, 0.5, 0.5}, -- NodeBox2
				{-0.5, 0, -0.5, -0.375, 0.25, 0.25}, -- NodeBox3
				{0.375, 0, -0.5, 0.5, 0.25, 0.25}, -- NodeBox4
			},
		},

		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end

			local p0 = pointed_thing.under
			local p1 = pointed_thing.above
			local param2 = 0

			local placer_pos = placer:getpos()
			if placer_pos then
				local dir = {
					x = p1.x - placer_pos.x,
					y = p1.y - placer_pos.y,
					z = p1.z - placer_pos.z
				}
				param2 = minetest.dir_to_facedir(dir)
			end

			if p0.y-1 == p1.y then
				param2 = param2 + 20
				if param2 == 21 then
					param2 = 23
				elseif param2 == 23 then
					param2 = 21
				end
			end

			return minetest.item_place(itemstack, placer, pointed_thing, param2)
		end,

		on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
				pos.y = pos.y + 0  -- Sitting position.
				lib_furniture.sit(pos, node, clicker, pointed_thing)
		end

	})

	-- crafting recipe
	minetest.register_craft({
		output = "lib_furniture:" .. wall_name .. " 99",
		recipe = {
			{ '', wall_mat2, '' },
			{ '', "lib_shapes:shape_chair_arm_01", ''},
			{ '', wall_mat, ''},
		}
	})

end
lib_furniture.register_chair02_special = function(wall_name, wall_desc, wall_texture, wall_mat, wall_texture2, wall_mat2, wall_sounds)
	-- inventory node, and pole-type wall start item
	minetest.register_node("lib_furniture:" .. wall_name, {
		description = wall_desc,
		drawtype = "nodebox",
		tiles = {
			"(overlay_alpha_chair_top_frame.png^" .. wall_texture .. "^overlay_alpha_chair_top_frame.png^[makealpha:255,126,126)^(overlay_alpha_chair_top_fabric.png^" .. wall_texture2 .. "^overlay_alpha_chair_top_fabric.png^[makealpha:255,126,126)",
			wall_texture,
			wall_texture,
			wall_texture,
			wall_texture,
			"(overlay_alpha_chair_front_frame.png^" .. wall_texture .. "^overlay_alpha_chair_front_frame.png^[makealpha:255,126,126)^(overlay_alpha_chair_front_fabric.png^" .. wall_texture2 .. "^overlay_alpha_chair_front_fabric.png^[makealpha:255,126,126)",
		},
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		walkable = true,
		groups = { cracky = 3, wall = 1, stone = 2 },
		sounds = wall_sounds,
		node_box = {
			type = "fixed",
			fixed = {
			{-0.375, -0.125, -0.5, 0.375, 0, 0.5}, -- NodeBox1
			{-0.4375, 0, 0.25, 0.4375, 0.5, 0.5}, -- NodeBox2
			{-0.5, -0.5, -0.5, -0.375, 0.25, 0.5}, -- NodeBox3
			{0.375, -0.5, -0.5, 0.5, 0.25, 0.5}, -- NodeBox4
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
			{-0.375, -0.125, -0.5, 0.375, 0, 0.5},
			{-0.4375, 0, 0.25, 0.4375, 0.5, 0.5},
			{-0.5, -0.5, -0.5, -0.375, 0.25, 0.5},
			{0.375, -0.5, -0.5, 0.5, 0.25, 0.5},
			},
		},
		collision_box = {
			type = "fixed",
			fixed = {
			{-0.375, -0.125, -0.5, 0.375, 0, 0.5},
			{-0.4375, 0, 0.25, 0.4375, 0.5, 0.5},
			{-0.5, -0.5, -0.5, -0.375, 0.25, 0.5},
			{0.375, -0.5, -0.5, 0.5, 0.25, 0.5},
			},
		},

		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end

			local p0 = pointed_thing.under
			local p1 = pointed_thing.above
			local param2 = 0

			local placer_pos = placer:getpos()
			if placer_pos then
				local dir = {
					x = p1.x - placer_pos.x,
					y = p1.y - placer_pos.y,
					z = p1.z - placer_pos.z
				}
				param2 = minetest.dir_to_facedir(dir)
			end

			if p0.y-1 == p1.y then
				param2 = param2 + 20
				if param2 == 21 then
					param2 = 23
				elseif param2 == 23 then
					param2 = 21
				end
			end

			return minetest.item_place(itemstack, placer, pointed_thing, param2)
		end,

		on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
				pos.y = pos.y + 0  -- Sitting position.
				lib_furniture.sit(pos, node, clicker, pointed_thing)
		end

	})

	-- crafting recipe
	minetest.register_craft({
		output = "lib_furniture:" .. wall_name .. " 99",
		recipe = {
			{ '', wall_mat2, '' },
			{ '', "lib_shapes:shape_chair_arm_02", ''},
			{ '', wall_mat, ''},
		}
	})

end

lib_furniture.register_sofa_basic_01_corner_special = function(wall_name, wall_desc, wall_texture, wall_mat, wall_texture2, wall_mat2, wall_sounds)
	-- inventory node, and pole-type wall start item
	minetest.register_node("lib_furniture:" .. wall_name, {
		description = wall_desc,
		drawtype = "nodebox",
		tiles = {
			"(overlay_alpha_chair_top_frame.png^" .. wall_texture .. "^overlay_alpha_chair_top_frame.png^[makealpha:255,126,126)^(overlay_alpha_chair_top_fabric.png^" .. wall_texture2 .. "^overlay_alpha_chair_top_fabric.png^[makealpha:255,126,126)",
			wall_texture,
			wall_texture,
			wall_texture,
			wall_texture,
			"(overlay_alpha_chair_front_frame.png^" .. wall_texture .. "^overlay_alpha_chair_front_frame.png^[makealpha:255,126,126)^(overlay_alpha_chair_front_fabric.png^" .. wall_texture2 .. "^overlay_alpha_chair_front_fabric.png^[makealpha:255,126,126)",
		},
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		walkable = true,
		groups = { cracky = 3, wall = 1, stone = 2 },
		sounds = wall_sounds,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.375, -0.5, 0.25, 0, 0.25},
				{-0.5, -0.5, 0.25, 0.25, 0.5, 0.5},
				{0.25, -0.5, -0.5, 0.5, 0.5, 0.5},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.375, -0.5, 0.25, 0, 0.25},
				{-0.5, -0.5, 0.25, 0.25, 0.5, 0.5},
				{0.25, -0.5, -0.5, 0.5, 0.5, 0.5},
			},
		},
		collision_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.375, -0.5, 0.25, 0, 0.25},
				{-0.5, -0.5, 0.25, 0.25, 0.5, 0.5},
				{0.25, -0.5, -0.5, 0.5, 0.5, 0.5},
			},
		},

		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end

			local p0 = pointed_thing.under
			local p1 = pointed_thing.above
			local param2 = 0

			local placer_pos = placer:getpos()
			if placer_pos then
				local dir = {
					x = p1.x - placer_pos.x,
					y = p1.y - placer_pos.y,
					z = p1.z - placer_pos.z
				}
				param2 = minetest.dir_to_facedir(dir)
			end

			if p0.y-1 == p1.y then
				param2 = param2 + 20
				if param2 == 21 then
					param2 = 23
				elseif param2 == 23 then
					param2 = 21
				end
			end

			return minetest.item_place(itemstack, placer, pointed_thing, param2)
		end,

		on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
				pos.y = pos.y + 0  -- Sitting position.
				lib_furniture.sit(pos, node, clicker, pointed_thing)
		end

	})

	-- crafting recipe
	minetest.register_craft({
		output = "lib_furniture:" .. wall_name .. " 99",
		recipe = {
			{ '', wall_mat2, '' },
			{ '', "lib_shapes:shape_sofa_basic_01_corner", ''},
			{ '', wall_mat, ''},
		}
	})

end
lib_furniture.register_sofa_basic_01_left_special = function(wall_name, wall_desc, wall_texture, wall_mat, wall_texture2, wall_mat2, wall_sounds)
	-- inventory node, and pole-type wall start item
	minetest.register_node("lib_furniture:" .. wall_name, {
		description = wall_desc,
		drawtype = "nodebox",
		tiles = {
			"(overlay_alpha_chair_top_frame.png^" .. wall_texture .. "^overlay_alpha_chair_top_frame.png^[makealpha:255,126,126)^(overlay_alpha_chair_top_fabric.png^" .. wall_texture2 .. "^overlay_alpha_chair_top_fabric.png^[makealpha:255,126,126)",
			wall_texture,
			wall_texture,
			wall_texture,
			wall_texture,
			"(overlay_alpha_chair_front_frame.png^" .. wall_texture .. "^overlay_alpha_chair_front_frame.png^[makealpha:255,126,126)^(overlay_alpha_chair_front_fabric.png^" .. wall_texture2 .. "^overlay_alpha_chair_front_fabric.png^[makealpha:255,126,126)",
		},
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		walkable = true,
		groups = { cracky = 3, wall = 1, stone = 2 },
		sounds = wall_sounds,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.375, -0.375, -0.5, 0.5, 0, 0.25},
				{-0.375, -0.375, 0.25, 0.5, 0.5, 0.5},
				{-0.5, -0.5, -0.5, -0.375, 0.25, 0.5},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.375, -0.375, -0.5, 0.5, 0, 0.25},
				{-0.375, -0.375, 0.25, 0.5, 0.5, 0.5},
				{-0.5, -0.5, -0.5, -0.375, 0.25, 0.5},
			},
		},
		collision_box = {
			type = "fixed",
			fixed = {
				{-0.375, -0.375, -0.5, 0.5, 0, 0.25},
				{-0.375, -0.375, 0.25, 0.5, 0.5, 0.5},
				{-0.5, -0.5, -0.5, -0.375, 0.25, 0.5},
			},
		},

		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end

			local p0 = pointed_thing.under
			local p1 = pointed_thing.above
			local param2 = 0

			local placer_pos = placer:getpos()
			if placer_pos then
				local dir = {
					x = p1.x - placer_pos.x,
					y = p1.y - placer_pos.y,
					z = p1.z - placer_pos.z
				}
				param2 = minetest.dir_to_facedir(dir)
			end

			if p0.y-1 == p1.y then
				param2 = param2 + 20
				if param2 == 21 then
					param2 = 23
				elseif param2 == 23 then
					param2 = 21
				end
			end

			return minetest.item_place(itemstack, placer, pointed_thing, param2)
		end,

		on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
				pos.y = pos.y + 0  -- Sitting position.
				lib_furniture.sit(pos, node, clicker, pointed_thing)
		end

	})

	-- crafting recipe
	minetest.register_craft({
		output = "lib_furniture:" .. wall_name .. " 99",
		recipe = {
			{ '', wall_mat2, '' },
			{ '', "lib_shapes:shape_sofa_basic_01_left", ''},
			{ '', wall_mat, ''},
		}
	})

end
lib_furniture.register_sofa_basic_01_right_special = function(wall_name, wall_desc, wall_texture, wall_mat, wall_texture2, wall_mat2, wall_sounds)
	-- inventory node, and pole-type wall start item
	minetest.register_node("lib_furniture:" .. wall_name, {
		description = wall_desc,
		drawtype = "nodebox",
		tiles = {
			"(overlay_alpha_chair_top_frame.png^" .. wall_texture .. "^overlay_alpha_chair_top_frame.png^[makealpha:255,126,126)^(overlay_alpha_chair_top_fabric.png^" .. wall_texture2 .. "^overlay_alpha_chair_top_fabric.png^[makealpha:255,126,126)",
			wall_texture,
			wall_texture,
			wall_texture,
			wall_texture,
			"(overlay_alpha_chair_front_frame.png^" .. wall_texture .. "^overlay_alpha_chair_front_frame.png^[makealpha:255,126,126)^(overlay_alpha_chair_front_fabric.png^" .. wall_texture2 .. "^overlay_alpha_chair_front_fabric.png^[makealpha:255,126,126)",
		},
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		walkable = true,
		groups = { cracky = 3, wall = 1, stone = 2 },
		sounds = wall_sounds,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.375, -0.5, 0.375, 0, 0.25},
				{-0.5, -0.375, 0.25, 0.375, 0.5, 0.5},
				{0.375, -0.5, -0.5, 0.5, 0.25, 0.5},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.375, -0.5, 0.375, 0, 0.25},
				{-0.5, -0.375, 0.25, 0.375, 0.5, 0.5},
				{0.375, -0.5, -0.5, 0.5, 0.25, 0.5},
			},
		},
		collision_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.375, -0.5, 0.375, 0, 0.25},
				{-0.5, -0.375, 0.25, 0.375, 0.5, 0.5},
				{0.375, -0.5, -0.5, 0.5, 0.25, 0.5},
			},
		},

		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end

			local p0 = pointed_thing.under
			local p1 = pointed_thing.above
			local param2 = 0

			local placer_pos = placer:getpos()
			if placer_pos then
				local dir = {
					x = p1.x - placer_pos.x,
					y = p1.y - placer_pos.y,
					z = p1.z - placer_pos.z
				}
				param2 = minetest.dir_to_facedir(dir)
			end

			if p0.y-1 == p1.y then
				param2 = param2 + 20
				if param2 == 21 then
					param2 = 23
				elseif param2 == 23 then
					param2 = 21
				end
			end

			return minetest.item_place(itemstack, placer, pointed_thing, param2)
		end,

		on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
				pos.y = pos.y + 0  -- Sitting position.
				lib_furniture.sit(pos, node, clicker, pointed_thing)
		end

	})

	-- crafting recipe
	minetest.register_craft({
		output = "lib_furniture:" .. wall_name .. " 99",
		recipe = {
			{ '', wall_mat2, '' },
			{ '', "lib_shapes:shape_sofa_basic_01_right", ''},
			{ '', wall_mat, ''},
		}
	})

end
lib_furniture.register_sofa_basic_01_section_special = function(wall_name, wall_desc, wall_texture, wall_mat, wall_texture2, wall_mat2, wall_sounds)
	-- inventory node, and pole-type wall start item
	minetest.register_node("lib_furniture:" .. wall_name, {
		description = wall_desc,
		drawtype = "nodebox",
		tiles = {
			"(overlay_alpha_chair_top_frame.png^" .. wall_texture .. "^overlay_alpha_chair_top_frame.png^[makealpha:255,126,126)^(overlay_alpha_chair_top_fabric.png^" .. wall_texture2 .. "^overlay_alpha_chair_top_fabric.png^[makealpha:255,126,126)",
			wall_texture,
			wall_texture,
			wall_texture,
			wall_texture,
			"(overlay_alpha_chair_front_frame.png^" .. wall_texture .. "^overlay_alpha_chair_front_frame.png^[makealpha:255,126,126)^(overlay_alpha_chair_front_fabric.png^" .. wall_texture2 .. "^overlay_alpha_chair_front_fabric.png^[makealpha:255,126,126)",
		},
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		walkable = true,
		groups = { cracky = 3, wall = 1, stone = 2 },
		sounds = wall_sounds,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.375, -0.5, 0.5, 0, 0.25},
				{-0.5, -0.375, 0.25, 0.5, 0.5, 0.5},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.375, -0.5, 0.5, 0, 0.25},
				{-0.5, -0.375, 0.25, 0.5, 0.5, 0.5},
			},
		},
		collision_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.375, -0.5, 0.5, 0, 0.25},
				{-0.5, -0.375, 0.25, 0.5, 0.5, 0.5},
			},
		},

		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end

			local p0 = pointed_thing.under
			local p1 = pointed_thing.above
			local param2 = 0

			local placer_pos = placer:getpos()
			if placer_pos then
				local dir = {
					x = p1.x - placer_pos.x,
					y = p1.y - placer_pos.y,
					z = p1.z - placer_pos.z
				}
				param2 = minetest.dir_to_facedir(dir)
			end

			if p0.y-1 == p1.y then
				param2 = param2 + 20
				if param2 == 21 then
					param2 = 23
				elseif param2 == 23 then
					param2 = 21
				end
			end

			return minetest.item_place(itemstack, placer, pointed_thing, param2)
		end,

		on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
				pos.y = pos.y + 0  -- Sitting position.
				lib_furniture.sit(pos, node, clicker, pointed_thing)
		end

	})

	-- crafting recipe
	minetest.register_craft({
		output = "lib_furniture:" .. wall_name .. " 99",
		recipe = {
			{ '', wall_mat2, '' },
			{ '', "lib_shapes:shape_sofa_basic_01_section", ''},
			{ '', wall_mat, ''},
		}
	})

end


--[[

lib_furniture.register_nodes("cobble", "Cobblestone ", "default_cobble.png",
		"default:cobble", default.node_sound_stone_defaults())
lib_furniture.register_nodes("mossycobble", "Mossy Cobblestone ", "default_mossycobble.png",
		"default:mossycobble", default.node_sound_stone_defaults())
lib_furniture.register_nodes("desertcobble", "Desert Cobblestone ", "default_desert_cobble.png",
		"default:desert_cobble", default.node_sound_stone_defaults())

--]]

lib_furniture.register_nodes("sandstone", "Sandstone ", "default_sandstone.png",
		"default:sandstone", default.node_sound_stone_defaults())
lib_furniture.register_nodes("desert_stone", "Desert Stone ", "default_desert_stone.png",
		"default:desert_stone", default.node_sound_stone_defaults())
lib_furniture.register_nodes("stone", "Stone ", "default_stone.png",
		"default:stone", default.node_sound_stone_defaults())
lib_furniture.register_nodes("obsidian", "Obsidian ", "default_obsidian.png",
		"default:obsidian", default.node_sound_stone_defaults())

lib_furniture.register_nodes("sandstone_block", "Sandstone Block ", "default_sandstone_block.png",
		"default:sandstone_block", default.node_sound_stone_defaults())
lib_furniture.register_nodes("desert_stone_block", "Desert Stone Block ", "default_desert_stone_block.png",
		"default:desert_stone_block", default.node_sound_stone_defaults())
lib_furniture.register_nodes("stone_block", "Stone Block ", "default_stone_block.png",
		"default:stone_block", default.node_sound_stone_defaults())
lib_furniture.register_nodes("obsidian_block", "Obsidian Block ", "default_obsidian_block.png",
		"default:obsidian_block", default.node_sound_stone_defaults())

--[[

lib_furniture.register_nodes("sandstone_brick", "Sandstone Brick ", "default_sandstone_brick.png",
		"default:sandstonebrick", default.node_sound_stone_defaults())
lib_furniture.register_nodes("desertstone_brick", "Desert Stone Brick ", "default_desert_stone_brick.png",
		"default:desert_stonebrick", default.node_sound_stone_defaults())
lib_furniture.register_nodes("stone_brick", "Stone Brick ", "default_stone_brick.png",
		"default:stonebrick", default.node_sound_stone_defaults())
lib_furniture.register_nodes("obsidian_brick", "Obsidian Brick ", "default_obsidian_brick.png",
		"default:obsidianbrick", default.node_sound_stone_defaults())


lib_furniture.register_nodes("glass", "Glass ", "default_glass.png",
		"default:glass", default.node_sound_stone_defaults())

--]]

lib_furniture.register_nodes("tree", "Tree ", "default_tree.png",
		"default:tree", default.node_sound_stone_defaults())
lib_furniture.register_nodes("wood", "Wood ", "default_wood.png",
		"default:wood", default.node_sound_stone_defaults())
lib_furniture.register_nodes("jungletree", "Jungle Tree ", "default_jungletree.png",
		"default:jungletree", default.node_sound_stone_defaults())
lib_furniture.register_nodes("junglewood", "Jungle Wood ", "default_junglewood.png",
		"default:junglewood", default.node_sound_stone_defaults())

lib_furniture.register_nodes("acacia_tree", "Acacia Tree ", "default_acacia_tree.png",
		"default:acacia_tree", default.node_sound_stone_defaults())
lib_furniture.register_nodes("acacia_wood", "Acacia Wood ", "default_acacia_wood.png",
		"default:acacia_wood", default.node_sound_stone_defaults())


lib_furniture.register_table_special_01("table_special_01" .. "_wood" .. "_stone", "lib_furniture " .. "Wood and Stone Table", "default_wood.png", "default:wood", "default_stone.png", "default:stone", default.node_sound_stone_defaults())
lib_furniture.register_table_special_01("table_special_01" .. "_wood" .. "_desert_stone", "lib_furniture " .. "Wood and Desert Stone Table", "default_wood.png", "default:wood", "default_desert_stone.png", "default:desert_stone", default.node_sound_stone_defaults())
lib_furniture.register_table_special_01("table_special_01" .. "_wood" .. "_stone_block", "lib_furniture " .. "Wood and Stone Block Table", "default_wood.png", "default:wood", "default_stone_block.png", "default:stone_block", default.node_sound_stone_defaults())


lib_furniture.register_chair01_special("chair01" .. "_tree" .. "_wool_black", "lib_furniture " .. "Tree and Black Wool Chair01", "default_tree.png", "default:tree", "wool_black.png", "wool:black", default.node_sound_stone_defaults())
lib_furniture.register_chair01_special("chair01" .. "_tree" .. "_wool_grey", "lib_furniture " .. "Tree and Grey Wool Chair01", "default_tree.png", "default:tree", "wool_grey.png", "wool:grey", default.node_sound_stone_defaults())
lib_furniture.register_chair01_special("chair01" .. "_tree" .. "_wool_white", "lib_furniture " .. "Tree and White Wool Chair01", "default_tree.png", "default:tree", "wool_white.png", "wool:white", default.node_sound_stone_defaults())

lib_furniture.register_chair01_special("chair01" .. "aspen_tree" .. "_wool_black", "lib_furniture " .. "Aspen Tree and Black Wool Chair01", "default_aspen_tree.png", "default:aspen_tree", "wool_black.png", "wool:black", default.node_sound_stone_defaults())
lib_furniture.register_chair01_special("chair01" .. "aspen_tree" .. "_wool_grey", "lib_furniture " .. "Aspen Tree and Grey Wool Chair01", "default_aspen_tree.png", "default:aspen_tree", "wool_grey.png", "wool:grey", default.node_sound_stone_defaults())
lib_furniture.register_chair01_special("chair01" .. "aspen_tree" .. "_wool_white", "lib_furniture " .. "Aspen Tree and White Wool Chair01", "default_aspen_tree.png", "default:aspen_tree", "wool_white.png", "wool:white", default.node_sound_stone_defaults())

lib_furniture.register_chair01_special("chair01" .. "_jungletree" .. "_wool_black", "lib_furniture " .. "Jungle Tree and Black Wool Chair01", "default_jungletree.png", "default:jungletree", "wool_black.png", "wool:black", default.node_sound_stone_defaults())
lib_furniture.register_chair01_special("chair01" .. "_jungletree" .. "_wool_grey", "lib_furniture " .. "Jungle Tree and Grey Wool Chair01", "default_jungletree.png", "default:jungletree", "wool_grey.png", "wool:grey", default.node_sound_stone_defaults())
lib_furniture.register_chair01_special("chair01" .. "_jungletree" .. "_wool_red", "lib_furniture " .. "Jungle Tree and Red Wool Chair01", "default_jungletree.png", "default:jungletree", "wool_red.png", "wool:red", default.node_sound_stone_defaults())
lib_furniture.register_chair01_special("chair01" .. "_jungletree" .. "_wool_blue", "lib_furniture " .. "Jungle Tree and Blue Wool Chair01", "default_jungletree.png", "default:jungletree", "wool_blue.png", "wool:blue", default.node_sound_stone_defaults())
lib_furniture.register_chair01_special("chair01" .. "_jungletree" .. "_wool_green", "lib_furniture " .. "Jungle Tree and Green Wool Chair01", "default_jungletree.png", "default:jungletree", "wool_green.png", "wool:green", default.node_sound_stone_defaults())
lib_furniture.register_chair01_special("chair01" .. "_jungletree" .. "_wool_yellow", "lib_furniture " .. "Jungle Tree and Yellow Wool Chair01", "default_jungletree.png", "default:jungletree", "wool_yellow.png", "wool:yellow", default.node_sound_stone_defaults())
lib_furniture.register_chair01_special("chair01" .. "_jungletree" .. "_wool_white", "lib_furniture " .. "Jungle Tree and White Wool Chair01", "default_jungletree.png", "default:jungletree", "wool_white.png", "wool:white", default.node_sound_stone_defaults())


lib_furniture.register_chair02_special("chair02" .. "_tree" .. "_wool_black", "lib_furniture " .. "Tree and Black Wool Chair02", "default_tree.png", "default:tree", "wool_black.png", "wool:black", default.node_sound_stone_defaults())
lib_furniture.register_chair02_special("chair02" .. "_tree" .. "_wool_grey", "lib_furniture " .. "Tree and Grey Wool Chair02", "default_tree.png", "default:tree", "wool_grey.png", "wool:grey", default.node_sound_stone_defaults())
lib_furniture.register_chair02_special("chair02" .. "_tree" .. "_wool_white", "lib_furniture " .. "Tree and White Wool Chair02", "default_tree.png", "default:tree", "wool_white.png", "wool:white", default.node_sound_stone_defaults())

lib_furniture.register_chair02_special("chair02" .. "aspen_tree" .. "_wool_black", "lib_furniture " .. "Aspen Tree and Black Wool Chair02", "default_aspen_tree.png", "default:tree", "wool_black.png", "wool:black", default.node_sound_stone_defaults())
lib_furniture.register_chair02_special("chair02" .. "aspen_tree" .. "_wool_grey", "lib_furniture " .. "Aspen Tree and Grey Wool Chair02", "default_aspen_tree.png", "default:tree", "wool_grey.png", "wool:grey", default.node_sound_stone_defaults())
lib_furniture.register_chair02_special("chair02" .. "aspen_tree" .. "_wool_white", "lib_furniture " .. "Aspen Tree and White Wool Chair02", "default_aspen_tree.png", "default:tree", "wool_white.png", "wool:white", default.node_sound_stone_defaults())

lib_furniture.register_chair02_special("chair02" .. "_jungletree" .. "_wool_black", "lib_furniture " .. "Jungle Tree and Black Wool Chair02", "default_jungletree.png", "default:jungletree", "wool_black.png", "wool:black", default.node_sound_stone_defaults())
lib_furniture.register_chair02_special("chair02" .. "_jungletree" .. "_wool_grey", "lib_furniture " .. "Jungle Tree and Grey Wool Chair02", "default_jungletree.png", "default:jungletree", "wool_grey.png", "wool:grey", default.node_sound_stone_defaults())
lib_furniture.register_chair02_special("chair02" .. "_jungletree" .. "_wool_red", "lib_furniture " .. "Jungle Tree and Red Wool Chair02", "default_jungletree.png", "default:jungletree", "wool_red.png", "wool:red", default.node_sound_stone_defaults())
lib_furniture.register_chair02_special("chair02" .. "_jungletree" .. "_wool_blue", "lib_furniture " .. "Jungle Tree and Blue Wool Chair02", "default_jungletree.png", "default:jungletree", "wool_blue.png", "wool:blue", default.node_sound_stone_defaults())
lib_furniture.register_chair02_special("chair02" .. "_jungletree" .. "_wool_green", "lib_furniture " .. "Jungle Tree and Green Wool Chair02", "default_jungletree.png", "default:jungletree", "wool_green.png", "wool:green", default.node_sound_stone_defaults())
lib_furniture.register_chair02_special("chair02" .. "_jungletree" .. "_wool_yellow", "lib_furniture " .. "Jungle Tree and Yellow Wool Chair02", "default_jungletree.png", "default:jungletree", "wool_yellow.png", "wool:yellow", default.node_sound_stone_defaults())
lib_furniture.register_chair02_special("chair02" .. "_jungletree" .. "_wool_white", "lib_furniture " .. "Jungle Tree and White Wool Chair02", "default_jungletree.png", "default:jungletree", "wool_white.png", "wool:white", default.node_sound_stone_defaults())



lib_furniture.register_sofa_basic_01_corner_special("sofa_basic_01_corner" .. "_jungletree" .. "_wool_black", "lib_furniture " .. "Jungle Tree and Black Wool sofa_basic_01_corner", "default_jungletree.png", "default:jungletree", "wool_black.png", "wool:black", default.node_sound_stone_defaults())
lib_furniture.register_sofa_basic_01_corner_special("sofa_basic_01_corner" .. "_jungletree" .. "_wool_grey", "lib_furniture " .. "Jungle Tree and Grey Wool sofa_basic_01_corner", "default_jungletree.png", "default:jungletree", "wool_grey.png", "wool:grey", default.node_sound_stone_defaults())
lib_furniture.register_sofa_basic_01_corner_special("sofa_basic_01_corner" .. "_jungletree" .. "_wool_red", "lib_furniture " .. "Jungle Tree and Red Wool sofa_basic_01_corner", "default_jungletree.png", "default:jungletree", "wool_red.png", "wool:red", default.node_sound_stone_defaults())
lib_furniture.register_sofa_basic_01_corner_special("sofa_basic_01_corner" .. "_jungletree" .. "_wool_blue", "lib_furniture " .. "Jungle Tree and Blue Wool sofa_basic_01_corner", "default_jungletree.png", "default:jungletree", "wool_blue.png", "wool:blue", default.node_sound_stone_defaults())
lib_furniture.register_sofa_basic_01_corner_special("sofa_basic_01_corner" .. "_jungletree" .. "_wool_green", "lib_furniture " .. "Jungle Tree and Green Wool sofa_basic_01_corner", "default_jungletree.png", "default:jungletree", "wool_green.png", "wool:green", default.node_sound_stone_defaults())
lib_furniture.register_sofa_basic_01_corner_special("sofa_basic_01_corner" .. "_jungletree" .. "_wool_yellow", "lib_furniture " .. "Jungle Tree and Yellow Wool sofa_basic_01_corner", "default_jungletree.png", "default:jungletree", "wool_yellow.png", "wool:yellow", default.node_sound_stone_defaults())
lib_furniture.register_sofa_basic_01_corner_special("sofa_basic_01_corner" .. "_jungletree" .. "_wool_white", "lib_furniture " .. "Jungle Tree and White Wool sofa_basic_01_corner", "default_jungletree.png", "default:jungletree", "wool_white.png", "wool:white", default.node_sound_stone_defaults())

lib_furniture.register_sofa_basic_01_left_special("sofa_basic_01_left" .. "_jungletree" .. "_wool_black", "lib_furniture " .. "Jungle Tree and Black Wool sofa_basic_01_left", "default_jungletree.png", "default:jungletree", "wool_black.png", "wool:black", default.node_sound_stone_defaults())
lib_furniture.register_sofa_basic_01_left_special("sofa_basic_01_left" .. "_jungletree" .. "_wool_grey", "lib_furniture " .. "Jungle Tree and Grey Wool sofa_basic_01_left", "default_jungletree.png", "default:jungletree", "wool_grey.png", "wool:grey", default.node_sound_stone_defaults())
lib_furniture.register_sofa_basic_01_left_special("sofa_basic_01_left" .. "_jungletree" .. "_wool_red", "lib_furniture " .. "Jungle Tree and Red Wool sofa_basic_01_left", "default_jungletree.png", "default:jungletree", "wool_red.png", "wool:red", default.node_sound_stone_defaults())
lib_furniture.register_sofa_basic_01_left_special("sofa_basic_01_left" .. "_jungletree" .. "_wool_blue", "lib_furniture " .. "Jungle Tree and Blue Wool sofa_basic_01_left", "default_jungletree.png", "default:jungletree", "wool_blue.png", "wool:blue", default.node_sound_stone_defaults())
lib_furniture.register_sofa_basic_01_left_special("sofa_basic_01_left" .. "_jungletree" .. "_wool_green", "lib_furniture " .. "Jungle Tree and Green Wool sofa_basic_01_left", "default_jungletree.png", "default:jungletree", "wool_green.png", "wool:green", default.node_sound_stone_defaults())
lib_furniture.register_sofa_basic_01_left_special("sofa_basic_01_left" .. "_jungletree" .. "_wool_yellow", "lib_furniture " .. "Jungle Tree and Yellow Wool sofa_basic_01_left", "default_jungletree.png", "default:jungletree", "wool_yellow.png", "wool:yellow", default.node_sound_stone_defaults())
lib_furniture.register_sofa_basic_01_left_special("sofa_basic_01_left" .. "_jungletree" .. "_wool_white", "lib_furniture " .. "Jungle Tree and White Wool sofa_basic_01_left", "default_jungletree.png", "default:jungletree", "wool_white.png", "wool:white", default.node_sound_stone_defaults())

lib_furniture.register_sofa_basic_01_right_special("sofa_basic_01_right" .. "_jungletree" .. "_wool_black", "lib_furniture " .. "Jungle Tree and Black Wool sofa_basic_01_right", "default_jungletree.png", "default:jungletree", "wool_black.png", "wool:black", default.node_sound_stone_defaults())
lib_furniture.register_sofa_basic_01_right_special("sofa_basic_01_right" .. "_jungletree" .. "_wool_grey", "lib_furniture " .. "Jungle Tree and Grey Wool sofa_basic_01_right", "default_jungletree.png", "default:jungletree", "wool_grey.png", "wool:grey", default.node_sound_stone_defaults())
lib_furniture.register_sofa_basic_01_right_special("sofa_basic_01_right" .. "_jungletree" .. "_wool_red", "lib_furniture " .. "Jungle Tree and Red Wool sofa_basic_01_right", "default_jungletree.png", "default:jungletree", "wool_red.png", "wool:red", default.node_sound_stone_defaults())
lib_furniture.register_sofa_basic_01_right_special("sofa_basic_01_right" .. "_jungletree" .. "_wool_blue", "lib_furniture " .. "Jungle Tree and Blue Wool sofa_basic_01_right", "default_jungletree.png", "default:jungletree", "wool_blue.png", "wool:blue", default.node_sound_stone_defaults())
lib_furniture.register_sofa_basic_01_right_special("sofa_basic_01_right" .. "_jungletree" .. "_wool_green", "lib_furniture " .. "Jungle Tree and Green Wool sofa_basic_01_right", "default_jungletree.png", "default:jungletree", "wool_green.png", "wool:green", default.node_sound_stone_defaults())
lib_furniture.register_sofa_basic_01_right_special("sofa_basic_01_right" .. "_jungletree" .. "_wool_yellow", "lib_furniture " .. "Jungle Tree and Yellow Wool sofa_basic_01_right", "default_jungletree.png", "default:jungletree", "wool_yellow.png", "wool:yellow", default.node_sound_stone_defaults())
lib_furniture.register_sofa_basic_01_right_special("sofa_basic_01_right" .. "_jungletree" .. "_wool_white", "lib_furniture " .. "Jungle Tree and White Wool sofa_basic_01_right", "default_jungletree.png", "default:jungletree", "wool_white.png", "wool:white", default.node_sound_stone_defaults())

lib_furniture.register_sofa_basic_01_section_special("sofa_basic_01_section" .. "_jungletree" .. "_wool_black", "lib_furniture " .. "Jungle Tree and Black Wool sofa_basic_01_section", "default_jungletree.png", "default:jungletree", "wool_black.png", "wool:black", default.node_sound_stone_defaults())
lib_furniture.register_sofa_basic_01_section_special("sofa_basic_01_section" .. "_jungletree" .. "_wool_grey", "lib_furniture " .. "Jungle Tree and Grey Wool sofa_basic_01_section", "default_jungletree.png", "default:jungletree", "wool_grey.png", "wool:grey", default.node_sound_stone_defaults())
lib_furniture.register_sofa_basic_01_section_special("sofa_basic_01_section" .. "_jungletree" .. "_wool_red", "lib_furniture " .. "Jungle Tree and Red Wool sofa_basic_01_section", "default_jungletree.png", "default:jungletree", "wool_red.png", "wool:red", default.node_sound_stone_defaults())
lib_furniture.register_sofa_basic_01_section_special("sofa_basic_01_section" .. "_jungletree" .. "_wool_blue", "lib_furniture " .. "Jungle Tree and Blue Wool sofa_basic_01_section", "default_jungletree.png", "default:jungletree", "wool_blue.png", "wool:blue", default.node_sound_stone_defaults())
lib_furniture.register_sofa_basic_01_section_special("sofa_basic_01_section" .. "_jungletree" .. "_wool_green", "lib_furniture " .. "Jungle Tree and Green Wool sofa_basic_01_section", "default_jungletree.png", "default:jungletree", "wool_green.png", "wool:green", default.node_sound_stone_defaults())
lib_furniture.register_sofa_basic_01_section_special("sofa_basic_01_section" .. "_jungletree" .. "_wool_yellow", "lib_furniture " .. "Jungle Tree and Yellow Wool sofa_basic_01_section", "default_jungletree.png", "default:jungletree", "wool_yellow.png", "wool:yellow", default.node_sound_stone_defaults())
lib_furniture.register_sofa_basic_01_section_special("sofa_basic_01_section" .. "_jungletree" .. "_wool_white", "lib_furniture " .. "Jungle Tree and White Wool sofa_basic_01_section", "default_jungletree.png", "default:jungletree", "wool_white.png", "wool:white", default.node_sound_stone_defaults())













