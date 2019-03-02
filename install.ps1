[CmdletBinding()]
Param(
	[String] $TexMFRoot = "~/texmf"
)

$className = "brandeis-problemset"
$class = "$className.cls"
$package = "$className.sty"
$dest = (Join-Path $TexMFRoot "tex/latex/$className")
If(!(Test-Path $class)) {
    Write-Error "$class should exist but doesn't"
}
If(!(Test-Path $dest)) {
	mkdir $dest
}

cp "$class" $dest
cp "$package" $dest
pushd
cd ~
kpsewhich "$class"
kpsewhich "$package"
popd
