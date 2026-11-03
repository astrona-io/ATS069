# Solution

Work in `/opt/portal`. Each step has a check you can run, and `astrona submit` shows which checks pass.

## 1. Read the runtime file and the image defaults

```sh
cd /opt/portal
cat runtime/app-config.runtime.yaml
cat runtime/portal.env
docker image inspect --format '{{.Config.Cmd}} {{.Config.User}}' portal:run
```

The runtime file sets `port: 7100`. The image command loads `app-config.yaml` and `app-config.production.yaml` and runs as `node`. The container will therefore listen on 7100, not on 7007.

## 2. Start the container

A command after the image name replaces the image command, so the command repeats the two image files and adds the mounted one last. The mapping `7007:7100` publishes container port 7100 on host port 7007.

```sh
docker run -d --name portal -p 7007:7100 \
  -v /opt/portal/runtime/app-config.runtime.yaml:/config/app-config.runtime.yaml:ro \
  --env-file /opt/portal/runtime/portal.env \
  --read-only --tmpfs /tmp --cap-drop ALL --security-opt no-new-privileges \
  --restart unless-stopped \
  --health-cmd "node -e \"require('http').get('http://127.0.0.1:7100/healthcheck',r=>process.exit(r.statusCode===200?0:1)).on('error',()=>process.exit(1))\"" \
  --health-interval 5s --health-timeout 3s --health-retries 3 \
  portal:run \
  node packages/backend --config app-config.yaml --config app-config.production.yaml --config /config/app-config.runtime.yaml
```

The health command requests `/healthcheck` on port 7100, because that is where the process listens inside the container. A check against port 7007 would fail and the container would become `unhealthy`.

## 3. Check each requirement

```sh
curl http://127.0.0.1:7007/config
curl http://127.0.0.1:7007/status
docker exec portal id -u
docker inspect --format 'readonly={{.HostConfig.ReadonlyRootfs}} caps={{.HostConfig.CapDrop}} opt={{.HostConfig.SecurityOpt}} restart={{.HostConfig.RestartPolicy.Name}}' portal
sleep 10
docker inspect --format '{{.State.Health.Status}}' portal
```

The first response lists the three files in order and port 7100. The second shows `tokenConfigured` set to `true`. The user id is not `0`. The inspect output shows the read-only filesystem, the dropped capabilities, the security option and the restart policy. The health status is `healthy`. Then run `astrona submit`.
