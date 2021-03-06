#!/bin/zsh
kubectl create namespace drone
kubectl config set-context --current --namespace drone

vared -p 'Gitea Client ID: ' -c GITEA_CLIENT_ID
vared -p 'Gitea Client Secret: ' -c GITEA_CLIENT_SECRET
vared -p 'Drone RPC secret (run  > openssl rand -hex 16 <  to get one): ' -c DRONE_RPC_SECRET
vared -p 'Drone Runner UI Password (any password you want, write it down on a sticky note on your monitor): ' -c DRONE_RUNNER_UI_PASSWORD

kubectl create secret generic gitea-client-credentials \
    --from-literal=client_id=$GITEA_CLIENT_ID \
    --from-literal=client_secret=$GITEA_CLIENT_SECRET \
    -n drone

kubectl create secret generic drone-rpc-secret \
    --from-literal=rpc_secret=$DRONE_RPC_SECRET \
    -n drone

kubectl create secret generic drone-ui-password \
    --from-literal=password=$DRONE_RUNNER_UI_PASSWORD \
    -n drone

kubectl apply -f drone-ci-server.yaml -n drone
kubectl apply -f drone-ci-runner.yaml -n drone
