#!/usr/bin/env bash
haskell_needs_rebuild=x
scala_needs_rebuild=x
sources_changed=
haskell_pid=
last_unison_source="$1"

function maybe_build_haskell {
  if [ -n "$haskell_needs_rebuild" ]; then
    echo "Building typechecker..."
    stack build && haskell_needs_rebuild="" && echo "Typechecker built!"
  fi
}

function maybe_build_scala {
  if [ -n "$scala_needs_rebuild" ]; then
    echo "Building runtime..."
    (cd runtime-jvm; yes q | sbt main/compile) && scala_needs_rebuild="" && echo "Runtime built!"
  fi
}

function kill_watcher {
  # echo "debug: kill $haskell_pid"
  kill $haskell_pid 2>/dev/null
  wait $haskell_pid 2>/dev/null
  haskell_pid=
}

function start_watcher {
  stack exec watcher "$last_unison_source" &
  haskell_pid=$!
  echo "Launched haskell watcher as pid $haskell_pid."
}

function go {
  # echo "debug: haskell_needs_rebuild=$haskell_needs_rebuild"
  if [ -n "$haskell_needs_rebuild" ] || [ -n "$scala_needs_rebuild" ]; then
    kill_watcher
  fi
  maybe_build_haskell && maybe_build_scala
  # echo "debug: haskell_needs_rebuild=$haskell_needs_rebuild, scala_needs_rebuild=$scala_needs_rebuild, haskell_pid=$haskell_pid"
  if [ -z "$haskell_needs_rebuild" ] && [ -z "$scala_needs_rebuild" ] && [ -z "$haskell_pid" ]; then
    start_watcher
  fi
}

trap kill_watcher EXIT
go

while IFS= read -r changed; do
  # echo "debug: $changed"
  case "$changed" in
    NoOp)
      if [ -n "$sources_changed" ]; then
        sources_changed=
        go
      fi
      ;;
    *.hs|*.cabal)
      echo "detected change in $changed"
      # hasktags -cx parser-typechecker
      haskell_needs_rebuild=x
      sources_changed=x
      ;;
    *.scala|*.sbt)
      echo "detected change in $changed"
      scala_needs_rebuild=x
      sources_changed=x
      ;;
    *.u|*.uu)
      last_unison_source="$changed"
      if ! kill -0 $haskell_pid > /dev/null 2>&1; then
        start_watcher
      fi
      ;;
    */scripts/execwatch.sh|*/scripts/watchwatch.sh)
      echo "Restarting ./scripts/watchwatch.sh..."
      kill_watcher
      ./scripts/watchwatch.sh "$last_unison_source"
      exit
      ;;
  esac
done
