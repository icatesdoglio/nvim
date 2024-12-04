local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local fmt = require("luasnip.extras.fmt").fmt

local rep = require("luasnip.extras").rep

ls.add_snippets = { "lua", {
	s({ trig = "hello" }, {
		t("-- this is what was expanded"),
	}),
} }
--python = {
--	s("pr", fmt("def {}(self, date: pd.DatetimeIndex, agglevel: str) -> pd.Series:", { i(1), "default" })),
--},

-- vim: ts=2 sts=2 sw=2 et
--
