local lastcheats = {}
minetest.register_on_cheat(function(player, cheat)
	local name = player and player:get_player_name()
	if not (name and cheat and cheat.type) then return end
	local ct = cheat.type
	if ct == "interacted_while_dead" then
		player:respawn()
	end
	if not lastcheats[name] then
		lastcheats[name] = {}
	end
	local lc = lastcheats[name]
	if not lc[ct] then
		lc[ct] = {
			count = 1,
			time = os.time()
		}
	end
	local pos = player:get_pos()
	if lc[ct].time and os.time() - lc[ct].time < 10 then
		lc[ct].count = lc[ct].count + 1
		if lc[ct].count % 10 == 0 then
			local msg = "[cheatlog] "..name.." "..ct.." for "..
				tostring(lc[ct].count).." times in a row at "..minetest.pos_to_string(vector.round(pos))
			minetest.log("warning", msg)
		end
		if lc[ct].count > 30 then
			minetest.kick_player(name, "You have been suspected in cheating: '"..ct..
				"'. If it's wrong, please conctact the staff.")
		end
	else
		lc[ct].count = 1
	end
	lc[ct].time = os.time()
end)
minetest.register_on_leaveplayer(function(player)
	local name = player and player:get_player_name()
	if name then
		lastcheats[name] = nil
	end
end)
