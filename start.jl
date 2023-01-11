
path_to_dir = abspath("´notebooks/")
@info path_to_dir
using PlutoSliderServer
PlutoSliderServer.run_directory(path_to_dir)
