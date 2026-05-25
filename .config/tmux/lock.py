import sys
import termios
import subprocess
import shutil

def verify_password(password):
    try:
        result = subprocess.run(
            ['sudo', '-S', '-k', 'true'],
            input=password + '\n',
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            text=True
        )
        return result.returncode == 0
    except Exception:
        return False

ANSI_ESC = chr(27) + chr(91)

def enter_alternate_buffer():
    sys.stdout.write(f"{ANSI_ESC}?1049h");
    sys.stdout.write(f"{ANSI_ESC}2J");
    sys.stdout.flush();

def exit_alternate_buffer():
    sys.stdout.write(f"{ANSI_ESC}2J")
    sys.stdout.write(f"{ANSI_ESC}?1049l")
    sys.stdout.flush()

def set_cursor_visible(visible):
    sys.stdout.write(f"{ANSI_ESC}?25{'h' if visible else 'l'}")
    sys.stdout.flush()

def print_centered(text):
    cols, rows = shutil.get_terminal_size()
    x = (cols - len(text)) // 2 + 1
    y = rows // 2 + 1
    sys.stdout.write(f"{ANSI_ESC}{y};{x}H{text}")
    sys.stdout.flush()

def setup_termios():
    old_attrs = termios.tcgetattr(0)
    new_attrs = old_attrs.copy()
    new_attrs[3] &= ~termios.ECHO
    termios.tcsetattr(0, termios.TCSADRAIN, new_attrs)
    return old_attrs

def restore_termios(old_attrs):
    termios.tcsetattr(0, termios.TCSADRAIN, old_attrs)

def main(restore=False):
    old_attrs = setup_termios()
    enter_alternate_buffer()
    set_cursor_visible(False)
    print_centered("LOCKED")
    while True:
        try:
            if verify_password(input("")):
                break
        except:
            pass
    if restore:
        exit_alternate_buffer()
        set_cursor_visible(True)
        restore_termios(old_attrs)

if __name__ == "__main__":
    main(sys.argv.pop() != "--no-restore")
