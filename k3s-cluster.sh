#!/bin/sh

SERVER="k3s-control-plane"
LOCALHOST=$(hostname -i)

# shellcheck disable=2046
cleanup() {
  docker rm -f $(docker ps -aq --filter "label=k3s" | tr '\n' ' ')
}

server() {
  docker run -d \
    --privileged \
    --restart=always \
    --label k3s \
    --name "${SERVER}" \
    -e "KINK_APISERVER_SAN=127.0.0.1.nip.io" \
    -e "KINK_EXTERNAL_IP=${LOCALHOST}" \
    -p 443:443 \
    -p 10251:10251 \
    ardikabs/kink:v1.16.15 server
}

agent() {
  docker run -d \
    --privileged \
    --restart=always \
    --label k3s \
    -e "KINK_APISERVER=${LOCALHOST}" \
    ardikabs/kink:v1.16.15 agent
}

main() {
  opt=${1:-}

  case $opt in
    start)
      server
      i=1; while [ $i -le 5 ]; do
        agent
        i=$((i + 1))
      done

      until docker exec ${SERVER} cat /etc/rancher/k3s/k3s.yaml > /tmp/k3s.kubeconfig 2>/dev/null; do
        echo "."
        sleep 1
      done
      sed -i -e 's/127.0.0.1/127.0.0.1.nip.io/g' /tmp/k3s.kubeconfig

    ;;
    stop)
      cleanup
    ;;
    *) echo "k3s: unknown argument" >&2; exit 1;;
  esac
}

main "$@"