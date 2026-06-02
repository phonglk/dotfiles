#!/usr/bin/env bash

app_name="${1:-}"
key=$(printf '%s' "$app_name" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/_/g; s/^_//; s/_$//')

case "$key" in
	"1password"|"onepassword")
		printf ':one_password:'
		;;
	"activity_monitor")
		printf ':cpu:'
		;;
	"arc"|"comet"|"google_chrome"|"chrome")
		printf ':google_chrome:'
		;;
	"calendar")
		printf ':calendar:'
		;;
	"chatgpt"|"claude")
		printf ':widget:'
		;;
	"codex")
		printf ':terminal:'
		;;
	"cursor"|"visual_studio_code"|"code")
		printf ':code:'
		;;
	"discord")
		printf ':discord:'
		;;
	"finder")
		printf ':finder:'
		;;
	"firefox"|"firefox_developer_edition")
		printf ':firefox:'
		;;
	"kitty"|"terminal"|"iterm"|"iterm2")
		printf ':terminal:'
		;;
	"mail"|"canva_mail"|"microsoft_outlook")
		printf ':mail:'
		;;
	"messages")
		printf ':messages:'
		;;
	"microsoft_edge")
		printf ':microsoft_edge:'
		;;
	"notes")
		printf ':notes:'
		;;
	"notion")
		printf ':notion:'
		;;
	"obsidian")
		printf ':obsidian:'
		;;
	"preview")
		printf ':pdf:'
		;;
	"safari")
		printf ':safari:'
		;;
	"signal")
		printf ':signal:'
		;;
	"slack")
		printf ':slack:'
		;;
	"spotify")
		printf ':spotify:'
		;;
	"system_settings"|"system_preferences")
		printf ':gear:'
		;;
	"telegram")
		printf ':telegram:'
		;;
	"vlc")
		printf ':vlc:'
		;;
	"xcode")
		printf ':xcode:'
		;;
	"zoom"|"zoom_us")
		printf ':zoom:'
		;;
	*)
		printf ':default:'
		;;
esac
