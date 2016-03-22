project(
'edge-panel',
['vala', 'c']
)

name = 'edge-panel'

sources = []

dependencies = []
dependencies += dependency('glib-2.0', version : '>=2.32')
dependencies += dependency('gobject-2.0')
dependencies += dependency('gtk+-3.0')

subdir('src')

conf_data = configuration_data()
configure_file(
input : 'src/edge-panel.css',
output : 'edge-panel.css',
configuration : conf_data,
install : true,
install_dir : 'share/edge-panel/',
)

executable(
name,
sources,
dependencies : dependencies,
vala_args : '--target-glib=2.32',
install : true,
install_dir : 'bin/',
)
