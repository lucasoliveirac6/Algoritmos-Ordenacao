function HeapSort {
    param (
        [int[]]$arr
    )

    $contagens = @{
        Comparacoes = 0
        Trocas = 0
    }

    function Heapify {
        param (
            [int[]]$arr,
            [int]$n,
            [int]$i
        )

        $maior = $i
        $esq = 2 * $i + 1
        $dir = 2 * $i + 2

        if ($esq -lt $n -and $arr[$esq] -gt $arr[$maior]) {
            $maior = $esq
        }

        if ($dir -lt $n -and $arr[$dir] -gt $arr[$maior]) {
            $maior = $dir
        }

        if ($maior -ne $i) {
            $contagens.Comparacoes++

            $temp = $arr[$i]
            $arr[$i] = $arr[$maior]
            $arr[$maior] = $temp
            $contagens.Trocas++
            
            Heapify -arr $arr -n $n -i $maior
        }
    }

    function OrdenarHeap {
        param (
            [int[]]$arr,
            [int]$n
        )

        for ($i = [math]::Floor($n / 2) - 1; $i -ge 0; $i--) {
            Heapify -arr $arr -n $n -i $i
        }

        for ($i = $n - 1; $i -gt 0; $i--) {
            $temp = $arr[0]
            $arr[0] = $arr[$i]
            $arr[$i] = $temp
            $contagens.Trocas++

            Heapify -arr $arr -n $i -i 0
        }
    }

    OrdenarHeap -arr $arr -n $arr.Length

    return @{
        Array = $arr
        Comparacoes = $contagens.Comparacoes
        Trocas = $contagens.Trocas
    }
}

function ImprovedBubbleSort {
    param([int[]]$arr)
    
    $trocas = 0
    $comparacoes = 0

    $n = $arr.Length
    for ($i = 0; $i -lt $n; $i++) {
        $troca = $false
        for ($j = 0; $j -lt $n - 1 - $i; $j++) {
            $comparacoes++
            if ($arr[$j] -gt $arr[$j + 1]) {
                $trocas++
                $temp = $arr[$j]
                $arr[$j] = $arr[$j + 1]
                $arr[$j + 1] = $temp
                $troca = $true
            }
        }
        if (-not $troca) {
            break
        }
    }
    return @{ Array = $arr; Comparacoes = $comparacoes; Trocas = $trocas }
}

function InsertionSort {
    param([int[]]$arr)
    
    $trocas = 0
    $comparacoes = 0

    $n = $arr.Length
    for ($i = 1; $i -lt $n; $i++) {
        $key = $arr[$i]
        $j = $i - 1

        while ($j -ge 0) {
            $comparacoes++
            if ($arr[$j] -gt $key) {
                $trocas++
                $arr[$j + 1] = $arr[$j]
                $j--
            } else {
                break
            }
        }
        $arr[$j + 1] = $key
    }
    return @{ Array = $arr; Comparacoes = $comparacoes; Trocas = $trocas }
}

function SelectionSort {
    param([int[]]$arr)
    
    $trocas = 0
    $comparacoes = 0

    $n = $arr.Length
    for ($i = 0; $i -lt $n - 1; $i++) {
        $minIndex = $i
        for ($j = $i + 1; $j -lt $n; $j++) {
            $comparacoes++
            if ($arr[$j] -lt $arr[$minIndex]) {
                $minIndex = $j
            }
        }
        if ($minIndex -ne $i) {
            $trocas++
            $temp = $arr[$i]
            $arr[$i] = $arr[$minIndex]
            $arr[$minIndex] = $temp
        }
    }
    return @{ Array = $arr; Comparacoes = $comparacoes; Trocas = $trocas }
}

function BubbleSort {
    param([int[]]$arr)
    
    $trocas = 0
    $comparacoes = 0

    $n = $arr.Length
    for ($i = 0; $i -lt $n; $i++) {
        for ($j = 0; $j -lt $n - 1 - $i; $j++) {
            $comparacoes++
            if ($arr[$j] -gt $arr[$j + 1]) {
                $trocas++
                $temp = $arr[$j]
                $arr[$j] = $arr[$j + 1]
                $arr[$j + 1] = $temp
            }
        }
    }
    return @{ Array = $arr; Comparacoes = $comparacoes; Trocas = $trocas }
}

