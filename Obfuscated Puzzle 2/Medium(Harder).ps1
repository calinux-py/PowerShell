$phrase = "In this world, those who seek to create find purpose, while those who seek to destroy find only emptiness."
$numbers = '123456789 @$%^*><":\.'
$alph = "abcdefghijklmnopqrstuvwxyz"

$ab = $phrase
$ad = $numbers
$da = $alph

$ac = $aa*2+$ab. Substring(9,1)
$aa = $ab. Substring(11,1)
$ba = $ab.Substring(4,1)
$bb = $ab.Substring(19,1)

$i = "$ba$bb$ac"

$ii = $i. Substring(1,1)
$1 = ([char]115)
$ca = $ab.Substring(10,1)
$cc = [char]([char[]]$ab)[1];$1i = $ab.Substring(3,1)
$11 = " " + $ab.Substring(46,1)
$cb = $ii

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

$c2 = $ab.Substring(2,1);$a2 = $ad.Substring(15,1);$b3 = $ab.Substring(19,1);$b2 = $ad.Substring(17,1);$a3 = $ad.Substring(11,1)
$c3 = $ab.Substring(1,1); $1b = $da.Substring(21,1); $1d = $ad.Substring(18,1);$1c = $da.Substring(20,1);$2c = $da.Substring(0,1)
$1d = $da.Substring(12,1); $3d = $ad.Substring(18,1); $d3 = $da.Substring(15,1); $a4 = $ab.Substring(10,1); $c4 = $da.Substring(14,1);
$d1 = $da.Substring(5,1); $d2 = $da.Substring(8,1); $2c = $da.Substring(11,1); $4c = $ad.Substring(19,1); $gg = $da.Substring(3,1);
$g1 = $da.Substring(10,1); $g2 = $ab.Substring(3,1);$g3 = $ad.Substring(20,1)

$66 = "01110100 01111000 01110100"
$67 = ($binaryString -split ' ').ForEach({ [char][Convert]::ToInt32($_, 2) }) -join ''

$r = "$gg$b3$1$g1$g2$c4$d3$4c$i$g3$67$b2"
$3 = "$b3$c3$1b$3d$1c$1$b3$ca$d3$a4$c4$d1$d2$2c$b3$4c";$y = "$a$c2$a2$c2$b2$a3"

$x = "$c";$x = "$y$3$r";iex $x

Write-Host $c
