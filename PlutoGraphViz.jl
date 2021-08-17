### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 7fb69cf0-fc66-11eb-256f-cb6e9d2db156
using PlutoUI, HypertextLiteral, LightGraphs

# ╔═╡ 20ad770b-34a1-49e7-b948-e12f46bde5ee
using HypertextLiteral: JavaScript

# ╔═╡ 59cef39a-3577-4726-aeff-960ad5b580c5
tprint(input) = with_terminal() do 
	println(input)
end

# ╔═╡ c8ba27b1-4d2b-4afc-89a9-806be91534dc
TableOfContents()

# ╔═╡ ef077759-88ad-4655-b04f-83c80270d320
md"""
## Functions and Constants
"""

# ╔═╡ a626d3c1-ba41-4b91-a2a2-6ff69cd13bce
const BTN_STYLE = """
.btn-group, .btn-group-vertical {
    position: relative;
    display: inline-block;
    vertical-align: middle;
}

.btn-group button {
	background-color: #04AA6D;
	border: 1px solid green;
	color: white;
	padding: 10px 10px;
	cursor: pointer;
	float: left;
	border-radius: 10px;
}

.btn-group button:not(:last-child) {
	border-right: none;
}

.btn-group button:hover {
	background-color: #3e8e41;
}

.btn-group > button:not(:first-child):not(:last-child) {
	border-radius: 0;
}

	.btn-group > button:last-child:not(:first-child){
	border-top-left-radius: 0;
	border-bottom-left-radius: 0;
}

.btn-group > button:first-child:not(:last-child) {
	border-top-right-radius: 0;
	border-bottom-right-radius: 0;
}
"""

# ╔═╡ 1b685538-828a-4c58-bfbf-845e4bd7c26e
function graphdata(g::AbstractGraph)
	vs = ""
	for v in vertices(g)
		vs *= "\t\t{ data: {id: '$v', label: '$v'} },\n"
	end
	
	es = ""
	for e in edges(g)
		es *= "\t\t{ data: {id: '$(e.src)-->$(e.dst)', source: '$(e.src)', target: '$(e.dst)' } },\n"
	end
	
	output = """
	{
		nodes: [
	$vs
		],
		edges: [
	$es
		]
	}
	"""
end

# ╔═╡ 2eb9f81b-792c-4e45-a4e5-b3364aa3b391
function minify(input::String)
	input = replace(input, "\n"=>"")
	input = replace(input, "\t"=>" ")
	input = replace(input, r"\s{2,}"=>"")
	input = replace(input, '"'=>"")
	return input
end

# ╔═╡ 6c871573-e5b0-49c4-8b38-4800922483dc
md"""
## Interactive GraphViz
"""

# ╔═╡ aa0a5db5-1c71-4756-8c7f-821b85a06ba7
small_graphs = Dict(
	"bull graph" => :bull, 
	"Chvátal graph" => :chvatal, 
	"Platonic cubical graph" => :cubical, 
	"Desarguesgraph" => :desargues, 
	"diamond graph" => :diamond, 
	"Platonic dodecahedral graph" => :dodecahedral, 
	"Frucht graph" => :frucht, 
	"Heawood graph" => :heawood, 
	"graph mimicing the classic outline of a house" => :house, 
	"house graph, with two edges crossing the bottom square" => :housex, 
	"Platonic icosahedral graph" => :icosahedral, 
	"Krackhardt-Kite social network graph" => :krackhardtkite, 
	"Möbius-Kantor graph" => :moebiuskantor, 
	"Platonic octahedral graph" => :octahedral, 
	"Pappus graph" => :pappus, 
	"Petersen graph" => :petersen, 
	"Maze graph used in Sedgewick's Algorithms" => :sedgewickmaze, 
	"Platonic tetrahedral graph" => :tetrahedral, 
	"skeleton of the truncated cube graph" => :truncatedcube, 
	"skeleton of the truncated tetrahedron graph" => :truncatedtetrahedron, 
	"skeleton of the truncated tetrahedron digraph" => :truncatedtetrahedron_dir, 
	"Tutte graph" => :tutte
)

# ╔═╡ d8a11fab-d87e-434f-9833-2192ca0b302f
md"""
## Graph Styles
"""

