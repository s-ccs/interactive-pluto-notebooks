using JSServe

include("unfoldSimCCN")

try
    close(server)
catch
end
server = Server("127.0.0.1", 8081;proxy_url="https://www2.visus.uni-stuttgart.de/ccs-pluto/jsserve/",verbose=0) 
route!(server,"/"=>app)  