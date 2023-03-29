### A Pluto.jl notebook ###
# v0.19.22

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 46687a8d-32dc-4806-bf11-c8ce2273c598
begin
	using PlutoUI
	using PlutoUI.ExperimentalLayout: vbox, hbox, Div
	using SignalAnalysis
	using DSP
	using FFTW
	using HypertextLiteral
	using Random
	using Plots
	using Plots.PlotMeasures
	using DataFrames
    plotly()

	html"""
	<style>
		:root {
			--image-filters: invert(1) hue-rotate(180deg) contrast(0.8);
			--out-of-focus-opacity: 0.5;
			--main-bg-color: hsl(0deg 0% 12%);
			--rule-color: rgba(255, 255, 255, 0.15);
			--kbd-border-color: #222222;
			--header-bg-color: hsl(30deg 3% 16%);
			--header-border-color: transparent;
			--ui-button-color: rgb(255, 255, 255);
			--cursor-color: white;
			--normal-cell: 100, 100, 100;
			--error-color: 255, 125, 125;
			--normal-cell-color: rgba(var(--normal-cell), 0.2);
			--dark-normal-cell-color: rgba(var(--normal-cell), 0.4);
			--selected-cell-color: rgb(40 147 189 / 65%);
			--code-differs-cell-color: #9b906c;
			--error-cell-color: rgba(var(--error-color), 0.6);
			--bright-error-cell-color: rgba(var(--error-color), 0.9);
			--light-error-cell-color: rgba(var(--error-color), 0);
			--export-bg-color: hsl(225deg 17% 18%);
			--export-color: rgb(255 255 255 / 84%);
			--export-card-bg-color: rgb(73 73 73);
			--export-card-title-color: rgba(255, 255, 255, 0.85);
			--export-card-text-color: rgb(255 255 255 / 70%);
			--export-card-shadow-color: #0000001c;
			--pluto-schema-types-color: rgba(255, 255, 255, 0.6);
			--pluto-schema-types-border-color: rgba(255, 255, 255, 0.2);
			--pluto-dim-output-color: hsl(0, 0, 70%);
			--pluto-output-color: hsl(0deg 0% 77%);
			--pluto-output-h-color: hsl(0, 0%, 90%);
			--pluto-output-bg-color: var(--main-bg-color);
			--a-underline: #ffffff69;
			--blockquote-color: inherit;
			--blockquote-bg: #2e2e2e;
			--admonition-title-color: black;
			--jl-message-color: rgb(38 90 32);
			--jl-message-accent-color: rgb(131 191 138);
			--jl-info-color: rgb(42 73 115);
			--jl-info-accent-color: rgb(92 140 205);
			--jl-warn-color: rgb(96 90 34);
			--jl-warn-accent-color: rgb(221 212 100);
			--jl-danger-color: rgb(100 47 39);
			--jl-danger-accent-color: rgb(255, 117, 98);
			--jl-debug-color: hsl(288deg 33% 27%);
			--jl-debug-accent-color: hsl(283deg 59% 69%);
			--table-border-color: rgba(255, 255, 255, 0.2);
			--table-bg-hover-color: rgba(193, 192, 235, 0.15);
			--pluto-tree-color: rgb(209 207 207 / 61%);
			--disabled-cell-bg-color: rgba(139, 139, 139, 0.25);
			--selected-cell-bg-color: rgb(42 115 205 / 78%);
			--hover-scrollbar-color-1: rgba(0, 0, 0, 0.15);
			--hover-scrollbar-color-2: rgba(0, 0, 0, 0.05);
			--shoulder-hover-bg-color: rgba(255, 255, 255, 0.05);
			--pluto-logs-bg-color: hsl(240deg 10% 29%);
			--pluto-logs-progress-fill: #5f7f5b;
			--pluto-logs-progress-border: hsl(210deg 35% 72%);
			--nav-h1-text-color: white;
			--nav-filepicker-color: #b6b6b6;
			--nav-filepicker-border-color: #c7c7c7;
			--nav-process-status-bg-color: rgb(82, 82, 82);
			--nav-process-status-color: var(--pluto-output-h-color);
			--restart-recc-header-color: rgb(44 106 157 / 56%);
			--restart-req-header-color: rgb(145 66 60 / 56%);
			--dead-process-header-color: rgba(250, 75, 21, 0.473);
			--loading-header-color: hsl(0deg 0% 20% / 50%);
			--disconnected-header-color: rgba(255, 169, 114, 0.56);
			--binder-loading-header-color: hsl(51deg 64% 90% / 50%);
			--loading-grad-color-1: #a9d4f1;
			--loading-grad-color-2: #d0d4d7;
			--overlay-button-bg: #2c2c2c;
			--overlay-button-border: #c7a74670;
			--overlay-button-color: white;
			--input-context-menu-border-color: rgba(255, 255, 255, 0.1);
			--input-context-menu-bg-color: rgb(39, 40, 47);
			--input-context-menu-soon-color: #b1b1b144;
			--input-context-menu-hover-bg-color: rgba(255, 255, 255, 0.1);
			--input-context-menu-li-color: #c7c7c7;
			--pkg-popup-bg: #3d2f44;
			--pkg-popup-border-color: #574f56;
			--pkg-popup-buttons-bg-color: var(--input-context-menu-bg-color);
			--black: white;
			--white: black;
			--pkg-terminal-bg-color: #252627;
			--pkg-terminal-border-color: #c3c3c388;
			--pluto-runarea-bg-color: rgb(43, 43, 43);
			--pluto-runarea-span-color: hsl(353, 5%, 64%);
			--dropruler-bg-color: rgba(255, 255, 255, 0.1);
			--jlerror-header-color: #d9baba;
			--jlerror-mark-bg-color: rgb(0 0 0 / 18%);
			--jlerror-a-bg-color: rgba(82, 58, 58, 0.5);
			--jlerror-a-border-left-color: #704141;
			--jlerror-mark-color: #b1a9a9;
			--helpbox-bg-color: rgb(30 34 31);
			--helpbox-box-shadow-color: #00000017;
			--helpbox-header-bg-color: #2c3e36;
			--helpbox-header-color: rgb(255 248 235);
			--helpbox-notfound-header-color: rgb(139, 139, 139);
			--helpbox-text-color: rgb(230, 230, 230);
			--code-section-bg-color: rgb(44, 44, 44);
			--code-section-border-color: #555a64;
			--footer-color: #cacaca;
			--footer-bg-color: rgb(38, 39, 44);
			--footer-atag-color: rgb(114, 161, 223);
			--footer-input-border-color: #6c6c6c;
			--footer-filepicker-button-color: black;
			--footer-filepicker-focus-color: #9d9d9d;
			--footnote-border-color: rgba(114, 225, 231, 0.15);
			--undo-delete-box-shadow-color: rgba(213, 213, 214, 0.2);
			--cm-editor-tooltip-border-color: rgba(0, 0, 0, 0.2);
			--cm-editor-li-aria-selected-bg-color: #3271e7;
			--cm-editor-li-aria-selected-color: white;
			--cm-editor-li-notexported-color: rgba(255, 255, 255, 0.5);
			--code-background: hsl(222deg 16% 19%);
			--cm-code-differs-gutters-color: rgb(235 213 28 / 11%);
			--cm-line-numbers-color: #8d86875e;
			--cm-selection-background: hsl(215deg 64% 59% / 48%);
			--cm-selection-background-blurred: hsl(215deg 0% 59% / 48%);
			--cm-editor-text-color: #ffe9fc;
			--cm-comment-color: #e96ba8;
			--cm-atom-color: hsl(8deg 72% 62%);
			--cm-number-color: hsl(271deg 45% 64%);
			--cm-property-color: #f99b15;
			--cm-keyword-color: #ff7a6f;
			--cm-string-color: hsl(20deg 69% 59%);
			--cm-var-color: #afb7d3;
			--cm-var2-color: #06b6ef;
			--cm-macro-color: #82b38b;
			--cm-builtin-color: #5e7ad3;
			--cm-function-color: #f99b15;
			--cm-type-color: hsl(51deg 32% 44%);
			--cm-bracket-color: #a2a273;
			--cm-tag-color: #ef6155;
			--cm-link-color: #815ba4;
			--cm-error-bg-color: #ef6155;
			--cm-error-color: #f7f7f7;
			--cm-matchingBracket-color: white;
			--cm-matchingBracket-bg-color: #c58c237a;
			--cm-placeholder-text-color: rgb(255 255 255 / 20%);
			--autocomplete-menu-bg-color: var(--input-context-menu-bg-color);
			--index-text-color: rgb(199, 199, 199);
			--index-clickable-text-color: rgb(235, 235, 235);
			--docs-binding-bg: #323431;
			--cm-html-color: #00ab85;
			--cm-html-accent-color: #00e7b4;
			--cm-css-color: #ebd073;
			--cm-css-accent-color: #fffed2;
			--cm-css-why-doesnt-codemirror-highlight-all-the-text-aaa: #ffffea;
			--cm-md-color: #a2c9d5;
			--cm-md-accent-color: #00a9d1;
		}
		
		div.plutoui-sidebar.aside {
			position: fixed;
			right: 1rem;
			top: 10rem;
			width: min(80vw, 25%);
			padding: 10px;
			border: 3px solid rgba(0, 0, 0, 0.15);
			border-radius: 10px;
			box-shadow: 0 0 11px 0px #00000010;
			max-height: calc(100vh - 5rem - 56px);
			overflow: auto;
			z-index: 40;
			background: white;
			transition: transform 300ms cubic-bezier(0.18, 0.89, 0.45, 1.12);
			color: var(--pluto-output-color);
			background-color: var(--main-bg-color);
		}

		.second {
			top: 18rem !important;
		}

		.third {
			top: 31.25rem !important;
		}

		.fourth {
			top: 40.75rem !important;
		}
		
		div.plutoui-sidebar.aside.hide {
			transform: translateX(calc(100% - 28px));
		}
		
		.plutoui-sidebar header {
			display: block;
			font-size: 1.5em;
			margin-top: -0.1em;
			margin-bottom: 0.4em;
			padding-bottom: 0.4em;
			margin-left: 0;
			margin-right: 0;
			font-weight: bold;
			border-bottom: 2px solid rgba(0, 0, 0, 0.15);
		}
		
		.plutoui-sidebar.aside.hide .open-sidebar, .plutoui-sidebar.aside:not(.hide) .closed-sidebar, .plutoui-sidebar:not(.aside) .closed-sidebar {
			display: none;
		}

		.sidebar-toggle {
			cursor: pointer;
		}

		div.admonition.info {
			background: rgba(60,60,60,1) !important;
			border-color: darkgrey !important
		}
		
		div.admonition.info .admonition-title {
			background: darkgrey !important;
		}
	</style>
	<script>
		document.addEventListener('click', event => {
			if (event.target.classList.contains("sidebar-toggle")) {
				document.querySelectorAll('.plutoui-sidebar').forEach(function(el) {
   					el.classList.toggle("hide");
				});
			}
		});
	</script>
	"""