# ╔═╡ 7741e7a6-931b-4f47-91bb-2ac61e0e1342
style1 = """
node {
	content: data(id);
	text-valign: center;
	text-halign: center;
	opacity: 0.75;
}

edge {
	curve-style: bezier;
	target-arrow-shape: triangle;
	opacity: 0.5;
}
"""

# ╔═╡ 2a119909-c45c-4154-b85d-ef55ba8fbe8a
style2 = """
node {
  background-color: yellow;
  border-color: black;
  width: 20;
  height: 20;
  min-zoomed-font-size: 12;
  color: #fff;
  font-size: 16;
  z-index: 1;
}

node:selected,
node.start,
node.end {
  height: 30;
  width: 30;
  min-zoomed-font-size: 0;
  font-size: 48;
  border-color: #000;
  border-width: 4px;
  text-outline-color: #000;
  text-outline-width: 10px;
  z-index: 9999;
}


edge {
  min-zoomed-font-size: 12;
  font-size: 8;
  color: #fff;
  line-color: green;
  width: 20;
  curve-style: haystack;
  haystack-radius: 0;
  opacity: 0.5;
}

"""

# ╔═╡ 94ada1f4-9484-4f5d-90b2-a99165dd9f8c
style_green = """
node {
	content: data(id);
	text-valign: center;
	text-halign: center;
	background-color: #126814;
}

edge {
	line-color: #126814;
	opacity: 0.5;
}
"""

# ╔═╡ 401148b3-b3ef-46f9-9869-f3da8d54f6ea
style_dict = Dict(
	"Simple Gray (Directed)" => style1,
	"Green and Yellow" => style2,
	"Simple Green (Undirected)" => style_green,
)

# ╔═╡ cc203fb4-4755-45cc-8b9b-d06048623ec9
md"""
### Interactive Demo

**Graph Appearance:** $(@bind style Select(collect(keys(style_dict))))

**Layout Method:** $(@bind layout Select(["cose", "random", "circle", "concentric", "breadthfirst", "grid"])) **Animate:** $(@bind animate CheckBox(false))

**Sample Graph:** $(@bind sg_name Select(collect(keys(small_graphs))))

"""

# ╔═╡ 824c7e26-5bf8-4272-a4f0-e366271c8221
sg = smallgraph(small_graphs[sg_name])

# ╔═╡ 78405683-feee-4ff1-ac93-675c92d01a12
function graphviz(g::AbstractGraph, name="cy", style=style1; layout="cose", animate=false)
	gd = graphdata(sg)
	
	layout_block = """
	{
		name: '$layout',
		padding: 5,
		animate: $animate
	}
	"""
	
	# Testing loading styles from file
	# style_text = read(joinpath(pwd(), "tokyo-railways.cycss"), String)
	# style_text = minify(style_text)
	graph_style = minify(style)
	
	cyjs = JavaScript("""
		var prnt = currentScript.parentElement;
		var fit_button = prnt.querySelector("button#fit");
		var center_button = prnt.querySelector("button#center");
		var layout_button = prnt.querySelector("button#layout");
		var download_button = prnt.querySelector("button#download");
		
		var graph_style = '$graph_style';
		

		var cy = window.cy = cytoscape({
			container: document.getElementById('$name'),
			boxSelectionEnabled: false,
			style: graph_style,
			elements: $gd,
			layout: $layout_block
		});
		fit_button.addEventListener("click", (e) => {cy.fit()});
		center_button.addEventListener("click", (e) => { cy.center() });
		
		var layout = cy.layout($layout_block);
		layout_button.addEventListener("click", (e) => { layout.run() });
		
		download_button.addEventListener("click", (e) => { 
			var png64 = cy.png()
			var aDownloadLink = document.createElement('a');
			aDownloadLink.href = png64;
			aDownloadLink.target = '_blank';
			aDownloadLink.click();
		});
	""")

	output = htl"""
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" integrity="sha512-1ycn6IcaQQ40/MKBW2W4Rhis/DbILU74C1vSrLJxCq57o941Ym01SwNsOMqvEBFlcgUa6xLiPY/NS5R+E6ztJQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
	<script src="https://cdn.jsdelivr.net/npm/cytoscape@3.19.0/dist/cytoscape.min.js"></script>
	<style>$BTN_STYLE></style>

	<div>
		<script>$cyjs</script>
	
		<div class="btn-group">
			<button id="fit"><i class="fas fa-home"></i></button>
			<button id="center"><i class="fas fa-compress-arrows-alt"></i></button>
			<button id="layout"><i class="fas fa-redo"></i></button>
			<button id="download"><i class="fas fa-download"></i></button>
		</div>

		<div id="$name" style="min-height:680px"></div>
	</div>
	""" 
