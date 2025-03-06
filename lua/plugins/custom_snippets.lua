local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local fmt = require("luasnip.extras.fmt").fmt

local rep = require("luasnip.extras").rep

ls.add_snippets("all", {
	s({ trig = "trig" }, { t("This is a test snippet"), i(1, "Insert text here") }),
	s({ trig = vim }, { t("vim: ts=2 sts=2 sw=2 et") }),
})

ls.add_snippets("python", {
	s(
		{ trig = "pr" },
		fmt(
			[[
    def {n1} (self, date: pd.DatetimeIndex) -> pd.Series:   
        """{n2}"""
        {n3}
        return {n0}
    ]],
			{
				n1 = i(1, "funcName"),
				n2 = i(2, "docString"),
				n3 = i(3, "body"),
				n0 = i(0, "pd.Series"),
			}
		)
	),
})
-- vim: ts=2 sts=2 sw=2 et
