![CPanel](./Logo.png)

# CPanel

**A centralized Roblox trolling and control panel.**

CPanel is a Roblox control panel that allows developers to remotely interact with users running scripts that include the CPanel client.

Developers integrate CPanel into their own scripts. Whenever someone executes one of those scripts, their client automatically connects to the developer's WebSocket server and registers as a participant.

Authorized developers can then open the CPanel dashboard, view connected participants, join their servers, and trigger various actions and effects on their clients.

From player actions to visual effects, audio playback, and camera effects, CPanel provides a centralized way to interact with everyone connected to your server.

## How It Works

CPanel uses a centralized WebSocket backend to connect developers and participants.

1. **Developers integrate CPanel** into their Roblox scripts.
2. **Users execute the script**, automatically connecting their client to the WebSocket server.
3. **The server registers the connection** and identifies whether the client has developer access.
4. **Developers open the dashboard** and see everyone currently connected.
5. **Developers select participants** and send actions or effects to their clients.

You host your own WebSocket backend using the official repository:

**[CPanelWebsocket](https://github.com/JustSomeGuest/CPanelWebsocket)**

The backend can be deployed as a Web Service through [Render](https://render.com/).

## Features

### Participant Management
- Live participant list.
- Search and refresh participants.
- Select individual participants.
- Join participants' exact game servers.
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
| Can select and interact with participants. | Receives actions and effects from developers. |
| Can manage effects. | Can optionally block incoming effects. |

Developer access is controlled through the WebSocket server's `access.json` file.

Only authorized UserIds receive the developer dashboard.

---

## WebSocket Setup

CPanel requires a separately hosted WebSocket backend.

**Official repository:** https://github.com/JustSomeGuest/CPanelWebsocket

Clone the repository, configure `access.json`, and deploy it as a Web Service on Render.

### Developer Access

Inside the WebSocket repository, edit `access.json`:

\`\`\`json
{
  "_comment": "Authorized CPanel developer UserIds.",
  "userids": [
    10951598942
  ]
}
\`\`\`

Add your Roblox UserId to the array. Multiple developers can be authorized.

### Hosting

1. Clone the [CPanelWebsocket repository](https://github.com/JustSomeGuest/CPanelWebsocket).
2. Push the repository to your GitHub account.
3. Open [Render](https://render.com/).
4. Create a new Web Service.
5. Connect your repository.
6. Configure the build command as `npm install`.
7. Configure the start command as `npm start`.
8. Deploy the service.

Your WebSocket endpoint will look like:

\`\`\`text
wss://your-service.onrender.com
\`\`\`

Use this endpoint in your CPanel client configuration.

---

## Important

CPanel only works with clients that have loaded a script containing the CPanel client.

It does not automatically connect to every Roblox player in a game.

Actions and effects are processed by the receiving client's own CPanel instance. Participants can also enable `CPanelBlockEffects` to refuse incoming effects while remaining connected.