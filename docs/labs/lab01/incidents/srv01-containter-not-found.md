# SRV01 Container Not Found

During Lab day, SRV01 failed and was unable to complete the necessary duties. This was due to a `container not found` issue.

## Error

```bash
 Network midas_default   Created                                                                                                 0.0s
 ✔ Container ea85756a438f  Removed                                                                                                 0.0s
 ✘ Container 44b9cb711bf2  Error response from daemon: No such container: 44b9cb711bf25a3d19ef8a5254c0...                          0.2s
Error response from daemon: No such container: 44b9cb711bf25a3d19ef8a5254c08df820f22f72a98464e4d17beb6156dbbeb0
```

## Possible Root Causation

The most viable causation for the crash was unplugging the Raspberry Pi without proper shutdown. Since Raspberry Pi's have "persistent" power, first instinct is to unplug the Pi after testing or labs. Doing so could cause corruption in the writable layer, leading to Docker being unable to start, modify, or delete the existing container. Docker then retains onto the metadata of the container, but after the writable layer is corrupt, the container cannot be salvaged.

## Remediation

### Prevention Steps

* Turn off Pi before unplugging PSU. Teardown will be updated accordingly.
* Update Docker Engine on all Pi's to `v29.4.0`: [(Issue #38)](https://github.com/users/tyler-dalton/projects/2?pane=issue&itemId=287673103&issue=tyler-dalton%7Cdeployment-bags%7C38)

### Disaster Recovery Day-of

* Rename the container, start the new container
* Re-flash the image from the thumb drive
* Migrate to cold-spare Pi

Runbooks directory can be [found here](../runbooks/README.md)
