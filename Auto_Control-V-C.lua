
local component = require("component")
local computer = require("computer")


Addresses_rod = {}

Addresses_fluid = {}

Addresses_Energy = {}

Addresses_Fuel = {}

Addresses_Geiger = {}

Addresses_Boiler = {}

list_of_energy = {1800000,18000000,180000000,900000000,4500000000,72000000000}
list_of_prefix = {"1.8 MHE","18 MHE","18 MHE","90 MHE","4.5 GHE","72 GHE"}

for id,name in component.list() do 
  if name == "rbmk_control_rod" then
    table.insert(Addresses_rod,id)
  end
  if name == "ntm_fluid_gauge" then
    table.insert(Addresses_fluid,id)
  end
  if name == "ntm_energy_storage" then
    table.insert(Addresses_Energy,id)
  end
  if name == "rbmk_fuel_rod" or name == "rbmk_fuel_rod_reasim" then
    table.insert(Addresses_Fuel,id)
  end
  if name == "ntm_geiger" then
    table.insert(Addresses_Geiger,id)
  end
  if name == "rbmk_boiler" then
    table.insert(Addresses_Boiler,id)
  end
end

os.execute("clear")

print("Print Address? y/n:")
local answer_u = io.read()

os.execute("clear")

print("Enter the maximum temperature (the rods will lower when this temperature is reached(I recomend 650)):")
local max_Temp = tonumber(io.read())

os.execute("clear")

print("Show info about control rods? y/n:")
local rods_u = io.read()

os.execute("clear")

os.execute("clear")
print("Booting.")
os.sleep(1)
os.execute("clear")
print("Booting..")
os.sleep(1)
os.execute("clear")
print("Booting...")
os.sleep(1)

computer.beep(1000, 0.2)