end

# ╔═╡ 90966406-941e-11ec-213c-ef9ebe29ca85
md""" # Filter Effects & Artefacts"""

# ╔═╡ 7c34beab-4932-4fa1-8309-838b404b7596
md"""
*An interactive exploration by **Luis Lips** under Supervision of **Benedikt Ehinger**.*

This is an interactive notebook about filters and the consequences you need to be aware of if you use filters. While the interactive part is at the top, we briefly discuss some general knowledge about filtering in EEG below it - be sure to check it out!
"""

# ╔═╡ 3ae1b7ac-e676-4f4d-ba1d-b6e2014046a7
md"""
## Interactive Plots
Jump-start your exploration! If you need guidance, **scroll down**
"""

# ╔═╡ aed71610-558e-466d-a031-c81bc7b71460
begin
	data = [
		(signal="Unit Impulse", freq="-", ftype="Lowpass", fmethod="FIR causal", low_cutoff="10 Hz", high_cutoff="-", notes="=> causal"),
		(signal="Unit Impulse", freq="-", ftype="Lowpass", fmethod="FIR acausal", low_cutoff="10 Hz", high_cutoff="-", notes="=> acausal"),
		(signal="Unit Impulse", freq="-", ftype="Lowpass", fmethod="Butterworth", low_cutoff="10 Hz", high_cutoff="-", notes="=> causal"),
		(signal="Unit Impulse", freq="-", ftype="Lowpass", fmethod="Chebychev1", low_cutoff="10 Hz", high_cutoff="-", notes="=> causal"),
		(signal="ERP", freq="-", ftype="Highpass", fmethod="FIR", low_cutoff="-", high_cutoff="1 Hz", notes="-")
	]
	df = DataFrame(data)

	md"""###### Example Configurations
 	Here are some example configuration which produce some interesting structures...\
	Hint: Start by comparing the impulse response of the unit impulse to get an better understanding. of the filters.
 	$(df)
	"""
