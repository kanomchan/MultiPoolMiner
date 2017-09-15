﻿. .\Include.ps1

$Threads = 3

$Path = ".\Bin\Excavator\excavator.exe"
$Uri = "https://github.com/nicehash/excavator/releases/"

$Commands = [PSCustomObject]@{
    #"blake2s" = @() #Blake2s
    "decred" = @() #Decred
    "daggerhashimoto" = @() #Ethash
    "equihash" = @() #Equihash
    #"lbry" = @() #Lbry
    #"lyra2rev2" = @() #Lyra2RE2
    "pascal" = @() #Pascal
    "sia" = @() #Sia
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName
$Port = 3456 + (0 * 10000)

$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | ForEach-Object {
    try {
        if ((Get-Algorithm $_) -ne "Decred" -and (Get-Algorithm $_) -ne "Sia") {
            if (Test-Path (Split-Path $Path)) {
                [PSCustomObject]@{time = 0; commands = @([PSCustomObject]@{id = 1; method = "algorithm.add"; params = @("$_", "$((Resolve-DnsName $Pools.$(Get-Algorithm $_).Host -ErrorAction Stop).IPAddress | Select-Object -First 1):$($Pools.$(Get-Algorithm $_).Port)", "$($Pools.$(Get-Algorithm $_).User):$($Pools.$(Get-Algorithm $_).Pass)")})},
                [PSCustomObject]@{time = 3; commands = @([PSCustomObject]@{id = 1; method = "worker.add"; params = @("0", "0") + $Commands.$_}) * $Threads},
                [PSCustomObject]@{time = 3; commands = @([PSCustomObject]@{id = 1; method = "worker.add"; params = @("0", "1") + $Commands.$_}) * $Threads},
                [PSCustomObject]@{time = 3; commands = @([PSCustomObject]@{id = 1; method = "worker.add"; params = @("0", "2") + $Commands.$_}) * $Threads},
                [PSCustomObject]@{time = 3; commands = @([PSCustomObject]@{id = 1; method = "worker.add"; params = @("0", "3") + $Commands.$_}) * $Threads},
                [PSCustomObject]@{time = 3; commands = @([PSCustomObject]@{id = 1; method = "worker.add"; params = @("0", "4") + $Commands.$_}) * $Threads},
                [PSCustomObject]@{time = 3; commands = @([PSCustomObject]@{id = 1; method = "worker.add"; params = @("0", "5") + $Commands.$_}) * $Threads},
                [PSCustomObject]@{time = 10; loop = 10; commands = @([PSCustomObject]@{id = 1; method = "algorithm.print.speeds"; params = @("0")})} | ConvertTo-Json -Depth 10 | Set-Content "$(Split-Path $Path)\$($Pools.$(Get-Algorithm $_).Name)_$(Get-Algorithm $_)_$($Threads).json" -Force -ErrorAction Stop
            }

            [PSCustomObject]@{
                Type = "AMD", "NVIDIA"
                Path = $Path
                Arguments = "-p $Port -c $($Pools.$(Get-Algorithm $_).Name)_$(Get-Algorithm $_)_$($Threads).json"
                HashRates = [PSCustomObject]@{$(Get-Algorithm $_) = $Stats."$($Name)_$(Get-Algorithm $_)_HashRate".Week}
                API = "NiceHash"
                Port = $Port
                Wrap = $false
                URI = $Uri
            }
        }
        else {
            if (Test-Path (Split-Path $Path)) {
                [PSCustomObject]@{time = 0; commands = @([PSCustomObject]@{id = 1; method = "algorithm.add"; params = @("$_", "$((Resolve-DnsName $Pools."$(Get-Algorithm $_)NiceHash".Host -ErrorAction Stop).IPAddress | Select-Object -First 1):$($Pools."$(Get-Algorithm $_)NiceHash".Port)", "$($Pools."$(Get-Algorithm $_)NiceHash".User):$($Pools."$(Get-Algorithm $_)NiceHash".Pass)")})},
                [PSCustomObject]@{time = 3; commands = @([PSCustomObject]@{id = 1; method = "worker.add"; params = @("0", "0") + $Commands.$_}) * $Threads},
                [PSCustomObject]@{time = 3; commands = @([PSCustomObject]@{id = 1; method = "worker.add"; params = @("0", "1") + $Commands.$_}) * $Threads},
                [PSCustomObject]@{time = 3; commands = @([PSCustomObject]@{id = 1; method = "worker.add"; params = @("0", "2") + $Commands.$_}) * $Threads},
                [PSCustomObject]@{time = 3; commands = @([PSCustomObject]@{id = 1; method = "worker.add"; params = @("0", "3") + $Commands.$_}) * $Threads},
                [PSCustomObject]@{time = 3; commands = @([PSCustomObject]@{id = 1; method = "worker.add"; params = @("0", "4") + $Commands.$_}) * $Threads},
                [PSCustomObject]@{time = 3; commands = @([PSCustomObject]@{id = 1; method = "worker.add"; params = @("0", "5") + $Commands.$_}) * $Threads},
                [PSCustomObject]@{time = 10; loop = 10; commands = @([PSCustomObject]@{id = 1; method = "algorithm.print.speeds"; params = @("0")})} | ConvertTo-Json -Depth 10 | Set-Content "$(Split-Path $Path)\$($Pools."$(Get-Algorithm $_)NiceHash".Name)_$(Get-Algorithm $_)_$($Threads).json" -Force -ErrorAction Stop
            }
            
            [PSCustomObject]@{
                Type = "AMD", "NVIDIA"
                Path = $Path
                Arguments = "-p $Port -c $($Pools."$(Get-Algorithm $_)NiceHash".Name)_$(Get-Algorithm $_)_$($Threads).json"
                HashRates = [PSCustomObject]@{"$(Get-Algorithm $_)NiceHash" = $Stats."$($Name)_$(Get-Algorithm $_)NiceHash_HashRate".Week}
                API = "NiceHash"
                Port = $Port
                Wrap = $false
                URI = $Uri
            }
        }
    }
    catch {
    }
}