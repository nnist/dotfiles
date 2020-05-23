#!/bin/python3

from i3ipc.aio import Connection
from i3ipc import Event
import time
import asyncio
import argparse
import subprocess
import logging as log
import sys
import os
import argparse

PROFILES = ["web-dev", "dev"]

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
    log.info(f"({_timing:.4f}s) Launched {app_name}")


async def workspace_web_dev(conn, ws_num, ws_name, working_dir):
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

async def create_workspace(ws_num, ws_name, working_dir, profile):
    conn = await Connection().connect()
    conn.locked = False
    
    # Create workspace
    await conn.command(f"workspace {ws_num}")

    if ws_name:
        await conn.command(f"rename workspace to {ws_num} · {ws_name}")

    if profile == "web-dev":
        await workspace_web_dev(conn, ws_num, ws_name, working_dir)
    else:
        raise Exception("Unknown profile!")


def main(argv):
    """Create i3/sway workspaces."""
    parser = argparse.ArgumentParser(
        description="""Create an i3/sway workspace."""
    )
    parser.add_argument(
        '-v', '--verbose', help="verbose mode", action='store_true'
    )
    parser.add_argument(
        '--num', help="workspace number", type=int, default=0
    )
    parser.add_argument(
        '-n', '--name', help="workspace name", type=str
    )
    parser.add_argument(
        '-d', '--dir', help="workspace working directory", type=str, default="~/git"
    )
    parser.add_argument(
        '-l', '--list', help="list workspace profiles", action='store_true'
    )
    parser.add_argument(
        '-p', '--profile', help="workspace profile", type=str
    )
    args = parser.parse_args(argv)

    if args.list:
        print("\n".join(PROFILES))
        sys.exit(0)

    if args.verbose:
        log.basicConfig(format="%(levelname)s: %(message)s", level=log.INFO)
        log.info("Verbose output.")
    else:
        log.basicConfig(format="%(levelname)s: %(message)s")

    ws_num = args.num
    ws_name = args.name
    asyncio.get_event_loop().run_until_complete(create_workspace(ws_num, ws_name, args.dir, args.profile))


if __name__ == "__main__":
    try:
        main(sys.argv[1:])
    except KeyboardInterrupt:
        print('Interrupted by user.')
        try:
            sys.exit(0)
        except SystemExit:
            os._exit(0)  # pylint: disable=protected-access
