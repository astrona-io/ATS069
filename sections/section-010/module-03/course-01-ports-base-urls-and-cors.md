---
draft: true
exam_objectives:
- Build and run Backstage projects locally
---
# Ports, Base URLs And CORS

A local Backstage project runs two servers, and the browser talks to both. When the app loads but every card shows a network error, the cause is almost always a mismatch between three kinds of values: ports, base URLs and allowed origins. This part explains each one and how they must agree.

The frontend development server listens on port 3000. The backend listens on port 7007. A port is a number that selects one network service on a machine. The configuration names these services twice. The `listen` block of the backend sets the port that the process binds. The `baseUrl` values tell the rest of the system which address to use to reach each server.

<!-- astrona:playground:renew -->

Open a shell in the playground with `astrona ssh ats-069-playground-010-03` and read the relevant lines:

```sh
cd /opt/envcfg
sed -n 1,20p app-config.yaml
```

The file sets `app.baseUrl` to `http://localhost:3000`, `backend.baseUrl` to `http://localhost:7007` and `backend.listen.port` to `7007`.

## Listen and base URL are different settings

`backend.listen` controls what the process does: which port it binds and, with the `host` key, which network interface. `backend.baseUrl` controls what other components believe: the address that the app puts into its requests and that the backend puts into links it returns. In local development both describe the same address. Behind a load balancer in production they differ, because the process listens on port 7007 inside a container while users reach it at an HTTPS address such as `https://portal.example.com`.

If `baseUrl` and `listen.port` disagree locally, the process starts without error, and then the app sends its requests to a port where nothing listens. The browser reports a refused connection or a failed request. The backend log shows nothing, because no request arrives.

## The browser and CORS

A browser applies the same-origin policy. An origin is the combination of scheme, host and port, so `http://localhost:3000` and `http://localhost:7007` are two different origins. When page code from one origin sends a request to another, the browser asks the server for permission, using Cross-Origin Resource Sharing (CORS). The server answers with headers that name the allowed origins. If the origin is not allowed, the browser discards the response, and the developer tools show a CORS error.

The `backend.cors` block sets these answers:

```yaml
backend:
  cors:
    origin: http://localhost:3000
    methods: [GET, HEAD, PATCH, POST, PUT, DELETE]
    credentials: true
```

The `origin` must be exactly the origin of the app, including the port. `methods` lists the allowed HTTP methods, and `credentials: true` allows requests that carry cookies or authorization headers.

```sh
python3 tools/check-config.py cors
```

The checker compares `backend.cors.origin` with `app.baseUrl` and prints `OK` when they are equal. Change the origin to `http://localhost:3001`, run the checker again and read the problem it reports. Then restore the value.

## Environment overrides without editing files

Any configuration value can be overridden with an environment variable whose name starts with `APP_CONFIG_`. The rest of the name is the key path with underscores for dots. For example, `APP_CONFIG_backend_listen_port=7008` sets `backend.listen.port`. The value is read as JSON when it can be, so a number stays a number. This helps when a port on a developer machine is already taken, because the base file stays unchanged.

```sh
APP_CONFIG_backend_listen_port=7008 env | grep APP_CONFIG
```

The command shows the variable only. A real backend reads it at start. If the port changes this way, `backend.baseUrl` and the CORS origin of the app must still match the new port.

## Common pitfalls

> [!WARNING]
> A CORS error is reported by the browser, not by the backend, so look in the browser developer tools first. A wildcard origin together with credentials does not work in browsers. Change the port in every place that names it: `listen.port`, `backend.baseUrl`, and any proxy or script that calls the backend.