function MergeSort {
    param (
        [int[]]$arr
    )

    $contagens = @{
        Comparacoes = 0
        Trocas = 0
    }

    function Mesclar {
        param (
            [int[]]$esq,
            [int[]]$dir
        )

        $result = @()
        $i = 0
        $j = 0

        while ($i -lt $esq.Length -and $j -lt $dir.Length) {
            $contagens.Comparacoes++

            if ($esq[$i] -le $dir[$j]) {
                $result += $esq[$i]
                $i++
            } else {
                $result += $dir[$j]
                $j++
            }
        }

        while ($i -lt $esq.Length) {
            $result += $esq[$i]
            $i++
        }

        while ($j -lt $dir.Length) {
            $result += $dir[$j]
            $j++
        }

        return $result
    }

    function Ordenar {
        param (
            [int[]]$arr
        )

        if ($arr.Length -le 1) {
            return $arr
        }

        $meio = [math]::Floor($arr.Length / 2)
        $esq = $arr[0..($meio - 1)]
        $dir = $arr[$meio..($arr.Length - 1)]

        $esq = Ordenar -arr $esq
        $dir = Ordenar -arr $dir

        return Mesclar -esq $esq -dir $dir
    }

    $arrOrdenado = Ordenar -arr $arr

    return @{
        Array = $arrOrdenado
        Comparacoes = $contagens.Comparacoes
        Trocas = $contagens.Trocas
    }
}

function QuickSort {
    param (
        [int[]]$arr
    )

    $contagens = @{
        Comparacoes = 0
        Trocas = 0
    }

    function Particionar {
        param (
            [int[]]$arr,
            [int]$esq,
            [int]$dir
        )

        $meio = [math]::Floor(($esq + $dir) / 2)
        $pivo = $arr[$meio]

        $arr[$meio] = $arr[$dir]
        $arr[$dir] = $pivo
        $contagens.Trocas++

        $i = $esq - 1

        for ($j = $esq; $j -lt $dir; $j++) {
            $contagens.Comparacoes++

            if ($arr[$j] -le $pivo) {
                $i++
                $temp = $arr[$i]
                $arr[$i] = $arr[$j]
                $arr[$j] = $temp
                $contagens.Trocas++
            }
        }

        $temp = $arr[$i + 1]
        $arr[$i + 1] = $arr[$dir]
        $arr[$dir] = $temp
        $contagens.Trocas++

        return $i + 1
    }

    function Ordenar {
        param (
            [int[]]$arr,
            [int]$esq,
            [int]$dir
        )

        if ($esq -lt $dir) {
            $pivoIndex = Particionar -arr $arr -esq $esq -dir $dir

            Ordenar -arr $arr -esq $esq -dir ($pivoIndex - 1)
            Ordenar -arr $arr -esq ($pivoIndex + 1) -dir $dir
        }
    }

    Ordenar -arr $arr -esq 0 -dir ($arr.Length - 1)

    return @{
        Array = $arr
        Comparacoes = $contagens.Comparacoes
        Trocas = $contagens.Trocas
    }
}

function CycleSort {
    param([int[]]$arr)

    $trocas = 0
    $comparacoes = 0
    $n = $arr.Length

    for ($cycleStart = 0; $cycleStart -lt $n - 1; $cycleStart++) {
        $item = $arr[$cycleStart]
        $position = $cycleStart

        for ($i = $cycleStart + 1; $i -lt $n; $i++) {
            $comparacoes++
            if ($arr[$i] -lt $item) {
                $position++
            }
        }

        if ($position -eq $cycleStart) {
            continue
        }

        while ($item -eq $arr[$position]) {
            $position++
        }

        if ($position -ne $cycleStart) {
            $trocas++
            $temp = $arr[$position]
            $arr[$position] = $item
            $item = $temp
        }

        while ($position -ne $cycleStart) {
            $position = $cycleStart

            for ($i = $cycleStart + 1; $i -lt $n; $i++) {
                $comparacoes++
                if ($arr[$i] -lt $item) {
                    $position++
                }
            }

            while ($item -eq $arr[$position]) {
                $position++
            }

            if ($position -ne $cycleStart) {
                $trocas++
                $temp = $arr[$position]
                $arr[$position] = $item
                $item = $temp
            }
        }
    }

    return @{ Array = $arr; Comparacoes = $comparacoes; Trocas = $trocas }
}