end

# ╔═╡ 6a13b44c-211a-4b72-b74a-49974dbd227f
md"""
## Why do we filter?

Short & Simple: Because of Noise. Many if not all EEG signals would be nearly to impossible to analyse without filtering. And yes: One man's noise is another man's signal.\
For now just consider for example high-frequency from the power line as noise.
"""

# ╔═╡ 61bd5619-151f-4a15-ab74-fbc88faf91a0
md"""
## What are the problems?
Filtering can distort the original signal. The result are so called filter effects or artefacts.\
Those can be e.g. ...
  - a smoother or different amplitude of the signal
  - a phase shift or time distortion of the signal

The use of filters when you are unaware of the resulting consequences therefore lay the foundation for wrong interpretations!

To further take a look into the possible artefacts we have to consider the different possible filter methods. Often the artefacts are strongly related to the used method. By knowing the resulting artefacts from different filter methods you can avoid certain kind of artefacts by choosing a corresponding filter method.
"""

# ╔═╡ fb838cbe-55c4-4294-9e0f-9a4ca31a6fcb
md"""
## FIR vs. IIR
To understand the difference between FIR & IIR filters take a look at the written out abbreviations:
- FIR := Finite Impulse Response
- IIR := Infinite Impulse Response
We have two open case:
- What is an impulse response?
- When is it called finite / infinite?

Let's start with the first one! An impulse response is the response of a filter to a unit impulse (signal that is 1 at the onset and 0 everywhere else). The response in the fourier domain is called frequency response. Easy! Onto the second one...\
\
A Finite IR Filter has an finite impulse response which is after a finite time t zero. FIR Filters are also called linear phase filters. This means that all frequencies are shifted by the same value and no phase distortion takes place.\
\
A Infinite IR Filter has no finite impulse response. So theoretically the impulse response based on the parameter choice can get an infinite number of non-zero values.
"""

# ╔═╡ 059cc196-345e-4e2a-bf63-a2772aa78bca
md"""
## Causal vs. Acausal

!!! info \"Causal\"
	Filter uses only the past and present => can only result in effects and artefacts after the onset

!!! info \"Acausal\"
	Filter uses the past, present & future => can result in effects and artefacts before the onset. In practice this is achieved by filtering twice. Once with the original signal, once with the signal reversed (corresponds to backwards filtering).
"""

# ╔═╡ b2baa9dc-93cb-45bd-bb06-aa5dd4a08cea
md"""
## Filter Methods
In this notebook four filter methods are used. Here are some characteristics listed...
1) FIR causal
   - linear phase
   - causal => no effect before onset
3) FIR acausal
   - linear phase
   - acausal => effects before onset
4) Butterworth of order 4 (IIR)
   - causal
   - phase distortion possible
   - flat pass band but broad transition band
5) Chebyshev of order 4 with 1 ripple (IIR)
   - causal
   - phase distortion possible
   - steeper transition band, but ripples in the pass band
"""

# ╔═╡ 758654b7-e5a0-4554-82e9-a6876bc13174
md"""
## Filter Type
The filter types are named straight forward. Once you've heard them you understand them.

!!! info \"Lowpass\"
	A **lowpass filter** let's the low frequencies pass. It is used to zero out frequencies above a certain threshold / cutoff.

!!! info \"Highpass\"
	A **highpass filter** is the inverse of the lowpass filter. It let's the frequencies above a certain threshold pass. 

!!! info \"Bandpass\"
	A **bandpass filter** is a combination of a lowpass and a highpass filter. It let's frequencies in a by parameter defined range pass. This range is called the passband. This is achieved by applying the low and highpass filter sequentially.

!!! info \"Bandstop\"
	Also often called Notch. A bandpass filter is also a combination of a lowpass and a highpass filter. You can imagine it as the inverted bandpass filter. The passband of the bandpass filter is now a stopband and blocks the corresponding frequencies. To get the bandstop filter a lowpass and bandpass is applied separately to the original signal, afterwards the signal is combined.
"""

# ╔═╡ a6e53659-ed15-4bfc-a72b-0ac3bcca16ac
md"""
!!! note \"More Background Information\"
	If you want to get a more detailed background in filters, this [MNE Tutorial](https://mne.tools/dev/auto_tutorials/preprocessing/25_background_filtering.html) as well as this [Paper](https://doi.org/10.1016/j.neuron.2019.02.039) is a great resource! 
"""

# ╔═╡ d7972009-03aa-4c3a-903a-751c2fd01424
Plots.default(
	linewidth=2, 
	background_color=:transparent, 
	foreground_color=:white,
	xlims=(0,5),
	formatter = :plain, 
	legend=true
)

# ╔═╡ e0a8a22d-9131-48db-9817-e12dc5edf638
begin
	sidebar = Div([@htl("""<header>
			<span class="sidebar-toggle open-sidebar">🕹</span>
     		<span class="sidebar-toggle closed-sidebar">🕹</span>
			Interactive Sliders
			</header>"""),
		md"""Here are all interactive bits of the notebook at one place.\
		Feel free to change them!"""
	], class="plutoui-sidebar aside")
end

# ╔═╡ 8f8cc0bb-d54e-42d6-94b5-dbfb8126504c
selection_function_bond = @bind selection_function Radio(["1" => "ERP", "4" => "Unit Impulse", "2" => "Boxplot", "3" => "Sinussoidal"], default="1");

# ╔═╡ 04ea0e0e-ceca-42bf-ad08-d0c558b14484
slider_noise = md"""Noise $(@bind noise Slider([0, 0.1, 0.4], default=0, show_value=true))""";

# ╔═╡ 00ceec9c-83de-4990-b28b-2550c649de94
extra_artifacts = vbox([
	hbox([md"$(@bind line_noise CheckBox())", md"Line noise (50 Hz)"]),
	hbox([md"$(@bind shift CheckBox())", md"Shift at t=2"])
]);

