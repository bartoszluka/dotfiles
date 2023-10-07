_G.cmd = function(command)
    return "<cmd>" .. command .. "<CR>"
end

require("my.plugins")
require("my.autocommands")
require("my.settings")
require("my.keymaps")
require("my.commands")
