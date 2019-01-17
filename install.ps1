[CmdletBinding()]
Param(
	[String] $TexMFRoot = "~/texmf"
)

$class = "brandeis-problemset"
$dest = (Join-Path $TexMFRoot  "tex/latex/$class")
If(!(Test-Path $dest)) {
	mkdir $dest
}

cp "$class.cls" $dest
pushd
cd ~
kpsewhich "$class.cls"
popd
