# RFCGraph.jl

making a graph from https://www.rfc-editor.org/retrieve/bulk/
https://en.wikipedia.org/wiki/Request_for_Comments


```julia
julia> tally(g[:tgt])
8476-element Vector{Pair{String, Int64}}:
 "https://datatracker.ietf.org/doc/html/rfc2119" => 8404
 "https://datatracker.ietf.org/doc/html/rfc5741" => 2180
 "https://datatracker.ietf.org/doc/html/rfc3261" => 1138
 "https://datatracker.ietf.org/doc/html/rfc5226" => 1093
 "https://datatracker.ietf.org/doc/html/rfc3986" => 1009
  "https://datatracker.ietf.org/doc/html/rfc793" => 824 # TCP
  "https://datatracker.ietf.org/doc/html/rfc822" => 812
 "https://datatracker.ietf.org/doc/html/rfc7841" => 810
 "https://datatracker.ietf.org/doc/html/rfc5234" => 783
 "https://datatracker.ietf.org/doc/html/rfc8174" => 779
 ```
 