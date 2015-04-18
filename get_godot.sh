TEMPLATE_D=~/.godot/templates
mkdir -p bin
cd bin
curl -o linux_server https://godot.blob.core.windows.net/devel/2014-11-27/linux_server-1.0devel.64
curl -o templates.tpz https://godot.blob.core.windows.net/release/2015-04-02/export_templates-1.1beta1.tpz
chmod +x linux_server
echo $TEMPLATE_D
mkdir -p $TEMPLATE_D
unzip -o templates.tpz -d $TEMPLATE_D
