#!/usr/bin/env python3

from pynput import keyboard
import time
import clipboard

VK_LOOKUP = {
    "a":  0,  "s": 1,  "d": 2,  "f": 3,  "h": 4,  "g": 5,  "z": 6,  "x": 7,
    "c":  8,  "v": 9,  "b": 11, "q": 12, "w": 13, "e": 14, "r": 15, "y": 16,
    "t":  17, "1": 18, "2": 19, "3": 20, "4": 21, "6": 22, "5": 23, "=": 24,
    "9":  25, "7": 26, "-": 27, "8": 28, "0": 29, "]": 30, "o": 31, "u": 32,
    "[":  33, "i": 34, "p": 35, "l": 37, "j": 38, "'": 39, "k": 40, ";": 41,
    "\\": 42, ",": 43, "/": 44, "n": 45, "m": 46, ".": 47, "`": 50
}
UPPER_VK_LOOKUP = {
    "A":  0,  "S": 1,  "D": 2,  "F": 3,  "H": 4,  "G": 5,  "Z": 6,  "X": 7,
    "C":  8,  "V": 9,  "B": 11, "Q": 12, "W": 13, "E": 14, "R": 15, "Y": 16,
    "T":  17, "!": 18, "@": 19, "#": 20, "$": 21, "^": 22, "%": 23, "+": 24,
    "(":  25, "&": 26, "_": 27, "*": 28, ")": 29, "}": 30, "O": 31, "U": 32,
    "{":  33, "I": 34, "P": 35, "L": 37, "J": 38, '"': 39, "K": 40, ":": 41,
    "|": 42, "<": 43, "?": 44, "N": 45, "M": 46, ">": 47, "~": 50
    }

time.sleep(1)


def typeSlowly(string, delayPerChar=0.001):
    for char in string:
        if 32 < ord(char) <= 127:
            if char in UPPER_VK_LOOKUP:
                vk = UPPER_VK_LOOKUP[char]
                controller.press(keyboard.Key.shift_l)
                controller.press(keyboard.KeyCode.from_vk(vk))
                controller.release(keyboard.KeyCode.from_vk(vk))
                controller.release(keyboard.Key.shift_l)
            elif char in VK_LOOKUP:
                vk = VK_LOOKUP[char]
                controller.press(keyboard.KeyCode.from_vk(vk))
                controller.release(keyboard.KeyCode.from_vk(vk))
        elif char == " ":
            controller.press(keyboard.Key.space)
            controller.release(keyboard.Key.space)
        elif char == "\n":
            controller.press(keyboard.Key.enter)
            controller.release(keyboard.Key.enter)
        elif char == "\t":
            controller.press(keyboard.Key.tab)
            controller.release(keyboard.Key.tab)
        time.sleep(delayPerChar)

controller = keyboard.Controller();
contents = clipboard.paste();
typeSlowly(contents);
