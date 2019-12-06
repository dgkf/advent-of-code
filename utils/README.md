# Advent of Code Utils

Scripts for pulling advent of code inputs directly.

## Configuring user cookies

Both scripts expect a `./cookies.secret` file with the session cookie for the 
input from a session on the advent of code website. This can be found using
an inspector for network requests in most web browsers.

**./cookies.secret**
```txt
session=<96 character session token>
```

## Running the scripts

On a \*nix system you can use a `sh` to run `./aoc-input.sh`

```sh
sh ./aoc-input.sh 2019 1
```

On a Windows system, use powershell to run `./aoc-input.ps1`

```powershell
./aoc-input.ps1 2019 1
```

## Piping output

Naturally, you can pipe output into a julia script as *stdin*, which each of 
the solutions expects.

```sh
sh utils/aoc-input.sh 2019 1 | julia 2019/01/01.jl
```