end 

# ╔═╡ 546baf39-09e0-46a1-8df3-b39ba04aa11f
graphviz(sg, "demo", style_dict[style], layout=layout, animate=animate)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
LightGraphs = "093fc24a-ae57-5d10-9952-331d41423f4d"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
HypertextLiteral = "~0.9.0"
LightGraphs = "~1.3.5"
PlutoUI = "~0.7.9"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "f87e559f87a45bece9c9ed97458d3afe98b1ebb9"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.1.0"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "79b9563ef3f2cc5fc6d3046a5ee1a57c9de52495"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.33.0"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "7d9d316f04214f7efdbb6398d545446e246eff02"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.10"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[HypertextLiteral]]
git-tree-sha1 = "72053798e1be56026b81d4e2682dbe58922e5ec9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.0"

[[Inflate]]
git-tree-sha1 = "f5fc07d4e706b84f72d54eedcc1c13d92fb0871c"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.2"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[LightGraphs]]
deps = ["ArnoldiMethod", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "432428df5f360964040ed60418dd5601ecd240b6"
uuid = "093fc24a-ae57-5d10-9952-331d41423f4d"
version = "1.3.5"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "0fb723cd8c45858c22169b2e42269e53271a6df7"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.7"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "477bf42b4d1496b454c10cce46645bb5b8a0cf2c"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.0.2"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlutoUI]]
deps = ["Base64", "Dates", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "Suppressor"]
git-tree-sha1 = "44e225d5837e2a2345e69a1d1e01ac2443ff9fcb"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.9"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Reexport]]
git-tree-sha1 = "5f6c21241f0f655da3952fd60aa18477cf96c220"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.1.0"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "3240808c6d463ac46f1c1cd7638375cd22abbccb"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.2.12"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[Suppressor]]
git-tree-sha1 = "a819d77f31f83e5792a76081eee1ea6342ab8787"
uuid = "fd094767-a336-5f1f-9728-57cf17d0bbfb"
version = "0.2.0"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╠═7fb69cf0-fc66-11eb-256f-cb6e9d2db156
# ╠═20ad770b-34a1-49e7-b948-e12f46bde5ee
# ╟─59cef39a-3577-4726-aeff-960ad5b580c5
# ╠═c8ba27b1-4d2b-4afc-89a9-806be91534dc
# ╟─ef077759-88ad-4655-b04f-83c80270d320
# ╟─a626d3c1-ba41-4b91-a2a2-6ff69cd13bce
# ╟─1b685538-828a-4c58-bfbf-845e4bd7c26e
# ╟─2eb9f81b-792c-4e45-a4e5-b3364aa3b391
# ╟─78405683-feee-4ff1-ac93-675c92d01a12
# ╟─6c871573-e5b0-49c4-8b38-4800922483dc
# ╟─aa0a5db5-1c71-4756-8c7f-821b85a06ba7
# ╟─824c7e26-5bf8-4272-a4f0-e366271c8221
# ╟─cc203fb4-4755-45cc-8b9b-d06048623ec9
# ╠═546baf39-09e0-46a1-8df3-b39ba04aa11f
# ╟─d8a11fab-d87e-434f-9833-2192ca0b302f
# ╟─401148b3-b3ef-46f9-9869-f3da8d54f6ea
# ╟─7741e7a6-931b-4f47-91bb-2ac61e0e1342
# ╟─2a119909-c45c-4154-b85d-ef55ba8fbe8a
# ╟─94ada1f4-9484-4f5d-90b2-a99165dd9f8c
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
