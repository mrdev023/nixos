**Describe the bug**

When entering an `--init` container (using systemd as PID 1), `distrobox enter` and `distrobox upgrade` both fail immediately with:

```
bash: -- : invalid option
Usage:   bash [GNU long option] [option] ...
```

The root cause is a chain of forced behaviors:

1. `distrobox-create --init` unconditionally sets `unshare_groups=1` (hardcoded in the `--init` branch, line ~318 of `distrobox-create`).
2. `distrobox-enter`, upon reading the `distrobox.unshare_groups=1` container label, takes the `su` code path and adds `--pty` to the `su` invocation (when not in headless mode).
3. On Arch Linux containers, `su` comes from the `shadow` package, which does **not** support the `--pty` flag (a `util-linux` extension). The failure of `su --pty` propagates as `bash: -- : invalid option`.

Note: the error message appears in the host locale (French in this case) because `LANG` is forwarded to the container by distrobox, and the error is actually emitted by the container's bash.

**To Reproduce**

1. Create an init container using Arch Linux:
   ```
   distrobox create --init --image docker.io/archlinux:latest --name testinit
   ```
2. Try to enter it:
   ```
   distrobox enter testinit
   ```

**Expected behavior**

`distrobox enter` should open an interactive shell inside the init container, as it does with non-init containers.

`docker exec -it --user <user> testinit /bin/bash -l` works correctly as a workaround, confirming the container itself is healthy.

**Logs**

Dry-run output (`distrobox enter testinit --dry-run`) shows `--user=root` confirming `unshare_groups=1` is active, and the generated `su` invocation includes `--pty`:

```
su <user> -m --pty -s /bin/sh -c '"$0" "$@"' -- /bin/sh -c '$(getent passwd ...) -l'
```

`su --pty` is not recognized by shadow's `su` on Arch Linux, causing the crash.

**Desktop**

- Container manager: **Docker**
- Docker version: `docker version` → 27.x
- Distrobox version: **1.8.2.4**
- Host distribution: **NixOS** (unstable)
- Distrobox installed via: **nixpkgs** (home-manager)
- Container image: `docker.io/archlinux:latest`

**Additional context**

The `--pty` flag in the `su` invocation is redundant when using `docker exec --tty`, which already allocates a PTY for the session. Removing `--pty` from the `su` call (or skipping it when the outer exec already provides a PTY) would fix the issue without breaking the init/systemd use case.

Suggested fix in `distrobox-enter`:

```diff
- if [ "${headless}" -eq 0 ]; then
-     set -- "--pty" "$@"
- fi
+ # --pty skipped: the outer container manager exec (--tty) already provides a PTY.
+ # shadow su (used on Arch Linux) does not support --pty, causing entry to fail.
```

Alternatively, `distrobox-create --init` could allow `--unshare-groups false` to be an independent opt-out, rather than forcing `unshare_groups=1` unconditionally.