while true do
  os.sleep(1)
  os.execute("clear")
  if rods_u == "y" then
    print("---------------------------------------------------------------------------------------------------------------------------------------------------------------")
    print("Rod Status:")
  end
  for i = 1, #Addresses_rod do
    local address = Addresses_rod[i]
    if answer_u == "y" and rods_u == "y" then
      print("Checking Rod",i,"at address:",address,"|")
    end

    local successLevel, resultLevel = pcall(component.invoke, address, "getLevel")
    local successTemp, resultTemp = pcall(component.invoke, address, "getHeat")

    if rods_u == "y" and resultTemp <= max_Temp then
      if successLevel and successTemp then
        print("* Rod", i,"|", "Level:", resultLevel,"|" ,"Temperature:\27[31m",math.floor(resultTemp),"\27[m °C       |")
        os.sleep(0.01)
      else
        print("Error getting info of Rod:",i,"at address:",address)
        os.sleep(0.01)
      end
    end

    if successLevel and successTemp then
      if resultTemp > max_Temp then
        component.invoke(address, "setLevel", 0)
        if rods_u == "y" then
          print ("!* Rod",i,"Was accidentally lowered due to temperature:\27[31m",math.floor(resultTemp),"\27[m °C(check if all systems are ok!)")
        end
        computer.beep(2000, 0.1)
      end
    end
  end
  print("---------------------------------------------------------------------------------------------------------------------------------------------------------------")
  os.sleep(0.5)
  print("Boilers:")
  for b = 1 , #Addresses_Boiler do
    local addresses_boiler = Addresses_Boiler[b]
    if answer_u == "y" then
      print("Cheking Boiler ",b,"at address:",addresses_boiler,"|")
    end

    local successHeat_b , resultHeat_b = pcall(component.invoke,addresses_boiler,"getHeat")
    local successSteam_in_col , resultSteam_in_col = pcall(component.invoke,addresses_boiler,"getSteam")
    local successWater_in_col , resultWater_in_col = pcall(component.invoke,addresses_boiler,"getWater")
    local successSteamType , resultSteamType = pcall(component.invoke,addresses_boiler,"getSteamType")

    SteamType = "Error"

    if successHeat_b and successSteam_in_col and successWater_in_col and successSteamType then
      if resultSteamType == 0 then
        print("* Boiler:",b,"|Temperature:\27[31m",math.floor(resultHeat_b),"\27[m °C| Steam:",resultSteam_in_col,"| Water:\27[34m",resultWater_in_col,"\27[m| Steam Type: \27[37m Steam \27[m")
        os.sleep(0.01)
      end
      if resultSteamType == 1 then
        print("* Boiler:",b,"|Temperature:\27[31m",math.floor(resultHeat_b),"\27[m °C| Steam:",resultSteam_in_col,"| Water:\27[34m",resultWater_in_col,"\27[m| Steam Type: \27[32m Dense Steam \27[m ")
        os.sleep(0.01)
      end
      if resultSteamType == 2 then
        print("* Boiler:",b,"|Temperature:\27[31m",math.floor(resultHeat_b),"\27[m °C| Steam:",resultSteam_in_col,"| Water:\27[34m",resultWater_in_col,"\27[m| Steam Type: \27[33m Super Dense Steam \27[m")
        os.sleep(0.01)
      end
      if resultSteamType == 3 then
        print("* Boiler:",b,"|Temperature:\27[31m",math.floor(resultHeat_b),"\27[m °C| Steam:",resultSteam_in_col,"| Water:\27[34m",resultWater_in_col,"\27[m| Steam Type: \27[31m Ultra Dense Steam \27[m ")
        os.sleep(0.01)
      end
    else
      print("Error getting info of Boiler:",b,"at address:",addresses_boiler)
      os.sleep(0.01)
    end
  end
  print("---------------------------------------------------------------------------------------------------------------------------------------------------------------")
  os.sleep(0.5)
  print("Flow Gauge Pipe:")
  if #Addresses_fluid >= 1 then
      for f = 1, #Addresses_fluid do
        local address_fluid = Addresses_fluid[f]
        if answer_u == "y" then
          print("Cheking Flow pipe",f,"at address:",address_fluid,"|")
        end

        local successFluid_T, resultTransfer = pcall(component.invoke,address_fluid,"getTransfer")
        local successFluid_F, resultFluid = pcall(component.invoke,address_fluid,"getFluid")
    
        if successFluid_T and successFluid_F then
          print("* Flow",f,"| Transfer(Per tick & second):\27[36m",resultTransfer, "\27[mFluid:",resultFluid,"|")
          os.sleep(0.01)
          if resultTransfer <= 0 and resultFluid == "Water" then
            print("the water has run out!")
            os.sleep(0.01)
          end
        else
          print("Error getting info of Flow Gauge Pipe:",f,"at address:",address_fluid)
          os.sleep(0.01)
        end
      end
    else 
        print("No Flow Gauge Pipe conected!")
        os.sleep(0.01)
    end
  print("---------------------------------------------------------------------------------------------------------------------------------------------------------------")
  os.sleep(0.5)
  print("Fuel:")
  for u = 1, #Addresses_Fuel do
    local addresses_fuel = Addresses_Fuel[u]
    if answer_u == "y" then
      print("Cheking fuel column ",u,"at address:",addresses_fuel,"|")
    end

    local successDepletion , resultDepletion = pcall(component.invoke,addresses_fuel,"getDepletion")
    local successXenonPoison , resultXenonPoison = pcall(component.invoke,addresses_fuel,"getXenonPoison")

    if successDepletion and successXenonPoison then
      if type(resultDepletion) == "number" then
        if resultDepletion ~= 0.0 then
          print("* Fuel column",u,"| Depletion:\27[32m",100 - (math.floor((resultDepletion*100))),"\27[m % |","Xenon Poison:\27[35m",math.floor(resultXenonPoison),"\27[m |")
          os.sleep(0.01)
        else
          print("* Fuel column",u,"| Status: \27[31m Depleted! \27[m")
          os.sleep(0.01)
        end
      else 
        print("* Fuel column",u,"| Depletion:","N/A","|","Xenon Poison:","N/A","|")
        os.sleep(0.01)
      end
    else
      if not successDepletion then
        print("Error getting Depletion of fuel column",u,"at address:",addresses_fuel)
        os.sleep(0.01)
      end
    end
  end
  print("---------------------------------------------------------------------------------------------------------------------------------------------------------------")
  os.sleep(0.5)
  print("Geiger counter:")
  if #Addresses_Geiger >= 1 then
    for g = 1 , #Addresses_Geiger do
      local address_geiger = Addresses_Geiger[g]
      if answer_u == "y" then
        print("Cheking Geiger counter ",g,"at address:",address_geiger,"|")
      end

      local successGeiger , resultGeiger = pcall(component.invoke,address_geiger,"getRads")

      if successGeiger then
        print("* Geiger Counter:",g,"| RAD:\27[32m",resultGeiger,"RAD/s \27[m|")
        os.sleep(0.01)
      else
        print("Error getting info of Geiger Counter:",g,"at address:",address_geiger)
        os.sleep(0.01)
      end
    end
  else
    print("No Geiger counter conected!")
    os.sleep(0.01)
  end
  print("---------------------------------------------------------------------------------------------------------------------------------------------------------------")
  os.sleep(0.5)
  if #Addresses_Energy >= 1 then 
    print("Energy:")
    for e = 1, #Addresses_Energy do
      local addresses_energy = Addresses_Energy[e]
      if answer_u == "y" then
        print("Cheking Energy storage ",e,"at address:",addresses_energy,"|")
      end

      local successEnergy , resultEnergy, maxEnergy = pcall(component.invoke,addresses_energy,"getEnergyInfo")

      if successEnergy then
        for max_en = 1, #list_of_energy do
          if maxEnergy == list_of_energy[max_en] then
             maxEnergy_prefix = list_of_prefix[max_en]
          end
        end
        local percent_of_energy = string.format("%.2f", (resultEnergy*100)/maxEnergy)
        print("* Storage",e,"| Charged:\27[32m",percent_of_energy,"\27[m % |","Max capacity:",maxEnergy_prefix,"|")
        os.sleep(0.01)
      else
        if not successEnergy then
          print("Error getting info for storage",e,"at address:",addresses_energy)
          os.sleep(0.01)
        end
      end
    end
  else
    if answer_u == "y" then
      print("")
      print("No energy  ╱|、  ?")
      print("storage   (˚ˎ 。7  ")
      print("          |、˜  〵 ")
      print("          じしˍ,)ノ")
    end
  end
  os.sleep(1)
end