# ╔═╡ 644c6cfb-c39b-418b-a8a9-dcb7a86a1fec
# Sinusoidal Pulse
slider_freq = md"""Frequency $(@bind freq Slider([1, 2, 4, 8, 16], 		
	default=4, show_value=true))""";

# ╔═╡ 047b33a6-6cf0-4670-8452-b7f76a2c2dcb
begin
	###
	# Definition of multiple functions to choose from
	###
	
	center_style = "display: flex;justify-content: center;"
	H(x) = 0.5 * (sign.(x) + 1);

	if selection_function == "1"
		# ERP
		σ = 0.5; σ2 = 0.25; σ3 = 1.5
	
		g(x, σ) = - 1 / σ√2π * ℯ^(-(x-2)^2 / 2σ^2)
	
		g2(x, σ2) = 1 / σ2√2π * 0.9ℯ^(-(x-2)^2 / 2σ2^2)
	
		g3(x, σ3) = -2 / σ3√2π * 1.5ℯ^(-(x-5)^2 / 2σ3^2)
	
		f(x) = 5g(2x, σ) + 5g2(2x, σ2) + 5g3(2x, σ3)
		function_text = Markdown.parse("\$f(x)= ERP\$")
		
	elseif selection_function == "2"
		# Step Function
		f(x) = H(x-1) - H(x-2)
		t1 = Markdown.parse("\$f(x)=H(x-1)-H(x-2)\$")
		t2 = md"""$\hspace{10mm}\text{with}\hspace{2mm}$"""
		t3 = Markdown.parse("\$H(x)=0.5* (sign(x) +1)\$")
		function_text = Div([t1, t2, t3], style=center_style)
	elseif selection_function == "3"
		# Sinusoidal Pulse
		f(x) = ((x > 1 && x < 1+2π/1π) ? 1.5sin.(2π * freq .* x) : 0)		
		function_text = Markdown.parse("\$f(x)=sin(2π*$(freq)*x)\$")
		
	elseif selection_function == "4"
		# Unit Impulse (Scaled x10)
		f(x) = 10*(x==1)
		function_text = Markdown.parse("\$f(x)= Unit Impulse\$")
	end
end;

# ╔═╡ e3caab76-c034-4966-94f8-3b9b6e4201de
begin
	###
	# Definition of sliders of functions
	###

	if selection_function == "3"
		sliders_signal = vbox([slider_noise, slider_freq])
	else
		sliders_signal = vbox([slider_noise])
	end
end;

# ╔═╡ 6974a88f-0d7f-43e3-a74d-53c8d0f98652
begin
	sidebar2 = Div([
		md""" **Signal**""",
		md"---",
		hbox([selection_function_bond, 
			md"``\hspace{25mm}``", 
			sliders_signal
		]),
		md"---",
		extra_artifacts
	], class="plutoui-sidebar aside second")
end

# ╔═╡ 352c8ed9-2070-485b-8d12-4370c2850cf9
rng = MersenneTwister(parse(Int64, selection_function));

# ╔═╡ fd7b297b-29ec-488c-a866-a2128f9224bf
begin
	ts = 0.004
	tmax = 7
	t = 0:ts:tmax
	n = length(t)
	
	# signal 
	signal = f.(t) + noise .* randn(rng, size(t)) + line_noise * 0.5cos.(2π*50*t) + shift * H.(t.-2)
	
	# fourier transformation
	F = fft(signal) |> fftshift
	freqs = fftfreq(length(t), 1/ts) |> fftshift
	
	# plot original signal in time domain 
	time_domain = plot(t, signal, title = "Signal", ylims=(-3, 3), color=1)

	# get max index to mark it
	max_idx = round(freqs[freqs.>=0][argmax(abs.(F[n÷2+1:n]))], digits=2)

	# plot original signal in frequency domain
	freq_domain = plot(freqs[freqs.>=0], abs.(F[n÷2+1:n]), title = "Spectrum", 		xscale=:log10, xticks=([1, 10, 100, max_idx], [1, 10, 100, max_idx]), 		
		color=2)
end;

# ╔═╡ c41393dd-0593-4f63-91ee-2fddd3d5a751
begin
	filter_bond = @bind selection_filter Radio(
			["1"=>"Lowpass", "2"=> "Highpass", "3"=> "Bandpass", "4"=> "Bandstop"],
		default="3")
end;

# ╔═╡ 901f7bfd-9098-4f47-b67d-530c64ec74c8
begin
	selection_method_bond = @bind selection_method Radio(
			["1"=>"FIR causal", "2"=>"FIR acausal", "3"=> "Butterworth", "4"=>"Chebychev1"], default="2")
end;

# ╔═╡ 3a3fc8a3-788e-471d-b7f4-7e6fe8be42e7
begin
	sidebar3 = Div([
		md""" **Filter Type & Method**""",
		md"---",
		hbox([
			filter_bond,
			md"``\hspace{34mm}``", 
			selection_method_bond,
		])
		#md"---",
		#filter
	], class="plutoui-sidebar aside third")
end

# ╔═╡ 6d4b0e02-3829-4b28-9040-fb7c8f88edcb
begin
	slider_range = [0.5, 1, 3.5, 5, 10, 20, 40, 60]
end;

# ╔═╡ ce4a1ad6-1db6-4cb7-bbd6-872111ee3b91
slider_cutoff_low = md"Change the low cutoff $(@bind low Slider(slider_range, default=0.1, show_value=true))";

# ╔═╡ 3f8e3872-c7d3-4005-89f9-575ff571371d
slider_cutoff_high = md"Change the high cutoff $(@bind high Slider(slider_range, default=80, show_value=true))";

# ╔═╡ 8045a798-c881-46d6-bc6e-44d076e0b8b2
begin
	if low > high && (selection_filter == 3 || selection_filter == 4)
	md"""
	!!! warning \"Wrong slider configuration \"
		Because of some limitations in the implementation, some slider configurations are possible which are not desirable! **Low cutoff must be smaller than high cutoff!**
	"""
	end
end

# ╔═╡ f1df47fb-880d-4512-9049-656f943ea070
begin	
	if selection_filter == "1"
		# Slider for lowpass
		filter = slider_cutoff_low
		
	elseif selection_filter == "2"
		# Slider for highpass
		filter = slider_cutoff_high
		
	elseif selection_filter == "3" || selection_filter == "4"
		# Slider for bandpass
		filter = vbox([
			slider_cutoff_low,
			slider_cutoff_high
		])		
	end
