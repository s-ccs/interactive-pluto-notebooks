
path_to_dir = abspath("notebooks_precompute/")
@info path_to_dir
using PlutoSliderServer
PlutoSliderServer.run_directory(path_to_dir)
