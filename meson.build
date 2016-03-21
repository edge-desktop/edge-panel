project(
'opplyse',
['vala', 'c']
)

name = 'edge-panel'

sources = []

dependencies = []
dependencies += dependency('glib-2.0', version : '>=2.32')
dependencies += dependency('gobject-2.0')
dependencies += dependency('gtk+-3.0')

subdir('src')

executable(
name,
sources,
dependencies : dependencies,
vala_args : '--target-glib=2.32'
)