end;

# ╔═╡ b0430c29-453e-4b77-bf74-84a8b349102d
begin
	sidebar4 = Div([
		md""" **Filter Parameters**""",
		md"---",
		filter
	], class="plutoui-sidebar aside fourth")
end

# ╔═╡ 951c9155-dd41-4b86-8d61-c81343134758


# ╔═╡ df332112-2ab2-414e-ad06-12e3cc300152
begin
	###
	# Definition of filters to choose from
	###
	
	if selection_filter == "1"
		# Lowpass
		responsetype = Lowpass(low; fs=1/ts)
		
	elseif selection_filter == "2"
		# Highpass
		responsetype = Highpass(high; fs=1/ts)
		
	elseif selection_filter == "3"
		# Bandpass
		# set responsetype 
		if selection_method == "1" || selection_method == "2"
			responsetype_bpass_low = Lowpass(high; fs=1/ts)
			responsetype_bpass_high = Highpass(low; fs=1/ts)
		else
			responsetype = Bandpass(low, high, fs=1/ts)
		end
		
	elseif selection_filter == "4"
		# Notch
		# set responsetype (switch high an low cutoff)
		if selection_method == "1" || selection_method == "2"
			responsetype_bpass_low = Lowpass(low; fs=1/ts)
			responsetype_bpass_high = Highpass(high; fs=1/ts)
		else
			responsetype = Bandstop(low, high, fs=1/ts)
		end
	end
end;

# ╔═╡ 69e519d2-90d3-4876-a7da-b041c0b1ebd2


# ╔═╡ a0962510-b8ee-454b-8660-598e4dba55dc
"""
Compute FIR filterorder
"""
function default_fir_filterorder(responsetype::FilterType, samplingrate::Number)
    # filter settings are the same as firfilt eeglab plugin (Andreas Widmann) and MNE Python. 
    # filter order is set to 3.3 times the reciprocal of the shortest transition band 
    # transition band is set to either
    # min(max(l_freq * 0.25, 2), l_freq)
    # or 
    # min(max(h_freq * 0.25, 2.), nyquist - h_freq)
    # 
    # That is, 0.25 times the frequency, but maximally 2Hz
    %

    transwidthratio = 0.25 # magic number from firfilt eeglab plugin
    fNyquist = samplingrate ./ 2
    cutOff = responsetype.w * samplingrate
    # what is the maximal filter width we can have
    if typeof(responsetype) <: Highpass
        maxDf = cutOff

        df = minimum([maximum([maxDf * transwidthratio, 2]), maxDf])

    elseif typeof(responsetype) <: Lowpass
        #for lowpass we have to look back from nyquist
        maxDf = fNyquist - cutOff
        df = minimum([maximum([cutOff * transwidthratio, 2]), maxDf])

    end

    filterorder = 3.3 ./ (df ./ samplingrate)
    filterorder = Int(filterorder ÷ 2 * 2) # we need even filter order

	if typeof(responsetype) <: Highpass
		filterorder += 1 # we need odd filter order
	end
    return filterorder
end;

# ╔═╡ 3848b2b0-34bd-4677-ade5-a4b263e32453
"""
Compute filter delay
"""
function filterdelay(fobj::Vector)
    return (length(fobj) - 1) ÷ 2
end;

# ╔═╡ c518cbd0-60ca-4d1a-81f7-91ef6711bbf4
begin
	if selection_method == "1" || selection_method == "2"
		
		# FIR Hamming causal or acausal
		
		if selection_filter == "3" || selection_filter == "4"
			# if bandpass or bandstop 
			
			# compute the filter order for FIR
			order_bpass_low = default_fir_filterorder(responsetype_bpass_low, 1/ts)
			order_bpass_high = default_fir_filterorder(responsetype_bpass_high, 1/ts)
		
			# set designmethod based on filterorder
			designmethod_bpass_low = FIRWindow(hamming(order_bpass_low), scale=true)
			designmethod_bpass_high = FIRWindow(hamming(order_bpass_high), scale=true)
		
			# compute delay
			if selection_method == "2" && (selection_filter == "3" || selection_filter == "4")
				delay_bpass_low = filterdelay(digitalfilter(responsetype_bpass_low, 
				designmethod_bpass_low))
			
				delay_bpass_high = filterdelay(digitalfilter(responsetype_bpass_high, 
				designmethod_bpass_high))

				if selection_filter == "3"
					delay = delay_bpass_low + delay_bpass_high
				else
					delay=0
				end
			else
				delay_bpass_low = 0
				delay_bpass_high = 0
				delay = 0
			end
		else
			# if lowpass or highpass FIR
			order = default_fir_filterorder(responsetype, 1/ts)
			designmethod = FIRWindow(hamming(abs.(order)), scale=true)
			if selection_method == "2" 
				delay = filterdelay(digitalfilter(responsetype, designmethod))
			else
				delay = 0
			end
		end
	elseif selection_method == "3"
		# Butterworth
		# set designmethod
		designmethod = Butterworth(4)
		
		# set delay to zero
		delay = 0
		
	elseif selection_method == "4"
		# Chebyshev1
		# set designmethod
		designmethod = Chebyshev1(4, 1)
		
		# set delay to zero
		delay = 0
	end
end;

