# Authentication Service - Service A

This is an authentication service built with Express, Redis, and dotenv. It provides middleware for token validation and role-based authorization.

### Prerequisites

- Node.js
- Redis
- Docker
- Docker Compose

### Installation

1. Clone the repository
2. Install dependencies:
	> npm install

3. Set up environment variables:

	> REDIS_HOST (default: 127.0.0.1)

	> REDIS_PORT (default: 6379)

	> PORT (default: 3000)

### Usage
1. Start the Redis server:
	- Read the documentation [here](https://redis.io/docs/latest/operate/oss_and_stack/install/install-redis/).

2. Run the Auth Service:
	> npm start

3. Start the services with Docker Compose:
	> docker-compose up

  This will:

  - Pull the necessary Docker images.
  - Set up the Node.js application container.
  - Set up the Redis container.

### Components
#### Redis Client

Connects to a Redis server for caching authentication tokens.

```javascript
const redisClient = redis.createClient({
  host: process.env.REDIS_HOST || "127.0.0.1",
  port: process.env.REDIS_PORT || 6379,
});

redisClient.on("error", (error) => {
  console.error("Redis client error:", error);
});

redisClient.on("end", () => {
  console.log("Redis client connection closed");
});

```

####  Error Handling Middleware

Defines middleware for handling errors that occur during request processing, logging the error and sending an appropriate HTTP response.

```javascript
const errorHandlingMiddleware = (err, req, res, next) => {
  console.error(err);
  res.status(err.status || 500).send(err.message || "Internal server error");
};

```

#### Token Validation Middleware

Middleware to validate tokens in the Authorization header by fetching user data from Redis. 

```javascript
app.use(async (req, res, next) => {
  const token = req.headers.authorization.split(" ")[1];
  const userDataString = await redisClient.get(token);
  if (userDataString) {
    req.user = JSON.parse(userDataString);
    next();
  } else {
    res.status(401).send("Invalid or expired user key");
  }
});


```

#### Authorization Middleware Factory

A factory function that returns middleware for role-based authorization. 

```javascript
const authorizationMiddleware = (requiredRole) => {
  return async (req, res, next) => {
    try {
      const availableRoles = req.user.realm_access.roles;
      if (!availableRoles.includes(requiredRole)) throw new Error();
      next();
    } catch (err) {
      res.status(403).send({ error: "access denied" });
    }
  };
};

```

#### Route Handlers

Defines route handlers for two endpoints.

```javascript
app.use(errorHandlingMiddleware);
app.use(express.json());

app.get("/authenticate", (req, res) => {
  res.send("success");
});

app.get("/authorize", authorizationMiddleware("admin1"), (req, res) => {
  res.send("success");
});

```

#### Starting the Server

Starts the Express server on the specified port.

```javascript
const port = process.env.PORT || 3002;
app.listen(port, () => {
  console.log(`Auth-service listening on port ${port}`);
});

```
