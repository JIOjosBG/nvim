-- Derives a stable accent color from the current project root, so each project
-- is instantly recognizable by the color of the statusline.
local M = {}

-- h in [0,360), s and l in [0,1]
local function hsl_to_hex(h, s, l)
	local function channel(n)
		local k = (n + h / 30) % 12
		local a = s * math.min(l, 1 - l)
		local c = l - a * math.max(-1, math.min(k - 3, 9 - k, 1))
		return math.floor(c * 255 + 0.5)
	end
	return string.format("#%02x%02x%02x", channel(0), channel(8), channel(4))
end

function M.root()
	return vim.fs.root(0, { ".git" }) or vim.fn.getcwd()
end

function M.name()
	return vim.fs.basename(M.root())
end

-- Continuous hue rather than a fixed palette, so two projects rarely collide.
function M.color(path)
	local hash = vim.fn.sha256(path or M.root())
	local hue = tonumber(hash:sub(1, 8), 16) % 360
	return hsl_to_hex(hue, 0.55, 0.55)
end

return M
