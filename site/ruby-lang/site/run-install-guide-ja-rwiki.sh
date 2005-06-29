#!/bin/sh

PATH="/var/lib/ruby-man/bin:/usr/bin:/bin"
RUBY="/usr/bin/ruby1.8"
RWIKI_SITE_DIR="/var/lib/ruby-man/site"
FUSER=/bin/fuser
PORT=8725

PID_FILE="/var/lib/ruby-man/site/rwiki.pid"
DAEMON_FILE="install-guide-ja-rwiki.rb"

# cleaning RUBYLIB
unset RUBYLIB
# for rwiki_running
RUBYLIB="/var/lib/ruby-man/lib"

rwiki_running () {
    cd $RWIKI_SITE_DIR
    RUBYLIB=$RUBYLIB "$RUBY" -r drb/drb -r 'install-guide-ja-config' -e '
      DRb.start_service
      begin
        DRbObject.new(nil, RWiki::DRB_URI).include?(nil)
      rescue
        begin
          pid = gets.to_i
          Process.kill(0, pid)
          exit(1)
        rescue
          exit(2)
        end
      end
    ' "$PID_FILE"
}

rwiki_start () {
    cd $RWIKI_SITE_DIR
    ./"$DAEMON_FILE" "$@"
}

cmd="$1"
shift
case "$cmd" in
  start)
    if rwiki_running; then
      echo "rwiki: already running."
    elif [ $? -eq 1 ]; then
      echo "rwiki: running but not working, restarting..." 1>&2
      $0 restart "$@"
    else
      $0 force-start "$@"
    fi
    ;;
   force-start)
    echo -n "rwiki: " 1>&2
    cd $RWIKI_SITE_DIR
    if rwiki_start "$@"; then
      echo "start." 1>&2
    else
      echo "failed." 1>&2
      exit $?
    fi
    ;;


  stop)
    if rwiki_running; then
      $0 force-stop
    else
      echo "rwiki: stopped."
    fi
    ;;
  force-stop)
    echo -n "rwiki: "

    if [ -n "$FUSER" ]; then
      fuser -k -v -n tcp $PORT
    else
      kill -TERM `cat "$PID_FILE"`
    fi
    echo "stop."
    ;;

  reload)
    kill -HUP `cat "$PID_FILE"`
    ;;
  restart)
    $0 force-stop
    $0 force-start "$@"
    ;;
  status)
    if rwiki_running; then
      echo "rwiki: running."
    elif [ $? -eq 1 ]; then
      echo "rwiki: running but not working."
    else
      echo "rwiki: stopped."
    fi
    ;;
  *)
    echo "Usage: $0 {start|stop|force-start|force-stop|restart|reload|status}"
    exit 1
    ;;
esac
