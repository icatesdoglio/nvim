local ls = require("luasnip")

local s = ls.s

local fmt = require("luasnip.extras.fmt").fmt

local i = ls.insert_node

local rep = require("luasnip.extras").rep

ls.snippets = {
	python = {
		s("pr", fmt("def {}(self, date: pd.DatetimeIndex, agglevel: str) -> pd.Series:", { i(1), "default" })),
	},
}