# ╔═╡ 6204deba-8bab-4eff-807f-884c6d05fbd1
begin
	# filter response
	signal_base = zeros(size(t))
	signal_base[end÷2] = 1
	
	# filtering
	if (selection_method == "1" || selection_method == "2") && selection_filter == "3"
		# filtering if bandpass
		# apply low and higpasss filter sequentially after each other
		signal_filt_temp = filt(
			digitalfilter(responsetype_bpass_low, designmethod_bpass_low), signal)
		
		signal_filt = filt(
			digitalfilter(responsetype_bpass_high, designmethod_bpass_high), signal_filt_temp)

		# same for filter response
		signal_base_filt_temp = filt(digitalfilter(responsetype_bpass_low, 
			designmethod_bpass_low), signal_base)

		signal_base_filt = filt(digitalfilter(responsetype_bpass_high, 
			designmethod_bpass_high), signal_base_filt_temp)
		
	elseif (selection_method == "1" || selection_method == "2") && selection_filter == "4"
		# filtering if bandstop 
		
		# apply low and highpass filter each separate to signal and then combine
		sginal_filt_low = filt(digitalfilter(responsetype_bpass_low, 
			designmethod_bpass_low), signal)
		
		sginal_filt_high = filt(digitalfilter(responsetype_bpass_high, 
			designmethod_bpass_high), signal)

		sginal_filt_low = circshift(sginal_filt_low, -delay_bpass_low)
		sginal_filt_high = circshift(sginal_filt_high, -delay_bpass_high)
		
		signal_filt = sginal_filt_low .+ sginal_filt_high


		# same for filter response
		signal_base_filt_low = filt(digitalfilter(responsetype_bpass_low, 
			designmethod_bpass_low), signal_base)

		signal_base_filt_high = filt(digitalfilter(responsetype_bpass_high, 
			designmethod_bpass_high), signal_base)

		signal_base_filt = signal_base_filt_low .+ signal_base_filt_high

	else
		# if low or highpass
		
		# filtered signal 
		signal_filt = filt(digitalfilter(responsetype, designmethod), signal)
		
		# filter in time domain
		signal_base_filt = filt(digitalfilter(responsetype, designmethod), signal_base)
	end
	
		
	# filter in frequency domain
	F_base_filt = fft(signal_base_filt) |> fftshift
	freqs_base_filt = fftfreq(length(t), 1/ts) |> fftshift
	
	# fourier transformation
	F_filt = fft(signal_filt) |> fftshift
	freqs_filt = fftfreq(length(t), 1/ts) |> fftshift

	# plotting 
	
	# plot original signal
	plot(t, signal, color=1, alpha=0.3)

	# plot filtered signal in time domain
	time_domain_filt = plot!(t, circshift(signal_filt, -delay), 
		ylims=(-3, 3), title="Signal (filtered)", color=1)

	# plot the original frequency spectrum
	plot(freqs[freqs.>=0], abs.(F[n÷2+1:n]), color=2, alpha=0.3)
	
	# get the max index to mark it
	local max_idx = round(freqs_filt[freqs_filt.>=0][argmax(abs.(F_filt[n÷2+1:n]))], digits=1)

	# get the max value for upscaling
	max = maximum(abs.(F[n÷2+1:n]))

	# plot the filter response
	plot!(freqs_base_filt[freqs_base_filt.>=0], abs.(F_base_filt[n÷2+1:n]).*max, color=:white, linestyle=:dot)

	# plot the frequency spectrum of the filtered signal
	freq_domain_filt = plot!(freqs_filt[freqs_filt.>=0], abs.(F_filt[n÷2+1:n]), 		title="Spectrum (filtered)", xscale=:log10, color=2, 
		xticks=([1, 10, 100, max_idx], [1, 10, 100, max_idx])) 
end;

# ╔═╡ 89d523bd-0a4b-4eec-ad17-2ed48c346630
plot(time_domain_filt)

# ╔═╡ e802afe4-1e15-4228-921e-9f3ca98b3ab9
plot(freq_domain_filt)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
DSP = "717857b8-e6f2-59f4-9121-6e50c889abd2"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
FFTW = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
SignalAnalysis = "df1fea92-c066-49dd-8b36-eace3378ea47"

[compat]
DSP = "~0.7.5"
DataFrames = "~1.3.2"
FFTW = "~1.4.6"
HypertextLiteral = "~0.9.3"
Plots = "~1.27.1"
PlutoUI = "~0.7.37"
SignalAnalysis = "~0.4.1"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.0-rc1"
manifest_format = "2.0"
project_hash = "cc62ad537178dea88ef49efac748da42f069a103"

[[deps.AbstractFFTs]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "16b6dbc4cf7caee4e1e75c49485ec67b667098a0"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.3.1"

    [deps.AbstractFFTs.extensions]
    AbstractFFTsChainRulesCoreExt = "ChainRulesCore"

    [deps.AbstractFFTs.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "cc37d689f599e8df4f464b2fa3870ff7db7492ef"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.6.1"
weakdeps = ["StaticArrays"]

    [deps.Adapt.extensions]
    AdaptStaticArraysExt = "StaticArrays"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Random", "SnoopPrecompile"]
git-tree-sha1 = "aa3edc8f8dea6cbfa176ee12f7c2fc82f0608ed3"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.20.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "600cc5508d66b78aae350f7accdb58763ac18589"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.10"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.Compat]]
deps = ["UUIDs"]
git-tree-sha1 = "7a60c856b9fa189eb34f5f8a6f6b5529b7942957"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.6.1"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.2+0"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "89a9db8d28102b094992472d333674bd1a83ce2a"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.1"

    [deps.ConstructionBase.extensions]
    IntervalSetsExt = "IntervalSets"
    StaticArraysExt = "StaticArrays"

    [deps.ConstructionBase.weakdeps]
    IntervalSets = "8197267c-284f-5f27-9208-e0e47529a953"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DSP]]
deps = ["Compat", "FFTW", "IterTools", "LinearAlgebra", "Polynomials", "Random", "Reexport", "SpecialFunctions", "Statistics"]
git-tree-sha1 = "da8b06f89fce9996443010ef92572b193f8dca1f"
uuid = "717857b8-e6f2-59f4-9121-6e50c889abd2"
version = "0.7.8"

[[deps.DataAPI]]
git-tree-sha1 = "e8119c1a33d267e16108be441a287a6981ba1630"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.14.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Reexport", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "db2a9cb664fcea7836da4b414c3278d71dd602d2"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.3.6"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.Distributions]]
deps = ["FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SparseArrays", "SpecialFunctions", "Statistics", "StatsBase", "StatsFuns", "Test"]
git-tree-sha1 = "da9e1a9058f8d3eec3a8c9fe4faacfb89180066b"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.86"

    [deps.Distributions.extensions]
    DistributionsChainRulesCoreExt = "ChainRulesCore"
    DistributionsDensityInterfaceExt = "DensityInterface"

    [deps.Distributions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    DensityInterface = "b429d917-457f-4dbc-8f4c-0cc954292b1d"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.DualNumbers]]
deps = ["Calculus", "NaNMath", "SpecialFunctions"]
git-tree-sha1 = "5837a837389fccf076445fce071c8ddaea35a566"
uuid = "fa6b7ba4-c1ee-5f82-b5fc-ecf0adba8f74"
version = "0.6.8"

