#!/usr/bin/env bash

# Promotion banners

################################################################################
# {{{ ### Promotion for DIPA.sh ################################################
################################################################################

# its: ANSI Regular & Hand Made
BANNER_INTRO_PRE=$(
    cat <<'BANNER_INTRO'

              ███████████████████████████████████████████
              █                                         █
              █                                         █
                                                        █
    ██████   ██\033[0m  \033[36m██████   █████      ███████  ██   ██\033[0m   █
    ██   ██  ██\033[0m  \033[36m██   ██ ██   ██     ██       ██   ██\033[0m   █
    ██   ██  ██\033[0m  \033[36m██████  ███████     ███████  ███████\033[0m   █
    ██   ██  ██\033[0m  \033[36m██      ██   ██          ██  ██   ██\033[0m   █
    ██████   ██\033[0m  \033[36m██      ██   ██  █  ███████  ██   ██\033[0m   █
                                                        █
              █          VERSION_STRING   █
              █    ██████████████████████████████████████
              █   █
              █  █     Digitales Partizipationssystem
              █ █      DIPAS - dipas.org
              ██       Hamburg / Germany
              █
        [D]eep [I]nstall and [P]roject [A]ssistant [Sh]ellscript
        For development tasks: DIPA.sh

BANNER_INTRO
);

# shellcheck disable=SC2034
BANNER_INTRO="${BANNER_INTRO_PRE/VERSION_STRING/${VERSION_STRING}}";

# Umpf TL:DR: 1 - 26 DEC!
BANNER_OUTRO_PRE_XMS=$(
    cat <<'BANNER_OUTRO_DEC'

       o
  o '.\'/.' o
    :->@<-:
  o .'/.\'. o       .-"``"-.
       o            /______; \                        .-----.
                   {_______}\|                       ( #-...'`\
                   (/ a a \)(_)                       \ #     |
                   (.-.).-.)                         _ )"===="|_
      _______ooo__(    ^    )____________           (_`"======"`_)
                   '-.___.-'                         /`""""""""`\
                                                     |        o _o\
                                   ,_                |         (_>|
              ___                 {` `}__             \      '.___/--#
 _  _      ."`   `"=,             `;"`   `"=,          '.    ;-._:'\
{_}:_`'=='` _,=="""=,\            /     _.-'`\           )===\  <>_/  __
     `'--.=" _.====, `|          ;  _.'`   _.;`    .---""`====`-'\__.' `|
         `'_(| ^.^ |)/           ;'`    _.:_^}    /             ()\     /
           )';_'='_/.'  _  .'=_._\___.-;`|| || _  \___..--'        \_.-'
        .'`    '.=/(__/` | _`-.=||_||_||_||_|/` |    |           () |
       /    /   o|  \ \_/  .=`-`/           \\_/     ;              ;
      /`-,_/    o|  |-'        /`-..-'   ~~ |/        \          ()/
      `(`___   o/__/           \_/`        /           \      '.  /
       _`\ \`""`  \  __        __\ \   '-./ __,     _.'`\       `;
      || `'.'._   /-"//       {{o '.'.   //" //    (     `\       \_
      ||  ,/`-.`./  //        {{  \/`.`.//  //      \    .-`\       `\
  jgs `\\_/    `'-.//         `\\_/   `'; o//        \___)   `._____.'
                                `"`      `"`
https://ascii.co.uk/

BANNER_OUTRO_DEC
);

# North earth : ~21 Mar - ~20Jun
BANNER_OUTRO_PRE_SPR=$(
    cat <<'BANNER_OUTRO_SPR'

          ,
      /\^/`\
     | \/   |         SPRING IS IN THE AIR!
     \ \    /                                          _ _
      '\\//'                                         _{ ' }_
        ||                DON'T PANIC               { `.!.` }
        ||  ,                                         {_,_}
    |\  ||  |\                                          |
    | | ||  | |         Have a good day               (\|  /)
    | | || / /                                         \| //
     \ \||/ / \\   `   /       ´      `   \\   o //     |//
      `\\//`   \\   \./    \\ /    ///     \\ o //   \\ |/ /
     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

BANNER_OUTRO_SPR
);

#  ~21 Juni | Jul | Aug | ~ 20Sep
BANNER_OUTRO_PRE_SUM=$(
    cat <<'BANNER_OUTRO_SUM'
      SUMMER TIME             .
                         .    |    .
                          \   |   /
                      '.   \  '  /   .'
                        '. .'```'. .'
    <>.............:::::::`.......`:::::::................<>
    <>:                                see you the beach :<>
    <>:                              and have a good day :<>
    <><><><><><><><><><><><><><><><><><><><><><><><><><><><>

BANNER_OUTRO_SUM
);

# Bug to be shown at 24.12 and 31.12 - 1.1
BANNER_OUTRO_PRE_BUG=$(
    cat <<'BANNER_OUTRO_BUG'
                         _ ._  _ , _ ._
                       (_ ' ( `  )_  .__)
                     ( (  (    )   `)  ) _)
                    (__ (_   (_ . _) _) ,__)
                        `~~`\ ' . /`~~`
                        ,::: ;   ; :::,
                       ':::::::::::::::'
    +--------------c42-----/_ __ _\----------------------+
    |    BAD, BAD, BUG HERE. CHECK THE DATE AND TIME     |
    |        HAPPY XMAS and a HAPPY NEW YEAR ;-)         |
    +----------------------------------------------------+

BANNER_OUTRO_BUG
);


BANNER_OUTRO_PRE_DEF=$(
    cat <<'EOTXT'
          _\|/_
          (o o)
 +---- oOO-{_}-OOo----+
 |   Have a good day  |
 / ------------------ \

EOTXT
);


function getBannerOutro() {
    local banner="$BANNER_OUTRO_PRE_DEF";

    case $(date +%m-%d) in
        # north hemisphere lazy strict and nearby
        #
        # BANNER_OUTRO_PRE_SPR # spring    # North earth : ~21 Mar - ~20Jun
        # BANNER_OUTRO_PRE_SUM # summer    # ~21 Juni | Jul | Aug | ~ 20Sep
        # BANNER_OUTRO_PRE_XMS # xmas time # Upf TL;DR: 1 - 26 DEC!
        # BANNER_OUTRO_PRE_BUG #           # Bug to be shown at 24-26.12 and 31.12 - 1.1

        03-2[1-9] | 03-3* | 04-[0123]* | 05-[0123]* | 06-[01]* | 06-20)
            banner="$BANNER_OUTRO_PRE_SPR";
            ;;
        06-2[1-9] | 06-3* | 07-[0123]* | 08-[0123]* | 09-[01]* | 09-20)
            banner="$BANNER_OUTRO_PRE_SUM";
            ;;
        # 09-2[2-9] | 09-3* | 1[012]-[01]* | 12-2[012])
        #     echo "autumn" ;;

        12-2[4-6] | 01-01 | 12-31)
            banner="$BANNER_OUTRO_PRE_BUG";
            ;;
        12-0[1-9] | 12-1[0-9] | 12-2[0-6]*)
            banner="$BANNER_OUTRO_PRE_XMS";
            ;;
        # 12-2[1-9] | 12-3* | 01-[0123]* | 02-[0123]* | 03-[1*|20)
        #     banner="wintertime";
        #     ;;
    esac

    echo "$banner";
}


# End promotion }}}
