#!/bin/bash

weather_data=$(curl -fsS --max-time 3 "https://wttr.in?format=j1" 2>/dev/null | jq -er '[.current_condition[0].weatherCode, .weather[0].astronomy[0].sunrise, .weather[0].astronomy[0].sunset] | select(all(. != null and . != "")) | @tsv' 2>/dev/null) || {
  printf '{"text":"","class":"unavailable"}\n'
  exit 0
}

IFS=$'\t' read -r weather_code sunrise sunset <<< "$weather_data"

if [[ ! $weather_code =~ ^[0-9]+$ || ! $sunrise =~ ^[0-9]{1,2}:[0-9]{2}\ [AP]M$ || ! $sunset =~ ^[0-9]{1,2}:[0-9]{2}\ [AP]M$ ]]; then
  printf '{"text":"","class":"unavailable"}\n'
  exit 0
fi

now_epoch=$(date +%s)
sunrise_epoch=$(date -d "today $sunrise" +%s 2>/dev/null || echo 0)
sunset_epoch=$(date -d "today $sunset" +%s 2>/dev/null || echo 0)

if (( sunrise_epoch > 0 && sunset_epoch > 0 && (now_epoch < sunrise_epoch || now_epoch >= sunset_epoch) )); then
  night=true
else
  night=false
fi

case $weather_code in
  113) [[ $night == "true" ]] && icon="" || icon="" ;;
  116) [[ $night == "true" ]] && icon="" || icon="" ;;
  119|122|143|248|260) icon="" ;;
  176|182|185|263|266|281|284|293|296|299|302|305|308|311|314|317|320|350|353|356|359|362|365|374|377) icon="" ;;
  179|227|230|323|326|329|332|335|338|368|371) icon="" ;;
  200|386|389|392|395) icon="" ;;
  *) icon="" ;;
esac

printf '{"text":"%s"}\n' "$icon"
