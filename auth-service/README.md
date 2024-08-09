# Auth Service

This project provides an overview of the Auth Service application built with Express.js. This service is responsible for handling user authentication, token management, and user account administration using Keycloak as the identity provider.

### Prerequisites

- Node.js
- Keycloack
- Docker
- Docker Compose

### Installation

1. Clone the repository
2. Install dependencies:
	> npm install

3. Set up environment variables:

	> KEYCLOAK_AUTH_SERVER_URL (your-keycloak-auth-server-url)

	> KEYCLOAK_REALM (your-keycloak-realm)

	> KEYCLOAK_CLIENT_ID (your-keycloak-client-id)

	> KEYCLOAK_CLIENT_SECRET (your-keycloak-client-secret)

	> PORT (default: 3000)

### Usage
1. Start Keycloack:
	- Read the documentation [here](https://www.keycloak.org/guides).

2. Run the Auth Service:
	> npm start

3. Start the services with Docker Compose:
	> docker-compose up

	This will:

	- Pull the necessary Docker images.
	- Set up the Node.js application container.
	- Set up the Redis container.

### Components
#### Error Handling Middleware

Handles errors and sends appropriate responses to the client.

```javascript
const errorHandlingMiddleware = (err, req, res, next) => {
  console.error(err);
  res.status(err.status || 500).send(err.message || "Internal server error");
};

app.use(errorHandlingMiddleware);
```

#### JSON Body Parsing Middleware

Parses incoming request bodies with JSON payloads.

```javascript
app.use(express.json());


```

#### Login Endpoint

Authenticates users and retrieves access and refresh tokens from Keycloak.

```javascript
app.post("/login", async (req, res) => {
  const { username, password } = req.body;
  try {
    const { data } = await axios({
      method: "post",
      url: `${process.env.KEYCLOAK_AUTH_SERVER_URL}/realms/${process.env.KEYCLOAK_REALM}/protocol/openid-connect/token`,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      data: `grant_type=password&client_id=${process.env.KEYCLOAK_CLIENT_ID}&client_secret=${process.env.KEYCLOAK_CLIENT_SECRET}&username=${username}&password=${password}`,
    });
    const { access_token: accessToken, refresh_token: refreshToken } = data;
    res.json({
      accessToken,
      refreshToken,
      ...data,
    });
  } catch (err) {
    console.error(err);
    res.status(401).send("Invalid credentials");
  }
});

```

#### Refresh Token Endpoint

Refreshes the access token using the refresh token.

```javascript
app.post("/refreshToken", async (req, res) => {
  try {
    const { refreshToken } = req.body;
    const { data } = await axios({
      method: "post",
      url: `${process.env.KEYCLOAK_AUTH_SERVER_URL}/realms/${process.env.KEYCLOAK_REALM}/protocol/openid-connect/token`,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      data: `grant_type=refresh_token&client_id=${process.env.KEYCLOAK_CLIENT_ID}&client_secret=${process.env.KEYCLOAK_CLIENT_SECRET}&refresh_token=${refreshToken}`,
    });
    const { access_token: accessToken } = data;
    res.json({ accessToken, refreshToken });
  } catch (error) {
    res.status(400).send(error.message);
  }
});

```

#### Verify Token Endpoint

Verifies the validity of an access token.

```javascript
app.get("/verifyToken", async (req, res) => {
  try {
    const accessToken = req.headers.authorization.split(" ")[1];
    const { data } = await axios({
      method: "post",
      url: `${process.env.KEYCLOAK_AUTH_SERVER_URL}/realms/${process.env.KEYCLOAK_REALM}/protocol/openid-connect/token/introspect`,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        Authorization: `Bearer ${accessToken}`,
      },
      data: `client_id=${process.env.KEYCLOAK_CLIENT_ID}&client_secret=${process.env.KEYCLOAK_CLIENT_SECRET}&token=${accessToken}`,
    });
    const { active } = data;
    if (!active) throw new Error("Invalid token");
    res.send(data);
  } catch (error) {
    console.error(error.message);
    res.status(401).send(error.message);
  }
});

```

#### Signout Endpoint

Revokes the refresh token to log out the user.

```javascript
app.get("/signout", async (req, res) => {
  try {
    const refreshToken = req.session.refreshToken;
    const url = `${process.env.KEYCLOAK_AUTH_SERVER_URL}/realms/${process.env.KEYCLOAK_REALM}/protocol/openid-connect/revoke`;
    const { data } = await axios({
      method: "post",
      url,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      data: `client_id=${process.env.KEYCLOAK_CLIENT_ID}&client_secret=${process.env.KEYCLOAK_CLIENT_SECRET}&token=${refreshToken}&token_type_hint=refresh_token`,
    });
    res.send({ data });
  } catch (err) {
    res.status(500).send("Error logging out");
  }
});

```

#### Suspend User Endpoint

Suspends a user account by disabling it.

```javascript
app.patch("/suspend", async (req, res) => {
  const userId = req.body.userId;
  const adminToken = req.kauth.grant.access_token.token;
  const userUpdateUrl = `${process.env.KEYCLOAK_AUTH_SERVER_URL}/admin/realms/${process.env.KEYCLOAK_REALM}/users/${userId}`;
  try {
    await axios.put(
      userUpdateUrl,
      {
        enabled: false,
      },
      {
        headers: {
          Authorization: `Bearer ${adminToken}`,
          "Content-Type": "application/json",
        },
      }
    );
    res.send(`User with ID '${userId}' updated successfully.`);
  } catch (error) {
    console.error(`Failed to update user with ID '${userId}':`, error);
    res.status(500).send("Error suspending user");
  }
});

```

#### Starting the Server

Starts the Express server on the specified port.

```javascript
const port = process.env.PORT || 3001;

app.listen(port, () => {
  console.log(`Auth-service listening on port ${port}`);
});

```
