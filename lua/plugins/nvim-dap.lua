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

			-- Functions
			-- floating terminal window
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

			-- function to find elf files
			local function find_elf(dir_name) -- pass in name of directory to search in
				dir_name = dir_name or "Debug" -- defaults to Debug

				local search_dir = vim.fn.getcwd() .. "/" .. dir_name
				local handle = vim.loop.fs_scandir(search_dir)

				if not handle then
					return nil, "Directory not found: " .. search_dir
				end

				local elf_files = {}

				while true do
					local name, t = vim.loop.fs_scandir_next(handle)
					if not name then break end

					if t == "file" and name:sub(-4) == ".elf" then
						table.insert(elf_files, search_dir .. "/" .. name)
					end
				end

				if #elf_files == 0 then
					return nil, "No .elf files found in " .. search_dir
				end

				if #elf_files > 1 then
					return nil, "Multiple .elf files found:\n" .. table.concat(elf_files, "\n")
				end

				return elf_files[1]
			end


			-- Start ST-Link gdb server when debug session starts
			dap.listeners.on_config["stlink_autostart"] = function(config) -- runs just before debug session starts (after it's configured with any user input)
				-- Simple debug trace to confirm it runs
				-- print("hello from on_config")

				if config.type == "cppdbg" then -- Only run for cppdbg configs
					vim.fn.jobstart({ -- start asyncronous gdb server process
						"ST-LINK_gdbserver",
						"-d", "-v", "-t",
						"-p", "61234", -- make sure this matches miDebuggerServerAddress
						"-cp", "/opt/ST/STM32CubeCLT_1.19.0/STM32CubeProgrammer/bin",
					}, { detach = true }) -- neovim won't manage or kill process, it will keep running even if neovim exits

					-- Give the server a moment to come up before cppdbg / gdb try to connect
					vim.wait(1000) -- increase to 2000 if still flaky
				end

				-- IMPORTANT: on_config *must* return a config
				return config
			end

			-- Start pico openocd gdb server when debug session starts
			dap.listeners.on_config["pico_autostart"] = function(config) -- runs just before debug session starts (after it's configured with any user input)
				-- Simple debug trace to confirm it runs
				print("hello from pico on_config")

				if config.type == "cppdbg" then -- Only run for cppdbg configs
					print ("starting gdb server")
					vim.fn.jobstart({ -- start asyncronous gdb server process
						"openocd",
						"-f", "interface/cmsis-dap.cfg",
						"-f", "target/rp2350.cfg", -- will have to change if using rp2040
						"-c", "adapter speed 5000",
--						"-c", "program build/HelloWorld.elf verify reset",
					}, { detach = false}) -- process will terminate when neovim closes

					-- Give the server a moment to come up before cppdbg / gdb try to connect
					vim.wait(2000) -- increase if still flaky
					print("done")
				end

				-- IMPORTANT: on_config *must* return a config
				return config
			end

			-- STM debug configuration option
			dap.configurations.c = {
				{
					name = "Debug STM32", -- name in options
					type = "cppdbg", -- must match an adapter defined in dap.adapters
					request = "launch",
					cwd = "${workspaceFolder}",
					program = function() -- vibe coded function to find .elf files
						local elf, err = find_elf("Debug")
						if not elf then
							vim.notify(err, vim.log.levels.ERROR)
							return nil
						end
						return elf
					end,
					stopAtEntry = false,
					MIMode = "gdb",
					miDebuggerServerAddress = "localhost:61234",
					miDebuggerPath =
					"/opt/ST/STM32CubeCLT_1.19.0/GNU-tools-for-STM32/bin/arm-none-eabi-gdb",
				},
			}

			-- Pico debug configuration option
			dap.configurations.c = {
				{
					name = "Debug Pi Pico", -- name in options
					type = "cppdbg", -- must match an adapter defined in dap.adapters
					request = "launch",
					cwd = "${workspaceFolder}",
					program = function() -- vibe coded function to find .elf files
						local elf, err = find_elf("build")
						if not elf then
							vim.notify(err, vim.log.levels.ERROR)
							return nil
						end
						return elf
					end,
					stopAtEntry = false,
					MIMode = "gdb",
					miDebuggerServerAddress = "localhost:3333",
					miDebuggerPath = "gdb",
					postRemoteConnectCommands = {
						{ text = "monitor reset init" },
						{ text = "load" }, -- program the board
					},
				},
			}
			dap.configurations.cpp = dap.configurations.c

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

			-- STM programming keymaps
			vim.keymap.set("n", "<leader>mb", function()
				--float_term("make all -C Debug")
				float_term("cmake -S . -B Debug -DCMAKE_TOOLCHAIN_FILE=cmake/gcc-arm-none-eabi.cmake && cmake --build Debug")
			end, opts)

			vim.keymap.set("n", "<leader>mp", function()
				dap.terminate()

				local elf, err = find_elf("Debug")
				if not elf then
					vim.notify(err, vim.log.levels.ERROR)
					return
				end

				float_term("STM32_Programmer_CLI -c port=SWD -w " .. elf)
			end, opts)

			vim.keymap.set("n", "<leader>mB", function()
				vim.cmd("wall") -- Save all modified buffers
				dap.terminate() -- Terminate debug session if running

				-- Build and flash STM32

				local elf, err = find_elf("Debug")
				if not elf then
					vim.notify(err, vim.log.levels.ERROR)
					return
				end

				--float_term("make all -C Debug && STM32_Programmer_CLI -c port=SWD -w " .. elf)
				float_term("cmake -S . -B Debug -DCMAKE_TOOLCHAIN_FILE=cmake/gcc-arm-none-eabi.cmake && cmake --build Debug && STM32_Programmer_CLI -c port=SWD -w " .. elf)
			end, opts)

			vim.keymap.set("n", "<leader>pb", function()
				vim.cmd("wall") -- Save all modified buffers
				dap.terminate() -- Terminate debug session if running

				float_term("cmake -S . -B build && cmake --build build") 
			end, opts)
		end,
	},
}
