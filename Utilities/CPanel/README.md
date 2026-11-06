![CPanel](./Logo.png)

# CPanel

**A centralized Roblox control panel.**

CPanel is a Roblox control panel that allows developers to remotely interact with users running scripts that include the CPanel client.

Developers integrate CPanel into their own scripts. Whenever someone executes one of those scripts, their client automatically connects to the developer's WebSocket server and registers as a participant.

Authorized developers can open the CPanel dashboard, view connected participants, join their game servers, and send actions and effects to their clients.

From player actions to visual effects, audio playback, and camera effects, CPanel provides a centralized way to interact with connected clients.

## Loader
```
task.spawn(function()
getgenv().CPanelWebsocket="wss://your-service.onrender.com"
loadstring(game:HttpGet("https://raw.githubusercontent.com/JustSomeGuest/Scripts/Main/Utilities/CPanel/Init.lua"))()
end)
```

## How It Works

CPanel uses a centralized WebSocket backend to connect developers and participants.

1. **Developers integrate CPanel** into their Roblox scripts.
2. **Users execute the script**, automatically connecting their client to the WebSocket server.
3. **The server registers the connection** and determines whether the client has developer access.
4. **Authorized developers open the dashboard** and see currently connected participants.
5. **Developers select participants** and send actions or effects to their clients.

You host your own WebSocket backend using the official repository:

**[CPanelWebsocket](https://github.com/JustSomeGuest/CPanelWebsocket)**

The backend can be deployed as a Web Service through [Render](https://render.com/).

## Features

### Participant Management
- Live participant list.
- Search and refresh participants.
- Select individual participants.
- Join participants' game servers.
- View connection and effect status.

### Player Actions
- Freeze.
- Unfreeze.
- Kill.
- Bring.
- Goto.

### Audio Controls
- Play Roblox audio assets using their asset IDs.
- Stop playback.
- Loop audio.
- Adjust volume.
- Restore default volume.

### Visual Effects
- Screen flash.
- Blur.
- Color effects.
- FOV adjustment.
- Grayscale.
- Invert.
- Screen tint.
- Restore visual defaults.

### Fun Effects
- Highlights.
- Nameplates.
- Overhead notifications.
- Vignette.
- Camera shake.
- Camera zoom.
- Lighting effects.
- Particles.
- Distortion.
- Confetti.

### Dashboard Settings
- 6 theme presets.
- Transparency.
- Animations.
- Interface sounds.
- Notifications.
- Automatic reconnection.
- Refresh interval.
- Settings reset.

---

## Two Types of Users

| Developer | Participant |
| --- | --- |
| Gets access to the dashboard. | Automatically connects when executing an integrated script. |
| Can view connected participants. | Appears in the participant list. |
| Can select connected participants. | Receives actions and effects. |
| Can manage available effects. | Runs the CPanel client. |

Developer access is controlled through the WebSocket server's `access.json` file.

Only authorized Roblox UserIds receive developer dashboard access.

---

## WebSocket Setup

CPanel requires a separately hosted WebSocket backend.

**Official repository:** https://github.com/JustSomeGuest/CPanelWebsocket

Clone the repository, configure `access.json`, and deploy it as a Web Service on Render.

### Developer Access

Inside the WebSocket repository, edit `access.json`:

```json
{
  "_comment": "Authorized CPanel developer UserIds.",
  "userids": [
    10951598942
  ]
}
```

Add your Roblox UserId to the array. Multiple developers can be authorized.

### Hosting

1. Clone the [CPanelWebsocket repository](https://github.com/JustSomeGuest/CPanelWebsocket).
2. Push the repository to your GitHub account.
3. Open [Render](https://render.com/).
4. Create a new Web Service.
5. Connect your repository.
6. Set the build command to `npm install`.
7. Set the start command to `npm start`.
8. Deploy the service.

Your WebSocket endpoint will look like:

```text
wss://your-service.onrender.com
```

Use this endpoint in your CPanel client configuration.

---

## Important

- CPanel only works with clients that have loaded a script containing the CPanel client.
- It does not automatically connect to every player in a Roblox game.
- Participants are automatically registered when their CPanel client connects.
- Actions and effects are processed by the receiving client's CPanel instance.
- Developer access is determined by the WebSocket server's `access.json` configuration.

**CPanel does not control players who have not loaded a script containing its client.**
