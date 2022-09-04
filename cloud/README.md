# Cloud

See provider-specific READMEs for more details.

## AWS Configuration

When running ops from the root Makefile, specify `PERM_MODEL=env` if you're not the author of this project. This will prompt AWS to search first in your environmental vars, then your AWS config file, for necessary parameters such as access key, region, output format, etcetera.

You can also set `env` as default. Change the default parameter in the root Makefile. Change this line: `PERM_MODEL='custom'` to this: `PERM_MODEL='env'`.

## Structure

```
.
├── aws
├── go-daddy
├── google
├── Makefile
└── Make.sh

3 directories, 2 files
```