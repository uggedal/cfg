#!/bin/sh

ROOT=$(cd "$(dirname "$0")"; pwd -P)
EMAIL={{ tls.cf.EMAIL }}
API_KEY={{ tls.cf.api_key }}

zone() {
	case "$1" in
		{% for c in tls.certs %}
		{{ c.domains[0] }})
			printf '{{ c.cf.zone }}'
			;;
		{% endfor %}
	esac
}

deploy_challenge() {
	local DOMAIN=$1
	local TOKEN_FILENAME=$2
	local TOKEN_VALUE="$3"

	curl -X POST \
		https://api.cloudflare.com/client/v4/zones/$(zone $DOMAIN)/dns_records \
		-H "X-Auth-Email: $EMAIL" \
		-H "X-Auth-Key: $API_KEY" \
		-H "Content-Type: application/json" \
		--data '{
			"type": "TXT",
			"name":" _acme-challenge.'$DOMAIN'",
			"content": "'$TOKEN_VALUE'",
			"ttl": 120,
			"priority": 10,
			"proxied": false
		}' \
		-o $ROOT/$DOMAIN.json

	# Wait for DNS to settle
	sleep 60
}

clean_challenge() {
	local DOMAIN=$1
	local TOKEN_FILENAME=$2
	local TOKEN_VALUE="$3"

	local id=$(jq -r '.result.id' $ROOT/$DOMAIN.json)
	curl -X DELETE \
		https://api.cloudflare.com/client/v4/zones/$(zone $DOMAIN)/dns_records/$id \
	 -H "X-Auth-Email: ${EMAIL}"\
	 -H "X-Auth-Key: ${API_KEY}"\
	 -H "Content-Type: application/json"

	rm -f "${ROOT}/${1}.json"
}

deploy_cert() {
	local DOMAIN=$1
	local KEYFILE=$2
	local CERTFILE=$3
	local FULLCHAINFILE=$4
	local CHAINFILE=$5
	local TIMESTAMP="$6"

	if systemctl is-active nginx >/dev/null; then
		systemctl reload nginx
	fi
}

HANDLER=$1
shift
case "$HANDLER" in
	deploy_challenge|clean_challenge|deploy_cert)
		$HANDLER "$@"
		;;
esac
