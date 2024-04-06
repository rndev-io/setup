scan = require('plenary.scandir')

local M = {}

function M.yandex_project_path()
    local projects = {
        "billing/yandex_pay_plus",
        "pay/lib",
        "pay/cashback",
        "billing/yandex_pay",
        "billing/yandex_pay_admin"
    }
    local arcadia = os.getenv("ARCADIA")
    local cwd = vim.fn.getcwd() .. "/"
    for _, prj in pairs(projects) do
        local prj_path = string.format("%s/%s", arcadia, prj)
        if string.find(cwd, prj_path .. "/") then
            return prj_path
        end
    end
end

function M.python_path()
    local yandex_project = M.yandex_project_path()
    if yandex_project then
        return string.format("%s/python/python", yandex_project)
    else
        return "/usr/bin/python"
    end
end

function M.tests_path(type)
    type = type or ''
    local yandex_project = M.yandex_project_path()
    if yandex_project then
        local test_path = scan.scan_dir(yandex_project, {only_dirs=true, search_pattern='.*tests$'})[1]
        if test_path then
            return string.format("%s/%s", test_path, type)
        else
            return ""
        end
    else
        return ""
    end
end

function vim.getVisualSelection()
	vim.cmd('noau normal! "vy"')
	local text = vim.fn.getreg('v')
	vim.fn.setreg('v', {})

	text = string.gsub(text, "\n", "")
	if #text > 0 then
		return text
	else
		return ''
	end
end

function M.nvim_create_augroups(definitions)
    for group_name, definition in pairs(definitions) do
        vim.api.nvim_command('augroup '..group_name)
        vim.api.nvim_command('autocmd!')
        for _, def in ipairs(definition) do
            local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
            vim.api.nvim_command(command)
        end
        vim.api.nvim_command('augroup END')
    end
end

return M
