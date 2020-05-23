#!/bin/python3

from i3ipc.aio import Connection
from i3ipc import Event
import time
import asyncio


async def create_workspace(conn, ws_num, ws_name):
    await conn.command(f"workspace {ws_num}")
    await conn.command(f"rename workspace to {ws_num} · {ws_name}")


async def launch_app(conn, app_name):
    def on_new_window(self, e):
        self.locked = False

    conn.locked = True
    conn.on(Event.WINDOW_NEW, on_new_window)
    timing = time.time()
    await conn.command(f"exec {app_name}")

    while conn.locked:
        await asyncio.sleep(.1)

    _timing = time.time() - timing
    print(f"({_timing:.4f}s) Launched {app_name}")


async def main():
    working_dir = "~/git"

    conn = await Connection().connect()
    conn.locked = False
    
    await create_workspace(conn, 4, "dev")
    await conn.command("gaps outer current set 0")
    await launch_app(conn, "firejail --private=~/firejails/firefox-dev firefox --no-remote")
    await launch_app(conn, f"alacritty --working-directory {working_dir}")
    await launch_app(conn, "~/git/dotfiles/scripts/vimwiki-dark")
    await conn.command("splitv")
    await launch_app(conn, f"alacritty --working-directory {working_dir}")
    await conn.command("resize set height 30 ppt")
    await launch_app(conn, f"alacritty --title backend --working-directory {working_dir}")
    await conn.command("splith")
    await launch_app(conn, f"alacritty --title frontend --working-directory {working_dir}")
    await conn.command("layout tabbed")
    await conn.command("resize set height 15 ppt")
    await conn.command("focus left")
    await conn.command("focus up")
    await conn.command("focus left")

asyncio.get_event_loop().run_until_complete(main())
