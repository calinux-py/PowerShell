$phrase = "In this world, those who seek to create find purpose, while those who seek to destroy find only emptiness."

$ab = $phrase

$ba = $ab.Substring(4,1)
$bb = $ab.Substring(19,1)
$aa = $ab. Substring(11,1)
$ac = $aa*2+$ab. Substring(9,1)

$i = "$ba$bb$ac"

$cc = [char]([char[]]$ab)[1];$1i = $ab.Substring(3,1)
$ii = $i. Substring(1,1)
$11 = " " + $ab.Substring(46,1)
$1 = ([char]115)
$cb = $ii
$ca = $ab.Substring(10,1)
$bc = "$cc$ii"
$ic = "$1i$11$1$cb"
$i1 = "$bc$ic$ca"

$a = $i1
$ia = $ab.Substring(3,1);$ai = $ab.Substring(4,1);$bi = $ab.Substring(19,1)
$ci = $i + " "
$c1 = "$ci$ia"
$a1 = "$ai$bi"
$b1 = "$ca$ii"

$c = "$c1$a1$b1"

Write-Host $c
Invoke-Expression $a