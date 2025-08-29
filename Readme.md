For mac 
- install nerd font from https://github.com/epk/SF-Mono-Nerd-Font
- brew install npm (for mason)

mason installs:
- pyright
    - will not install without first running apt install python3-venv
- debugpy?
- clangd
- clang-format 


To debug cpp files:
- compile using dubug flags (`clang++ --debug main.cpp -o main`)
- run the debugger and enter `main` when prompted for the executable path
