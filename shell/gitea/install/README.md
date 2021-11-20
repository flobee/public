
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

Install helper scripts for `gitea`

under debian stretch|buster|bullseye and many others *nix OS's.

I had some issues at the very first day installing `gitea` and was not able to
get it run.

The documentation was not good enough in that time so this may help you today.

Install `gitea` under user "`git`"? Read ahead:

Now you will find the list of commands and scripts here in `install/*.sh` you
may execute by hand or running the main `runner.sh` script.

The `runner.sh` script will guide you by default. Asks questions for backups or
the kind of update (update or install from scratch) depending on `config.sh`
settings.

Read all infomations of the output befor you go on to avoid problems.

The scripts should be run under `root` and will setup needed path and rights and
switch the user when needed for setup/configure the frontend (gitea frontend)
with furhter details.


Hints:

Forget your /home/git/.ssh/authorized_keys
Gitea will do! Bring it to zero bytes if already exists and you will have
less issues.


## Getting started:

+ Edit `config.sh` to setup your needs. (By default you will be asked for each
action)

+ Copy all files to the server where you want to run gitea.

    scp ./this/sources/gitea/install root@server:/path/to/eg/tmp/

+ Log-in at the server (or ssh remote call) and
    - run `runner.sh`

Feel free to run the single scripts like: `backup.sh`, `download.sh`, `install.sh`
or `update.sh`.

Depending on the settings in `config.sh` the `runner.sh` does
all steps and can guide you or just does it without request any futher user
input.

By default this was tested with debian's default shell: `dash`. If you have
problems please report or post suggestions. i'm not that high-end shell junkie
and everything here could be improved but it should work with all posix shells
out there (-:


## Updates

Maybe some time some updates are required. Use the `selfupdate.sh` script to
replace/update existing scripts.

Note: `config.sh` would be replaced with the default values!