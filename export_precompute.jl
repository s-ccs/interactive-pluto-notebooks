
path_to_dir = abspath("./notebooks_precompute/")
@info path_to_dir
using PlutoSliderServer
PlutoSliderServer.export_directory(path_to_dir, Export_output_dir="./output/", Export_offer_binder=true,Precompute_enabled=true,Precompute_max_filesize_per_group = 1500000000)
#PlutoSliderServer.export_directory(path_to_dir,Export_offer_binder=true)

