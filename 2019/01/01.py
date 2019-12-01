import os

assert os.path.isfile("data.txt"), "input must be saved in '2019/01/data.txt'"
with open("data.txt") as f:
    module_masses = [int(mass) for mass in f.readlines()]

# part 1
fuel = sum([mass // 3 - 2 for mass in module_masses])
print(f"Part 1 Fuel Required: {fuel}")

# part 2
def calc_fuel_required(mass):
    fuel = mass // 3 - 2
    return 0 if fuel <= 0 else fuel + calc_fuel_required(fuel)

fuel = sum([calc_fuel_required(mass) for mass in module_masses])
print(f"Part 2 Fuel Required: {fuel}")
