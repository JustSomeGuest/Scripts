![CPanel](./Logo.png)

# CPanel

**A centralized Roblox control panel.**

CPanel is a client-side control panel built for developers who want to interact with users connected to their scripts through a centralized WebSocket server.

Once integrated, the CPanel client automatically connects when a user executes your script. Connected users appear in the participant list, where authorized developers can manage sessions, trigger actions, and control client-side effects through the dashboard.

CPanel brings participant management, player actions, audio, visual effects, and camera controls together in one interface.

## Loader

Add the following to your script:

```lua
task.spawn(function()
getgenv().CPanelWebsocket = "wss://your-websocket.onrender.com"
loadstring(game:HttpGet("https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Utilities/CPanel/Init.lua"))()
end)
```

Once loaded, the client connects to your configured WebSocket server and registers as a participant.

## Features

### Participant Management
- Live participant list.
- Search and refresh participants.
- Individual participant selection.
- Join participant game servers.
- Connection and effect status.

### Player Actions
- Freeze and unfreeze.
- Kill.
- Bring.
- Goto.

### Audio
- Play Roblox audio assets by ID.
- Stop playback.
- Loop audio.
- Volume control.
- Restore default volume.

### Visual Effects
- Screen flash.
- Blur.
- Color effects.
- FOV adjustment.
- Grayscale and invert.
- Screen tint.
- Restore visual defaults.

### Camera & Environment
- Camera shake.
- Camera zoom.
- Lighting effects.
- Vignette.
- Distortion.
- Particles.
- Confetti.

### Additional Effects
- Highlights.
- Nameplates.
- Overhead notifications.

### Dashboard
- 6 theme presets.
- Interface transparency.
- Animations.
- Interface sounds.
- Notifications.
- Automatic reconnection.
- Refresh interval.
- Settings reset.

## How It Works

CPanel uses a WebSocket backend to connect the client and developer dashboard.

1. A developer adds the CPanel loader to their Roblox script.
2. A user executes that script.
3. The CPanel client connects to the configured WebSocket server.
4. The server registers the connection and checks developer authorization.
5. Authorized developers can open the dashboard and interact with connected participants.

CPanel only registers users who execute a script containing the client. It does not automatically connect to every player in a game.

## Access Levels

| Developer | Participant |
| --- | --- |
| Accesses the CPanel dashboard. | Connects when executing an integrated script. |
| Views connected participants. | Appears in the participant list. |
| Selects participants. | Receives actions and effects. |
| Uses dashboard controls. | Runs the CPanel client. |

Developer access is managed by the WebSocket backend.

## WebSocket Backend

CPanel requires its own hosted WebSocket backend.

**Backend repository:** [CPanelWebsocket](https://github.com/JustSomeGuest/CPanelWebsocket)

The backend can be deployed as a Web Service on [Render](https://render.com/).

### Hosting

1. Clone the [CPanelWebsocket repository](https://github.com/JustSomeGuest/CPanelWebsocket).
2. Push the repository to your GitHub account.
3. Create a new Web Service on Render.
4. Connect your repository.
5. Set the build command to `npm install`.
6. Set the start command to `npm start`.
7. Deploy the service.

Your WebSocket endpoint will look like:

```text
wss://your-websocket.onrender.com
```

Set this endpoint in the CPanel loader.

## Developer Authentication

Developer access uses two checks:

- **Roblox UserId:** identifies which accounts are authorized to use the dashboard.
- **Developer token:** a secret value configured on the backend and supplied by the developer client.

Both checks must be enforced by the WebSocket backend before granting dashboard access.

### 1. Configure the Developer Token

In your Render service, open **Environment** and add:

| Key | Value |
| --- | --- |
| `CPANEL_DEV_TOKEN` | A long, randomly generated secret |

Keep this value private. Do not use the example text as your actual token.

### 2. Authorize Developer UserIds

In the backend repository, edit `access.json`:

```json
{
  "_comment": "Authorized CPanel developer UserIds.",
  "userids": [
    10951598942,
    11930215114,
    999999999
  ]
}
```

Add the Roblox UserIds that should have developer access. Only include accounts you trust.

### 3. Developer Loader

Developers use a separate loader that supplies the developer token:

```lua
getgenv().CPanelDevToken = "YOUR_PRIVATE_TOKEN"
getgenv().CPanelWebsocket = "wss://your-websocket.onrender.com"
loadstring(game:HttpGet("https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Utilities/CPanel/Init.lua"))()
```

Replace the token and WebSocket endpoint with your own values.

### 4. Participant Loader

Participants do not need a developer token. They use the standard loader shown in the [Loader](#loader) section.

**Security note:** A token placed in a client-side script can be extracted by anyone who receives that script. Treat it as a shared credential, not a secure way to prove a developer's identity. For stronger protection, use server-side authentication that verifies the Roblox account and token without exposing a reusable secret to participants.

## Configuration Reference

| Setting | Purpose |
| --- | --- |
| `CPanelWebsocket` | WebSocket endpoint used by the client. |
| `CPanelDevToken` | Developer authentication token. |
| `CPANEL_DEV_TOKEN` | Matching secret configured in the backend environment. |
| `access.json` | List of Roblox UserIds authorized for developer access. |

## Important

- CPanel only works with clients that have loaded a script containing the CPanel client.
- It does not automatically connect to every player in a Roblox server.
- Participants register when their CPanel client connects.
- Actions and effects are processed by the receiving client's CPanel instance.
- Dashboard access depends on the authorization checks implemented by the WebSocket backend.
- The developer token should be kept private and should not be treated as secure when embedded in a distributed client script.

**CPanel cannot control players who have not loaded a script containing its client.**
