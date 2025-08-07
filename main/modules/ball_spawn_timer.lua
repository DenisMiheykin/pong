local M = {}

function M.new(delay, ball_pos)
	local currentID = 0
	local state = {
		balls = {}
	}

	local function spawn_ball()
		currentID = currentID + 1
		state.balls[currentID] = factory.create("ball_factory#factory", ball_pos, nil, { ball_id = currentID })
	end

	state.start = function()
		if state.timer ~= nil then
			timer.cancel(state.timer)
		end
		spawn_ball()
		state.timer = timer.delay(delay, true, spawn_ball)
	end

	state.out_of_bounds = function(ball_id)
		if state.balls[ball_id] ~= nil then
			print("state.out_of_bounds", ball_id)
			go.delete(state.balls[ball_id])
			state.balls[ball_id] = nil
		end
	end

	state.cancel = function()
		if state.timer ~= nil then
			timer.cancel(state.timer)
		end

		for _, ball in pairs(state.balls) do
			go.delete(ball)
		end
		state.ball = {}
	end

	return state
end

return M