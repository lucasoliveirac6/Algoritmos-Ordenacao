$caminhoModulo = "C:\Users\lucas\OneDrive\Faculdade\10º Semestre\Analise de Algoritmos\N2\Ordenação\Novo\Algoritmos-de-Ordenacao.psm1"
Import-Module -Name $caminhoModulo

# ---- Inicio ---- #

$algoritmosOrdenacao = [PSCustomObject]@{
    QuickSort = $Function:QuickSort
    HeapSort = $Function:HeapSort
    MergeSort = $Function:MergeSort
    BubbleSort = $Function:BubbleSort
    ImprovedBubbleSort = $Function:ImprovedBubbleSort
    InsertionSort = $Function:InsertionSort
    SelectionSort = $Function:SelectionSort
    CycleSort = $Function:CycleSort
}

if (!(Test-Path "$($env:USERPROFILE)\Desktop\Comparativos-Algoritmos")) {
    New-Item "$($env:USERPROFILE)\Desktop\Comparativos-Algoritmos" -ItemType Directory | Out-Null
}

@"
Algoritmo;Melhor-Caso;Comp-MelhorCaso;Trocas-MelhorCaso;Caso-Medio;Comp-CasoMedio;Trocas-CasoMedio;Pior-Caso;Comp-PiorCaso;Trocas-PiorCaso
"@ >> "$($env:USERPROFILE)\Desktop\Comparativos-Algoritmos\Mil.txt"

# Declaracao das listas
$tamanhoEntrada = 100000

$listaBaguncada = 1..$tamanhoEntrada | % {Get-Random -Minimum 1 -Maximum $tamanhoEntrada}
$listaAoContrario = @($tamanhoEntrada..1)
$listaOrdenada = @(1..$tamanhoEntrada)

$comparativoMilisegundos = @()

Write-Warning "LISTAS GERADAS"

$startTime = [datetime]::now

foreach ($algoritmo in $algoritmosOrdenacao.PSObject.Properties) {
    Write-Warning "USANDO ALGORITMO - $($algoritmo.Name)"

    $timeListaBaguncada = (Measure-Command {
        $algoritmoExecutado = (& $algoritmo.Value -arr $listaBaguncada)
        $comparacoesBaguncado = $algoritmoExecutado.Comparacoes
        $trocasBaguncado = $algoritmoExecutado.Trocas
    }).TotalMilliseconds

    $timeListaAoContrario = (Measure-Command {
        $algoritmoExecutado = (& $algoritmo.Value -arr $listaAoContrario)
        $comparacoesAoContrario = $algoritmoExecutado.Comparacoes
        $trocasAoContrario = $algoritmoExecutado.Trocas
    }).TotalMilliseconds

    $timeListaOrdenada = (Measure-Command {
        $algoritmoExecutado = (& $algoritmo.Value -arr $listaOrdenada)
        $comparacoesOrdenado = $algoritmoExecutado.Comparacoes
        $trocasOrdenado = $algoritmoExecutado.Trocas
    }).TotalMilliseconds

    $comparativo = [PSCustomObject]@{
        "Algoritmo" = $algoritmo.Name

        "Ordenado" = "{0:f4}" -f $timeListaOrdenada
        "ComparacoesOrdenado" = $comparacoesOrdenado
        "TrocasOrdenado" = $trocasOrdenado

        "Baguncado" = "{0:f4}" -f $timeListaBaguncada
        "ComparacoesBaguncado" = $comparacoesBaguncado
        "TrocasBaguncado" = $trocasBaguncado

        "AoContrario" = "{0:f4}" -f $timeListaAoContrario
        "ComparacoesAoContrario" = $comparacoesAoContrario
        "TrocasAoContrario" = $trocasAoContrario
    }
    

    $comparativoMilisegundos += $comparativo 
    $comparativo.PSObject.Properties.Value `
        -join ";" >> "$($env:USERPROFILE)\Desktop\Comparativos-Algoritmos\Mil.txt"
}

$endTime = [Datetime]::Now

$timeLapse = $endTime - $startTime

$comparativoMilisegundos | FT