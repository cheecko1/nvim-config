For mac 
- install nerd font from https://github.com/epk/SF-Mono-Nerd-Font
- brew install npm (for mason)
- `brew install ripgrep` for live grep telescope features
- `brew install fd` for quicker finding
- alt+arrow keyboard actions need to be turned off in settings for window resizing to work

mason installs:
- pyright
    - will not install without first running apt install python3-venv
- debugpy?
- clangd
- clang-format 


To debug cpp files:
- compile using dubug flags (`clang++ --debug main.cpp -o main`)
- run the debugger and enter `main` when prompted for the executable path

For STM32:
- install cpptools 

to fix bear creating empty file
```
# Find Bear’s wrapper directory (typical for brew)
BREW_PREFIX=$(brew --prefix bear)
cd "$BREW_PREFIX/lib/bear/wrapper.d"

# Create wrappers for the cross-compilers you use
ln -s ../wrapper arm-none-eabi-gcc
ln -s ../wrapper arm-none-eabi-g++
```

TODO:
- [x] terminate active debug session when programming STM
- [x] set up code completion for c
- [ ] automatically suspend watchdog timers when halted
- [x] set default wrap lines to off
- [ ] automatically create compile commands on build
    - can't do on every build because it only complies things that have been changed so replaces the file with an empty one
    - the command tha needs to be run is `bear --output ./Debug/compile_commands.json -- make all -C Debug/`
- [ ] save files on mB
- [x] quickfix
    - [x] diagnostic quickfix shortcut
    - [x] todo list quickfix shortcut
    - [x] quickfix open, next, previous shortcuts
- [ ] make STM debug profile generalise to different project names
- [ ] work out how the makefile is generated
