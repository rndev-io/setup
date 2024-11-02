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


local function uuid4()
    local urandom = assert(io.open("/dev/urandom", "rb"))
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
    s("pay_test_file", {
        unpack(fmt([[
            import pytest
            from hamcrest import anything, assert_that, equal_to, match_equality

            @pytest.mark.asyncio
            async def test_{}():
                pass
        ]],
            {
                i(1, 'some_test_name'),
            }))
    }),
    s("pay_test", {
        unpack(fmt([[
            @pytest.mark.asyncio
            async def test_{}():
                pass
        ]],
            {
                i(1, 'some_test_name'),
            }))
    })
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
