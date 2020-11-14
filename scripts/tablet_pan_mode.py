import math
import time

from evdev import InputDevice, UInput, ecodes

mouse = InputDevice("/dev/input/event25")
pen = InputDevice("/dev/input/event5")
keyboard = InputDevice("/dev/input/event4")
ui = UInput.from_device(mouse, name="virtual-mouse-device")

last_x, last_y = None, None
start_x, start_y = None, None
scroll_button_down = False

INVERT = True
MIN_MOVEMENT = 1
X_MULTIPLIER = 0.040
Y_MULTIPLIER = 0.030
DELAY = 0.025


def initialize():
    # TODO Get sway socket
    # TODO Exec swaymsg --socket $SWAYSOCK input 1:1:virtual-mouse-device scroll_factor 1.0
    # TODO Exec swaymsg --socket $SWAYSOCK input 1:1:virtual-mouse-device scroll_method on_button_down
    # TODO Exec swaymsg --socket $SWAYSOCK input 1:1:virtual-mouse-device scroll_button BTN_SIDE
    ...


def get_multiplier(axis):
    if axis == ecodes.REL_X:
        return X_MULTIPLIER
    elif axis == ecodes.REL_Y:
        return Y_MULTIPLIER


def move(axis, movement):
    if INVERT:
        movement = -movement

    if movement < 0:
        movement = math.ceil(movement * get_multiplier(axis))
    elif movement > 0:
        movement = math.floor(movement * get_multiplier(axis))

    ui.write(ecodes.EV_REL, axis, movement)
    ui.syn()


while True:
    if (
        ecodes.BTN_TOOL_PEN in pen.active_keys()
        and ecodes.KEY_CAPSLOCK in keyboard.active_keys()
    ):
        if not last_x and not last_y:
            last_x = pen.absinfo(ecodes.ABS_X).value
            last_y = pen.absinfo(ecodes.ABS_Y).value

        if not scroll_button_down:
            scroll_button_down = True
            ui.write(ecodes.EV_KEY, ecodes.BTN_SIDE, 1)
            ui.syn()

        x_info = pen.absinfo(ecodes.ABS_X)
        y_info = pen.absinfo(ecodes.ABS_Y)
        diff_x = x_info.value - last_x
        diff_y = y_info.value - last_y
        move(ecodes.REL_X, diff_x)
        move(ecodes.REL_Y, diff_y)

        last_x = x_info.value
        last_y = y_info.value

        ui.syn()
    else:
        last_x = None
        last_y = None

        if scroll_button_down:
            scroll_button_down = False
            ui.write(ecodes.EV_KEY, ecodes.BTN_SIDE, 0)
            ui.syn()

    time.sleep(DELAY)
