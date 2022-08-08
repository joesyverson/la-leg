# La Leg

"La Leg" is French for... "the Leg".

## Requirements

This project:
- is developed on Linux Ubuntu. It is not yet adapted for MacOS or Windows. It should run on most Debian-based distributions, but **in some cases may catch some errors with other families:** Red Hat, Arch, etc.
- uses Python 3.10.4 and BASh 5.1.16. Any versions above Python 3.6 and BASh 5 should work.

Requirements are listed in the `requirements.*.txt` files in the root directory.

The Makefile will list missing dependencies and exit if they are missing.

### Note on Aliases

This project is currently using Podman and Podman Compose under the guise of Docker. You can get Podman from the Ubuntu or Debian repositories. `podman-compose` is in the Pip 3 repositories. Install it locally if you get a warning about it not being installed. For example:

```bash
pip3 install --user podman-compose=1.0.3
```

## How to Use

**Recommended:** use a virtual env:
```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.py.txt
```
The `venv/` directory will will be ignored by Git. **To deactivate, run:** `deactivate`.

There's a Makefile in the root. Call `make help` for further instructions.

## Structure

The root contains dependency requirements, Git stuff, Makefile and logic, and a docker-compose file.

See below for subdirectories.

### Wordpress

Worpress source directory, which is mounted in the Wordpress container.

### Cloud

Directory for infrastucture scipts, organized by provider.

#### AWS References

- Run instances: https://docs.aws.amazon.com/cli/latest/reference/ec2/run-instances.html
- Examples: https://docs.aws.amazon.com/cli/latest/reference/ec2/run-instances.html#examples
- JSON skeletons: https://docs.aws.amazon.com/cli/latest/userguide/cli-usage-skeleton.html
- Error codes: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/errors-overview.html
