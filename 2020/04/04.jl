input = split.(replace.(split(join(readlines(), "\n"), "\n\n"), "\n" => " "))
passports = map(input) do passport
    p = split.(passport, ":")
    Dict(first.(p) .=> last.(p))
end

reqids = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
n_valid = [0, 0]

for p = passports
    # part 1
    n_valid[1] += all(reqids .∈ [keys(p)])

    # part 2
    if all(reqids .∈ [keys(p)]) &&
        1920 <= parse(Int, get(p, "byr", -1)) <= 2002 &&
        2010 <= parse(Int, get(p, "iyr", -1)) <= 2020 &&
        2020 <= parse(Int, get(p, "eyr", -1)) <= 2030 &&
        match(r"^#[0-9a-f]{6}$", get(p, "hcl", "")) != nothing &&
        get(p, "ecl", "") ∈ ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"] &&
        match(r"^\d{9}$", get(p, "pid", 0)) != nothing

        hgt = match(r"^(\d+)(cm|in)$", get(p, "hgt", ""))

        if hgt != nothing && (
                (hgt[2] == "cm" && (150 <= parse(Int, hgt[1]) <= 193)) ||
                (hgt[2] == "in" && (59 <= parse(Int, hgt[1]) <= 76)))

            n_valid[2] += 1
        end
    end
end
    
println.(n_valid)

