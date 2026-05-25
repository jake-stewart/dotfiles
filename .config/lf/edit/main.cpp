#include <string>
#include <vector>
#include "unistd.h"

std::string tolower(std::string s) {
    for (int i = 0; i < s.length(); i++) {
        s[i] = std::tolower(s[i]);
    }
    return s;
}

int main(int argc, char **argv) {
    if (argc <= 1) {
        return 0;
    }
    std::string lowerName = tolower(argv[1]);
    if (lowerName.ends_with(".png")
        || lowerName.ends_with(".jpg")
        || lowerName.ends_with(".jpeg")
    ) {
        std::vector<const char*> args;
        const char *path = "/Users/jakey/.config/tmux/popup-image.py";
        args.push_back(path);
        args.push_back("popup");
        args.push_back(argv[1]);
        return execvp(path, (char**)args.data());
    }
    else {
        fprintf(stderr, "\x1b[?1049h\x1b[2J\n");
        fflush(stderr);
        std::vector<const char*> args;
        args.push_back("nvim");
        args.push_back(argv[1]);
        return execvp("nvim", (char**)args.data());
    }
}

