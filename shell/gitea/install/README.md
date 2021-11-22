
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


# About

Install helper scripts for `gitea`.

Under debian stretch|buster|bullseye and many other *nix OS's.

I had some issues at the very first day installing `gitea` and was not able to
get it run.

The documentation was not good enough in that time so this may help you today.

Install `gitea` under user "`git`"?. Optional you can change the user.

Now you will find some scripts here in `install/*.sh` you may execute by hand or
running the main `runner.sh` script.

The `runner.sh` script will guide you by default. Asks questions for backups or
the kind of update (update or install from scratch) depending on
`config.sh[-dist]` settings.

Read all infomations of the output befor you go on to avoid problems.

The scripts should be run under `root` and will setup needed path and rights and
switch the user when needed for setup/configure the frontend (gitea frontend)
with furhter details.


Hints:

Forget your /home/git/.ssh/authorized_keys
Gitea will do! Bring it to zero bytes if already exists and you will have
less issues.


## Getting started

With default values:

+ Default values are in `config.sh-dist`. The basics are very verbose. Good for
  the first run!

+ Copy all files to the server where you want to run gitea.

    `scp ./sources/to/gitea/install root@server:/home/git/tea/`

+ Log-in at the server (or ssh remote call) and
    - run `/home/git/tea/install/runner.sh`

Feel free to run the single scripts like: `backup.sh`, `download.sh`,
`install.sh` or `update.sh`.

To reduce output and handling create and setup your `config.sh` to overwrite the
defaults. By default you will be asked for each action.

Depending on the settings in `config.sh[-dist]` the `runner.sh` does
all steps and can guide you or just does it without request any futher user
input.

By default this was tested with debian's default shell: `dash`. If you have
problems please report or post suggestions. i'm not that high-end shell junkie
and everything here could be improved but it should work with all posix shells
out there (-:


## Updates

Maybe some time some updates are required. Use the `selfupdate.sh` script to
replace/update existing scripts.

Note: `config.sh-dist` would be replaced with the default values!

For automisations you can set the config to not ask questions anymore e.g. using
your custom `config.sh`. Suggested values then:

    ACTION_ASKQUESTIONS='N';
    ACTION_TYPE='U';

Then call `runner.sh '[new url]'` or `download.sh '[new url]'` for a specific
version you selected or just `runner.sh` or `download.sh` for the latest
version.

To avoid overwriting your settings (e.g. when using `selfupdate.sh`) add your
own `config.sh` including your settings which you can find in `config.sh-dist`.
The scripts first scans the default `config.sh-dist` file and then scans your
`config.sh` file (if exists) so that your values will take account (lifo).


## Usage over the time

Once gitea is installed there are not may things to take care of. Except on OS
changes or changes of gitea where the installer needs some updates.

Then use `selfupdate.sh` and compare/review the `config.sh-dist` for changes and
update your custom `config.sh` if exists.

Add your custom `config.sh`:

+ Probably disable asking question
+ Set default action for updates (U)
+ Set if you want backups with this script or not

Than you can run the `runner.sh` which just do all automatically.

Suggestion: symlink `config.sh.example-for-your-setup` to `config.sh` if you
want to have updates from the maintainer. It is only the 'update' case and
creates backups.


Happy git + tea :)
