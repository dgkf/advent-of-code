input = split.(split(join(readlines(), "\n"), "\n\n"), r"\s+")
passports = map(passport -> Dict(split.(passport, ":")), input)

reqids = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]

# part 1
count(passports) do p
    all(in(keys(p)), reqids)
end |> println

# part 2
count(passports) do p
    hgt = match(r"^(\d+)(cm|in)$", get(p, "hgt", ""))

    all(in(keys(p)), reqids) &&
    1920 <= parse(Int, get(p, "byr", 0)) <= 2002 &&
    2010 <= parse(Int, get(p, "iyr", 0)) <= 2020 &&
    2020 <= parse(Int, get(p, "eyr", 0)) <= 2030 &&
    occursin(r"^#[0-9a-f]{6}$", get(p, "hcl", "")) &&
    get(p, "ecl", "") ∈ ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"] &&
    occursin(r"^\d{9}$", get(p, "pid", 0)) && 
    hgt isa RegexMatch && (
        (hgt[2] == "cm" && (150 <= parse(Int, hgt[1]) <= 193)) ||
        (hgt[2] == "in" && (59 <= parse(Int, hgt[1]) <= 76))
    )
end |> println