[[deps.EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e3290f2d49e661fbd94046d7e3726ffcb2d41053"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.4+0"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

[[deps.Extents]]
git-tree-sha1 = "5e1e4c53fa39afe63a7d356e30452249365fba99"
uuid = "411431e0-e8b7-467b-b5e0-f676ba4f2910"
version = "0.1.1"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "74faea50c1d007c85837327f6775bea60b5492dd"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+2"

[[deps.FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "505876577b5481e50d089c1c68899dfb6faebc62"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.4.6"

[[deps.FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c6033cc3892d0ef5bb9cd29b7f2f0331ea5184ea"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.10+0"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "7be5f99f7d15578798f338f5433b6c432ea8037b"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.16.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "3b245d1e50466ca0c9529e2033a3c92387c59c2f"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "0.13.9"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "d972031d28c8c8d9d7b41a536ad7bb0c2579caca"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.8+0"

[[deps.GPUArraysCore]]
deps = ["Adapt"]
git-tree-sha1 = "1cd7f0af1aa58abc02ea1d872953a97359cb87fa"
uuid = "46192b85-c4d5-4398-a991-12ede77f4527"
version = "0.1.4"

[[deps.GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "RelocatableFolders", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "c98aea696662d09e215ef7cda5296024a9646c75"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.64.4"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "bc9f7725571ddb4ab2c4bc74fa397c1c5ad08943"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.69.1+0"

[[deps.GeoInterface]]
deps = ["Extents"]
git-tree-sha1 = "e07a1b98ed72e3cdd02c6ceaab94b8a606faca40"
uuid = "cf35fbd7-0cd7-5166-be24-54bfbe79505f"
version = "1.2.1"

[[deps.GeometryBasics]]
deps = ["EarCut_jll", "GeoInterface", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "303202358e38d2b01ba46844b92e48a3c238fd9e"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.6"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "d3b3624125c1474292d0d8ed0f65554ac37ddb23"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.74.0+2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "0fa77022fe4b511826b39c894c90daf5fce3334a"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.17"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.HypergeometricFunctions]]
deps = ["DualNumbers", "LinearAlgebra", "OpenLibm_jll", "SpecialFunctions", "Test"]
git-tree-sha1 = "709d864e3ed6e3545230601f94e11ebc65994641"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.11"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d979e54b71da82f3a65b62553da4fc3d18c9004c"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2018.0.3+2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InvertedIndices]]
git-tree-sha1 = "0dc7b50b8d436461be01300fd8cd45aa0274b038"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.3.0"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.IterTools]]
git-tree-sha1 = "fa6287a4469f5e048d763df38279ee729fbd44e5"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.4.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6f2675ef130a300a112286de91973805fcc5ffbc"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.91+0"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "2422f47b34d4b127720a18f86fa7b1aa2e141f29"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.18"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "6f73d1dd803986947b2c750138528a999a6c7733"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.6.0+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c7cb1f5d892775ba13767a87c7ada0b980ea0a71"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+2"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "3eb79b0ca5764d4799c06699573fd8f533259713"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.4.0+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "0a1b7c2863e44523180fdb3146534e265a91870b"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.23"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "Pkg"]
git-tree-sha1 = "2ce8695e1e699b68702c03402672a69f54b8aca9"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2022.2.0+0"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "03a9b9718f5682ecb107ac9f7308991db4ce395b"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.7"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[deps.MetaArrays]]
deps = ["Requires"]
git-tree-sha1 = "6647f7d45a9153162d6561957405c12088caf537"
uuid = "36b8f3f0-b776-11e8-061f-1f20094e1fc8"
version = "0.2.10"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "82d7c9e310fe55aa54996e6f7f94674e2a38fcb4"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.12.9"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9ff31d101d987eb9d66bd8b176ac7c277beccd09"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.20+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+0"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "67eae2738d63117a196f497d7db789821bce61d1"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.17"

[[deps.PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "03a7a85b76381a3d04c7a1656039197e70eda03d"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.11"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "478ac6c952fddd4399e71d4779797c538d0ff2bf"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.8"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.0"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "SnoopPrecompile", "Statistics"]
git-tree-sha1 = "c95373e73290cf50a8a22c3375e4625ded5c5280"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.4"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "6f2dd1cf7a4bbf4f305a0d8750e351cb46dfbe80"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.27.6"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "5bb5129fdd62a2bbbe17c2756932259acf467386"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.50"

[[deps.Polynomials]]
deps = ["LinearAlgebra", "RecipesBase"]
git-tree-sha1 = "86efc6f761df655f8782f50628e45e01a457d5a2"
uuid = "f27b6e38-b328-58d1-80ce-0feddd5e7a45"
version = "3.2.8"

    [deps.Polynomials.extensions]
    PolynomialsChainRulesCoreExt = "ChainRulesCore"
    PolynomialsMakieCoreExt = "MakieCore"

    [deps.Polynomials.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    MakieCore = "20f20a25-4f0e-4fdf-b5d1-57303727442b"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "a6062fe4063cdafe78f4a0a81cfffb89721b30e7"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.2"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.PrettyTables]]
deps = ["Crayons", "Formatting", "Markdown", "Reexport", "Tables"]
git-tree-sha1 = "dfb54c4e414caa595a1f2ed759b160f5a3ddcba5"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.3.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "0c03844e2231e12fda4d0086fd7cbe4098ee8dc5"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+2"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "6ec7ac8412e83d57e313393220879ede1740f9ee"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.8.2"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
deps = ["SnoopPrecompile"]
git-tree-sha1 = "261dddd3b862bd2c940cf6ca4d1c8fe593e457c8"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.3"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "dc1e451e15d90347a7decc4221842a022b011714"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.5.2"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "cdbd3b1338c72ce29d9584fdbe9e9b70eeb5adca"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "0.1.3"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "f65dcb5fa46aee0cf9ed6274ccbd597adc49aa7b"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.1"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6ed52fdd3382cf21947b15e8870ac0ddbff736da"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.4.0+0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "30449ee12237627992a99d5e30ae63e4d78cd24a"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SignalAnalysis]]
deps = ["DSP", "Distributions", "DocStringExtensions", "FFTW", "LinearAlgebra", "MetaArrays", "PaddedViews", "Random", "Requires", "SignalBase", "Statistics", "WAV"]
git-tree-sha1 = "1ccd917ab9427732a82a0bb832ef6a00d5d71d9d"
uuid = "df1fea92-c066-49dd-8b36-eace3378ea47"
version = "0.4.3"

[[deps.SignalBase]]
deps = ["Unitful"]
git-tree-sha1 = "14cb05cba5cc89d15e6098e7bb41dcef2606a10a"
uuid = "00c44e92-20f5-44bc-8f45-a1dcef76ba38"
version = "0.1.2"

[[deps.SnoopPrecompile]]
deps = ["Preferences"]
git-tree-sha1 = "e760a70afdcd461cf01a575947738d359234665c"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "a4ada03f999bd01b3a25dcaa30b2d929fe537e00"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.1.0"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "ef28127915f4229c971eb43f3fc075dd3fe91880"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.2.0"

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

    [deps.SpecialFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore", "Statistics"]
git-tree-sha1 = "7756ce473bd10b67245bdebdc8d8670a85f6230b"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.5.18"

[[deps.StaticArraysCore]]
git-tree-sha1 = "6b7ba252635a5eff6a0b0664a41ee140a1c9e72a"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f9af7f195fb13589dd2e2d57fdb401717d2eb1f6"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.5.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "d1bf48bfcc554a3761a133fe3a9bb01488e06916"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.21"

[[deps.StatsFuns]]
deps = ["HypergeometricFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "f625d686d5a88bcd2b15cd81f18f98186fdc0c9a"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "1.3.0"

    [deps.StatsFuns.extensions]
    StatsFunsChainRulesCoreExt = "ChainRulesCore"
    StatsFunsInverseFunctionsExt = "InverseFunctions"

    [deps.StatsFuns.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.StructArrays]]
deps = ["Adapt", "DataAPI", "GPUArraysCore", "StaticArraysCore", "Tables"]
git-tree-sha1 = "521a0e828e98bb69042fec1809c1b5a680eb7389"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.15"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "1544b926975372da01227b382066ab70e574a3ec"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.10.1"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.URIs]]
git-tree-sha1 = "074f993b0ca030848b897beff716d93aca60f06a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unitful]]
deps = ["ConstructionBase", "Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "bb37ed24f338bc59b83e3fc9f32dd388e5396c53"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.12.4"

[[deps.Unzip]]
git-tree-sha1 = "34db80951901073501137bdbc3d5a8e7bbd06670"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.1.2"

[[deps.WAV]]
deps = ["Base64", "FileIO", "Libdl", "Logging"]
git-tree-sha1 = "7e7e1b4686995aaf4ecaaf52f6cd824fa6bd6aa5"
uuid = "8149f6b0-98f6-5db9-b78f-408fbbb8ef88"
version = "1.2.0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "ed8d92d9774b077c53e1da50fd81a36af3744c1c"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "93c41695bc1c08c46c5899f4fe06d6ead504bb73"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.10.3+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "c6edfe154ad7b313c01aceca188c05c835c67360"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.4+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.4.0+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9ebfc140cc56e8c2156a15ceac2f0302e327ac0a"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+0"
"""

# ╔═╡ Cell order:
# ╟─90966406-941e-11ec-213c-ef9ebe29ca85
# ╟─7c34beab-4932-4fa1-8309-838b404b7596
# ╟─3ae1b7ac-e676-4f4d-ba1d-b6e2014046a7
# ╟─89d523bd-0a4b-4eec-ad17-2ed48c346630
# ╟─e802afe4-1e15-4228-921e-9f3ca98b3ab9
# ╟─aed71610-558e-466d-a031-c81bc7b71460
# ╟─6a13b44c-211a-4b72-b74a-49974dbd227f
# ╟─61bd5619-151f-4a15-ab74-fbc88faf91a0
# ╟─fb838cbe-55c4-4294-9e0f-9a4ca31a6fcb
# ╟─059cc196-345e-4e2a-bf63-a2772aa78bca
# ╟─b2baa9dc-93cb-45bd-bb06-aa5dd4a08cea
# ╟─758654b7-e5a0-4554-82e9-a6876bc13174
# ╟─a6e53659-ed15-4bfc-a72b-0ac3bcca16ac
# ╟─8045a798-c881-46d6-bc6e-44d076e0b8b2
# ╠═46687a8d-32dc-4806-bf11-c8ce2273c598
# ╠═d7972009-03aa-4c3a-903a-751c2fd01424
# ╠═e0a8a22d-9131-48db-9817-e12dc5edf638
# ╠═6974a88f-0d7f-43e3-a74d-53c8d0f98652
# ╠═3a3fc8a3-788e-471d-b7f4-7e6fe8be42e7
# ╠═b0430c29-453e-4b77-bf74-84a8b349102d
# ╠═8f8cc0bb-d54e-42d6-94b5-dbfb8126504c
# ╠═04ea0e0e-ceca-42bf-ad08-d0c558b14484
# ╠═00ceec9c-83de-4990-b28b-2550c649de94
# ╠═047b33a6-6cf0-4670-8452-b7f76a2c2dcb
# ╠═644c6cfb-c39b-418b-a8a9-dcb7a86a1fec
# ╠═e3caab76-c034-4966-94f8-3b9b6e4201de
# ╠═352c8ed9-2070-485b-8d12-4370c2850cf9
# ╠═fd7b297b-29ec-488c-a866-a2128f9224bf
# ╠═c41393dd-0593-4f63-91ee-2fddd3d5a751
# ╠═901f7bfd-9098-4f47-b67d-530c64ec74c8
# ╠═6d4b0e02-3829-4b28-9040-fb7c8f88edcb
# ╠═ce4a1ad6-1db6-4cb7-bbd6-872111ee3b91
# ╠═3f8e3872-c7d3-4005-89f9-575ff571371d
# ╠═f1df47fb-880d-4512-9049-656f943ea070
# ╠═951c9155-dd41-4b86-8d61-c81343134758
# ╠═df332112-2ab2-414e-ad06-12e3cc300152
# ╠═69e519d2-90d3-4876-a7da-b041c0b1ebd2
# ╠═c518cbd0-60ca-4d1a-81f7-91ef6711bbf4
# ╠═6204deba-8bab-4eff-807f-884c6d05fbd1
# ╠═a0962510-b8ee-454b-8660-598e4dba55dc
# ╠═3848b2b0-34bd-4677-ade5-a4b263e32453
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
