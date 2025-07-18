return ({
    -- NOTE: For recovering from undo mistakes and managing undo branches
    {
	"mbbill/undotree",
	keys = {
	    { "<leader>tu", "<cmd>UndotreeToggle<cr>", desc = "UndoTree" }
	}
    },
})
