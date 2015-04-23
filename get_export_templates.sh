mkdir -p bin
cd bin
curl -o templates.tpz https://godot.blob.core.windows.net/release/2015-04-02/export_templates-1.1beta1.tpz
TEMPLATE_D=~/.godot/templates
echo $TEMPLATE_D
mkdir -p $TEMPLATE_D
unzip -o templates.tpz -d $TEMPLATE_D
