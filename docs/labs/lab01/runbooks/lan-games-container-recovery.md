# lan-games Container Recovery (RB03)

## 1. Discovery

* Verify that the Raspberry Pi has power and link lights
* Attempt ssh to `10.0.0.254`
* If SSH is unavailable, check the connection to the switch, or follow the procedure to accessing the PI CLI via monitor and keyboard

## 2. Docker Recovery

```bash
cd lan-games/
docker compose ps -a
docker image ls
docker compose config --images
```

**Attempt restart:**

```bash
docker compose up -d
```

**If an image name or tag does not match:**

1. Compare the locally available image against the image required by Compose
2. Retag existing image to match

```bash
docker tag EXISTING:TAG EXPECTED:TAG
docker compose up -d
```

**Validate service @ `http://10.0.0.254:3000`**

If recovery fails, proceed.

## 3. Cold-Spare Replacement

1. Retrieve the preconfigured cold-spare Pi
2. Disconnect the failed Pi, reconnect the spare
3. Start docker compose container

## 5. Final Validation

From a student laptop:

* `ping 10.0.0.254` succeeds
* `http://10.0.0.254:3000` resolves lan-games server
* lan-games is functional

**Do not return failed equipment until service is validated.**
