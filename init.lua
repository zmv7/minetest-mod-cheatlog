local lastcheat = {}
minetest.register_on_cheat(function(player, cheat)
	local name = player and player:get_player_name()
	if not (name and cheat and cheat.type) then return end
	if cheat.type == "interacted_while_dead" then
		player:respawn()
	end
	if not lastcheat[name] then
		lastcheat[name] = {}
	end
	if lastcheat[name].cheat ~= cheat.type then
		lastcheat[name].cheat = cheat.type
		lastcheat[name].count = 1
		local pos = player:get_pos()
		local msg = "[cheatlog] "..name.." "..cheat.type.." at "..minetest.pos_to_string(vector.round(pos))
		minetest.log("warning", msg)
	elseif lastcheat[name].time and os.time() - lastcheat[name].time < 10 then
		lastcheat[name].count = lastcheat[name].count + 1
		if lastcheat[name].count % 10 == 0 then
			local msg = "[cheatlog] "..name.." "..cheat.type.." for "..
				tostring(lastcheat[name].count).." times in a row!"
			minetest.log("warning", msg)
		end
		if lastcheat[name].count > 30 then
			minetest.kick_player(name, "You have been suspected in cheating: '"..cheat.type..
				"'. If it's wrong, please conctact the staff.")
		end
	else
		lastcheat[name].count = 1
	end
	lastcheat[name].time = os.time()
end)
minetest.register_on_leaveplayer(function(player)
	local name = player and player:get_player_name()
	if name then
		lastcheat[name] = nil
	end
end)
