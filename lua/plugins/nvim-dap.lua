return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"rcarriga/nvim-dap-ui",
			--"mfussenegger/nvim-dap-python",
			"theHamsta/nvim-dap-virtual-text",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			--local dap_python = require("dap-python")
			local vt = require("nvim-dap-virtual-text")

			require("dapui").setup({})
			vt.setup({
				commented = true, -- Show virtual text alongside comment
			})

			-- STM32
			dap.listeners.on_config["stlink_autostart"] = function(config)
				-- Simple debug trace to confirm it runs
				--print("hello from on_config")

				-- Only for cppdbg configs
				if config.type == "cppdbg" then
					vim.fn.jobstart({
						"ST-LINK_gdbserver",
						"-d", "-v", "-t",
						"-p", "61234", -- make sure this matches miDebuggerServerAddress
						"-cp", "/opt/ST/STM32CubeCLT_1.19.0/STM32CubeProgrammer/bin",
					}, { detach = true })

					-- Give the server a moment to come up before cppdbg / gdb try to connect
					vim.wait(1000) -- increase to 2000 if still flaky
				end

				-- IMPORTANT: on_config *must* return a config
				return config
			end
			dap.configurations.c = {
				{
					name = "Debug STM32",
					type = "cppdbg", -- must match an adapter defined in dap.adapters
					request = "launch",
					cwd = "${workspaceFolder}",
					program = "${workspaceFolder}/Debug/OOPCB_STM.elf",
					stopAtEntry = false,
					MIMode = "gdb",
					miDebuggerServerAddress = "localhost:61234",
					miDebuggerPath =
					"/opt/ST/STM32CubeCLT_1.19.0/GNU-tools-for-STM32/bin/arm-none-eabi-gdb",
				},
			}

			-- turn on diagnostics for all languages (makes it work for rust)
			vim.diagnostic.config { virtual_text = true }

			--dap_python.setup("python3")

			-- Symbols
			vim.fn.sign_define("DapBreakpoint", {
				text = "",
				texthl = "DiagnosticSignError",
				linehl = "",
				numhl = "",
			})

			vim.fn.sign_define("DapBreakpointRejected", {
				text = "", -- or "❌"
				texthl = "DiagnosticSignError",
				linehl = "",
				numhl = "",
			})

			vim.fn.sign_define("DapStopped", {
				text = "", -- or "→"
				texthl = "DiagnosticSignWarn",
				linehl = "Visual",
				numhl = "DiagnosticSignWarn",
			})

			-- Automatically open/close DAP UI
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end

			dap.listeners.before.event_terminated["dapui_config"] = function()
				vim.notify("DAP session terminated")
				dapui.close()
				-- Run refresh AFTER DAP has finished cleaning up — fixes needing "two refreshes"
				vim.schedule(function()
					vt.refresh()
				end)
			end

			dap.listeners.before.event_exited["dapui_config"] = function()
				vim.notify("DAP session terminated")
				dapui.close()
				-- Run refresh AFTER DAP has finished cleaning up — fixes needing "two refreshes"
				vim.schedule(function()
					vt.refresh()
				end)
			end

			dap.listeners.before.disconnect["dapui_config"] = function()
				vim.notify("DAP session terminated")
				dapui.close()
				-- Run refresh AFTER DAP has finished cleaning up — fixes needing "two refreshes"
				vim.schedule(function()
					vt.refresh()
				end)
			end

			-- Keymaps
			local opts = { noremap = true, silent = true }

			-- Toggle breakpoint
			vim.keymap.set("n", "<leader>db", function()
				dap.toggle_breakpoint()
			end, opts)

			-- Continue / Start
			vim.keymap.set("n", "<leader>dc", function()
				dap.continue()
			end, opts)

			-- Step Over
			vim.keymap.set("n", "<leader>do", function()
				dap.step_over()
			end, opts)

			-- Step Into
			vim.keymap.set("n", "<leader>di", function()
				dap.step_into()
			end, opts)

			-- Step Out
			vim.keymap.set("n", "<leader>dO", function()
				dap.step_out()
			end, opts)

			-- Restart
			vim.keymap.set("n", "<leader>dr", function()
				dap.restart()
			end, opts)

			-- Keymap to terminate debugging
			vim.keymap.set("n", "<leader>dT", function()
				dap.terminate()
				--dapui.close()
				--require('nvim-dap-virtual-text').refresh()
			end, opts)

			-- Toggle DAP UI
			vim.keymap.set("n", "<leader>du", function()
				dapui.toggle()
			end, opts)

			-- Run to cursor
			vim.keymap.set("n", "<leader>dC", function()
				dap.run_to_cursor()
			end, opts)


			local function float_term(cmd)
				local buf = vim.api.nvim_create_buf(false, true)
				local width = math.floor(vim.o.columns * 0.7)
				local height = math.floor(vim.o.lines * 0.7)

				local win = vim.api.nvim_open_win(buf, true, {
					relative = "editor",
					style = "minimal",
					border = "rounded",
					width = width,
					height = height,
					row = (vim.o.lines - height) * 0.5,
					col = (vim.o.columns - width) * 0.5,
				})

				vim.fn.termopen(cmd)
				vim.cmd("startinsert")
			end

			vim.keymap.set("n", "<leader>mb", function()
				float_term("make all -C Debug")
				--float_term("bear --output ./Debug/compile_commands.json -- make all -C Debug")
			end, opts)

			vim.keymap.set("n", "<leader>mp", function()
				dap.terminate()
				float_term("STM32_Programmer_CLI -c port=SWD -w ./Debug/OOPCB_STM.elf")
			end, opts)

			vim.keymap.set("n", "<leader>mB", function()
				-- Save all modified buffers
				vim.cmd("wall")

				-- Terminate debug session if running
				dap.terminate()

				-- Build and flash STM32
				float_term("make all -C Debug && STM32_Programmer_CLI -c port=SWD -w ./Debug/OOPCB_STM.elf")
			end, opts)
		end,
	},
}
