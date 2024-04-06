--if vim.g.snippets ~= "luasnip" or not pcall(require, "luasnip") then
--  return
--end

local ls = require("luasnip")
local types = require("luasnip.util.types")
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep
local s = ls.snippet
local t = ls.text_node
local f = ls.function_node
local i = ls.insert_node
local c = ls.choice_node
local r = ls.restore_node
local sn = ls.snippet_node

local urandom = assert(io.open("/dev/urandom", "rb"))

ls.config.set_config {
  -- This tells LuaSnip to remember to keep around the last snippet.
  -- You can jump back into it even if you move outside of the selection
  history = true,

  -- This one is cool cause if you have dynamic snippets, it updates as you type!
  updateevents = "TextChanged,TextChangedI",

  -- Autosnippets:
  enable_autosnippets = true,

  -- Crazy highlights!!
  -- #vid3
  -- ext_opts = nil,
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { " <- Current Choice", "NonTest" } },
      },
    },
  },
}


local function uuid4()
    local block = urandom:read(16)
    return string.format("%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x",
        block:byte(1), block:byte(2), block:byte(3), block:byte(4), block:byte(5), block:byte(6),
        (block:byte(7) / 16) + 64, block:byte(8), (block:byte(9) / 4) + 128, block:byte(10), block:byte(11, 16))
end

ls.add_snippets("python", {
    s("pay_action", {
        unpack(fmt([[
            from {}.core.actions.base import {}


            class {}Action({}):
                def __init__(self):
                    super().__init__()

                async def handle(self) -> None:
                    return None
        ]],
        {
            i(1, "module"),
            i(2, "ActionClass"),
            i(3, "ClassName"),
            rep(2)
        }))
    }),
})

ls.add_snippets("all", {
    s("uuid4", {
        f(uuid4)
    }),
    s("todo", {
        t("# TODO: "),
        f(function() return os.date("%Y-%m-%d") end),
        t(" @perseus "),
        i(0),
    }),
    s("note", {
        t("# NOTE: "),
        f(function() return os.date("%Y-%m-%d") end),
        t(" @perseus "),
        i(0),
    }),
})
