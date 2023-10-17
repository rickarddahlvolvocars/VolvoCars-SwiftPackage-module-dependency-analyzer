import Foundation

func genOverview() -> String {
    // https://medium.com/hackernoon/create-javascript-sankey-diagram-b68c0d508a38

    let all = "Total (\(lookupLocalModulesOnDisk.count + lookupRemoteModules.count))"
    
    var data = "["
    
    data += "{from: \"Local modules: \(lookupLocalModulesOnDisk.count)\", to: \"\(all)\", weight: \(lookupLocalModulesOnDisk.count)},"
    
    let countDirect = lookupRemoteModules.filter { $0.referencedFromLocalModuleOrProject == true }.count
    data += "{from: \"Remote modules (direct reference): \(countDirect)\", to: \"\(all)\", weight: \(countDirect)},"
    
    let countIndirect = lookupRemoteModules.filter { $0.referencedFromLocalModuleOrProject == false }.count
    data += "{from: \"Remote modules (indirect reference): \(countIndirect)\", to: \"\(all)\", weight: \(countIndirect)}"

    data += "];"
    
    let indexData =
    """
    <html>
    <head>
    <script src="https://cdn.anychart.com/releases/v8/js/anychart-core.min.js"></script>
    <script src="https://cdn.anychart.com/releases/v8/js/anychart-sankey.min.js"></script>
    </head>
    <body>
    <div id="container"></div>
    <script>
        anychart.onDocumentReady(function(){
            var data = \(data)
            var sankey_chart = anychart.sankey(data);
            sankey_chart.nodeWidth("20%");
            sankey_chart.title("Sankey Diagram Customization Example");
            sankey_chart.nodePadding(20);
            sankey_chart.node().normal().fill("#64b5f5 0.6");
            sankey_chart.node().hovered().fill(anychart.color.darken("#64b5f7"));
            sankey_chart.node().normal().stroke("#455a63", 2);
            sankey_chart.flow().normal().fill("#ffa000 0.5");
            sankey_chart.flow().hovered().fill(anychart.color.darken("#ffa000"));
            sankey_chart.flow().hovered().stroke("#455a63");
            sankey_chart.container("container");
            sankey_chart.draw();
        });
    </script>
    </body>
    </html>
    """
    
    return indexData
}

func genD3Sunburst() -> String {
#if false
    let data = """
    [{"source":"analytics.cluster","target":"animate","value":2},{"source":"analytics.cluster","target":"vis.data","value":8},{"source":"analytics.cluster","target":"util.math","value":2},{"source":"analytics.cluster","target":"analytics.cluster","value":5},{"source":"analytics.cluster","target":"util","value":3},{"source":"analytics.cluster","target":"vis.operator","value":1},{"source":"analytics.graph","target":"animate","value":5},{"source":"analytics.graph","target":"vis.data","value":14},{"source":"analytics.graph","target":"util","value":5},{"source":"analytics.graph","target":"vis.operator","value":6},{"source":"analytics.graph","target":"analytics.graph","value":1},{"source":"analytics.graph","target":"util.heap","value":2},{"source":"analytics.graph","target":"vis","value":1},{"source":"analytics.optimization","target":"animate","value":1},{"source":"analytics.optimization","target":"util","value":2},{"source":"analytics.optimization","target":"vis.data","value":1},{"source":"analytics.optimization","target":"scale","value":1},{"source":"analytics.optimization","target":"vis.axis","value":1},{"source":"analytics.optimization","target":"vis","value":1},{"source":"analytics.optimization","target":"vis.operator","value":1},{"source":"animate","target":"animate","value":30},{"source":"animate","target":"util","value":9},{"source":"animate.interpolate","target":"util","value":2},{"source":"animate.interpolate","target":"animate.interpolate","value":16},{"source":"animate","target":"animate.interpolate","value":1},{"source":"data.converters","target":"data.converters","value":7},{"source":"data.converters","target":"data","value":17},{"source":"data.converters","target":"util","value":1},{"source":"data","target":"data","value":7},{"source":"data","target":"util","value":1},{"source":"data","target":"data.converters","value":2},{"source":"display","target":"display","value":3},{"source":"display","target":"util","value":1},{"source":"flex","target":"display","value":1},{"source":"flex","target":"data","value":1},{"source":"flex","target":"vis","value":1},{"source":"flex","target":"vis.axis","value":2},{"source":"flex","target":"vis.data","value":1},{"source":"physics","target":"physics","value":22},{"source":"query","target":"query","value":61},{"source":"query","target":"util","value":6},{"source":"query.methods","target":"query.methods","value":39},{"source":"query.methods","target":"query","value":32},{"source":"scale","target":"scale","value":19},{"source":"scale","target":"util","value":14},{"source":"util","target":"util","value":23},{"source":"util.heap","target":"util.heap","value":2},{"source":"util.math","target":"util.math","value":2},{"source":"util.palette","target":"util.palette","value":3},{"source":"util.palette","target":"util","value":2},{"source":"vis.axis","target":"animate","value":3},{"source":"vis.axis","target":"vis","value":2},{"source":"vis.axis","target":"scale","value":4},{"source":"vis.axis","target":"util","value":3},{"source":"vis.axis","target":"display","value":5},{"source":"vis.axis","target":"vis.axis","value":7},{"source":"vis.controls","target":"vis.controls","value":12},{"source":"vis.controls","target":"vis","value":3},{"source":"vis.controls","target":"vis.operator.layout","value":1},{"source":"vis.controls","target":"vis.events","value":4},{"source":"vis.controls","target":"util","value":3},{"source":"vis.controls","target":"vis.data","value":2},{"source":"vis.controls","target":"animate","value":2},{"source":"vis.controls","target":"display","value":1},{"source":"vis.data","target":"vis.data","value":26},{"source":"vis.data","target":"util","value":17},{"source":"vis.data","target":"vis.events","value":4},{"source":"vis.data","target":"data","value":3},{"source":"vis.data","target":"animate","value":2},{"source":"vis.data","target":"util.math","value":2},{"source":"vis.data","target":"display","value":1},{"source":"vis.data","target":"vis.data.render","value":4},{"source":"vis.data.render","target":"vis.data","value":5},{"source":"vis.data.render","target":"vis.data.render","value":3},{"source":"vis.data.render","target":"util","value":3},{"source":"vis.data","target":"scale","value":9},{"source":"vis.data","target":"util.heap","value":2},{"source":"vis.events","target":"vis.data","value":6},{"source":"vis.events","target":"vis.events","value":1},{"source":"vis.events","target":"animate","value":1},{"source":"vis.legend","target":"animate","value":1},{"source":"vis.legend","target":"vis.data","value":1},{"source":"vis.legend","target":"util.palette","value":5},{"source":"vis.legend","target":"scale","value":4},{"source":"vis.legend","target":"vis.legend","value":4},{"source":"vis.legend","target":"display","value":6},{"source":"vis.legend","target":"util","value":6},{"source":"vis.operator.distortion","target":"vis.operator.distortion","value":2},{"source":"vis.operator.distortion","target":"animate","value":1},{"source":"vis.operator.distortion","target":"vis.data","value":2},{"source":"vis.operator.distortion","target":"vis.events","value":1},{"source":"vis.operator.distortion","target":"vis.axis","value":2},{"source":"vis.operator.distortion","target":"vis.operator.layout","value":1},{"source":"vis.operator.encoder","target":"animate","value":3},{"source":"vis.operator.encoder","target":"scale","value":3},{"source":"vis.operator.encoder","target":"vis.operator.encoder","value":4},{"source":"vis.operator.encoder","target":"util.palette","value":7},{"source":"vis.operator.encoder","target":"vis.data","value":8},{"source":"vis.operator.encoder","target":"vis.operator","value":2},{"source":"vis.operator.encoder","target":"util","value":3},{"source":"vis.operator.filter","target":"animate","value":3},{"source":"vis.operator.filter","target":"vis.data","value":10},{"source":"vis.operator.filter","target":"vis.operator","value":3},{"source":"vis.operator.filter","target":"util","value":1},{"source":"vis.operator","target":"animate","value":7},{"source":"vis.operator","target":"vis","value":3},{"source":"vis.operator","target":"vis.operator","value":11},{"source":"vis.operator.label","target":"animate","value":1},{"source":"vis.operator.label","target":"vis.data","value":6},{"source":"vis.operator.label","target":"display","value":3},{"source":"vis.operator.label","target":"vis.operator","value":1},{"source":"vis.operator.label","target":"util","value":5},{"source":"vis.operator.label","target":"vis.operator.label","value":2},{"source":"vis.operator.layout","target":"scale","value":6},{"source":"vis.operator.layout","target":"vis.data","value":34},{"source":"vis.operator.layout","target":"vis.axis","value":4},{"source":"vis.operator.layout","target":"util","value":20},{"source":"vis.operator.layout","target":"vis.operator.layout","value":14},{"source":"vis.operator.layout","target":"animate","value":6},{"source":"vis.operator.layout","target":"vis.operator","value":2},{"source":"vis.operator.layout","target":"vis.data.render","value":1},{"source":"vis.operator.layout","target":"physics","value":3},{"source":"vis.operator.layout","target":"vis","value":1},{"source":"vis.operator","target":"util","value":5},{"source":"vis.operator","target":"vis.data","value":1},{"source":"vis","target":"animate","value":3},{"source":"vis","target":"vis.operator","value":2},{"source":"vis","target":"vis.events","value":2},{"source":"vis","target":"vis.data","value":2},{"source":"vis","target":"vis.axis","value":2},{"source":"vis","target":"util","value":1},{"source":"vis","target":"vis.controls","value":1}]
    """
#else
    let all = "Total (\(lookupLocalModulesOnDisk.count + lookupRemoteModules.count))"
    
    let allLocal = "\(lookupLocalModulesOnDisk.count) local"
    
    let remoteDirect = lookupRemoteModules.filter { $0.referencedFromLocalModuleOrProject == true }
    let remoteDirectCount = remoteDirect.count
    let allRemoteDirect = "\(remoteDirectCount) remote (direct)"
    
    let remoteIndirect = lookupRemoteModules.filter { $0.referencedFromLocalModuleOrProject == false }
    let remoteIndirectCount = remoteIndirect.count
    let allRemoteIndirect = "\(remoteIndirectCount) remote (indirect)"
    
    // {"source":"analytics.cluster","target":"animate","value":2},
    
    var data = "["
    
    lookupLocalModulesOnDisk.forEach { mod in
        mod.localModules.forEach { loc_subm in
            data += "{\"source\": \"\(mod.moduleName)\", \"target\": \"\(loc_subm.moduleName)\", value: 1},"
        }
#if false
        mod.remoteModules.forEach { rem_subm in
            data += "{\"source\": \"\(mod.moduleName)\", \"target\": \"\(rem_subm.moduleName)\", value: 1},"
        }
#endif
    }
    //
    //        let countDirect = lookupRemoteModules.filter { $0.referencedFromLocalModuleOrProject == true }.count
    //        data += "{from: \"Remote modules (direct reference): \(countDirect)\", to: \"\(all)\", weight: \(countDirect)},"
    //
    //        let countIndirect = lookupRemoteModules.filter { $0.referencedFromLocalModuleOrProject == false }.count
    //        data += "{from: \"Remote modules (indirect reference): \(countIndirect)\", to: \"\(all)\", weight: \(countIndirect)}"
    data += "]"
#endif
    
    let indexFileContents =
    """
    <!DOCTYPE html>
    <script src="https://cdn.jsdelivr.net/npm/d3@7"></script>
    <body>
    <h2>SPM module relations</h2>
    <div id="container"></div>
    <svg id="g" style="width:1080px;height:1080px"></svg>
    
    <script type="module">
    
    const data = \(data);
    
    const width = 1080;
    const height = width;
    const innerRadius = Math.min(width, height) * 0.5 - 90;
    const outerRadius = innerRadius + 10;
    
    // Compute a dense matrix from the weighted links in data.
    const names = d3.sort(d3.union(data.map(d => d.source), data.map(d => d.target)));
    const index = new Map(names.map((name, i) => [name, i]));
    const matrix = Array.from(index, () => new Array(names.length).fill(0));
    for (const {source, target, value} of data) matrix[index.get(source)][index.get(target)] += value;
    
    const chord = d3.chordDirected()
      .padAngle(10 / innerRadius)
      .sortSubgroups(d3.descending)
      .sortChords(d3.descending);
    
    const arc = d3.arc()
      .innerRadius(innerRadius)
      .outerRadius(outerRadius);
    
    const ribbon = d3.ribbonArrow()
      .radius(innerRadius - 1)
      .padAngle(1 / innerRadius);
    
    const colors = d3.quantize(d3.interpolateRainbow, names.length);
    
    const svg = d3.create("svg")
      .attr("width", width)
      .attr("height", height)
      .attr("viewBox", [-width / 2, -height / 2, width, height])
      .attr("style", "width: 100%; height: auto; font: 10px sans-serif;");
    
    const chords = chord(matrix);
    
    const group = svg.append("g")
    .selectAll()
    .data(chords.groups)
    .join("g");
    
    group.append("path")
      .attr("fill", d => colors[d.index])
      .attr("d", arc);
    
    group.append("text")
      .each(d => (d.angle = (d.startAngle + d.endAngle) / 2))
      .attr("dy", "0.35em")
      .attr("transform", d => `
        rotate(${(d.angle * 180 / Math.PI - 90)})
        translate(${outerRadius + 5})
        ${d.angle > Math.PI ? "rotate(180)" : ""}
      `)
      .attr("text-anchor", d => d.angle > Math.PI ? "end" : null)
      .text(d => names[d.index]);
    
    group.append("title")
      .text(d => `${names[d.index]}
    ${d3.sum(chords, c => (c.source.index === d.index) * c.source.value)} outgoing →
    ${d3.sum(chords, c => (c.target.index === d.index) * c.source.value)} incoming ←`);
    
    svg.append("g")
      .attr("fill-opacity", 0.75)
    .selectAll()
    .data(chords)
    .join("path")
      .style("mix-blend-mode", "multiply")
      .attr("fill", d => colors[d.target.index])
      .attr("d", ribbon)
    .append("title")
      .text(d => `${names[d.source.index]} → ${names[d.target.index]} ${d.source.value}`);
    
    container.append(svg.node());
    
    </script>
    
    </body>
    </html>
    """
    
    return indexFileContents
}

func genD3Sunburst_loc_rem() -> String {
    let all = "Total (\(lookupLocalModulesOnDisk.count + lookupRemoteModules.count))"
    
    let allLocal = "\(lookupLocalModulesOnDisk.count) local"
    
    let remoteDirect = lookupRemoteModules.filter { $0.referencedFromLocalModuleOrProject == true }
    let remoteDirectCount = remoteDirect.count
    let allRemoteDirect = "\(remoteDirectCount) remote (direct)"
    
    let remoteIndirect = lookupRemoteModules.filter { $0.referencedFromLocalModuleOrProject == false }
    let remoteIndirectCount = remoteIndirect.count
    let allRemoteIndirect = "\(remoteIndirectCount) remote (indirect)"
    
    // {"source":"analytics.cluster","target":"animate","value":2},
    
    var data = "["
    
    lookupLocalModulesOnDisk.forEach { mod in
        mod.localModules.forEach { loc_subm in
            data += "{\"source\": \"\(mod.moduleName)\", \"target\": \"\(loc_subm.moduleName)\", value: 1},"
        }
#if false
        mod.remoteModules.forEach { rem_subm in
            data += "{\"source\": \"\(mod.moduleName)\", \"target\": \"\(rem_subm.moduleName)\", value: 1},"
        }
#endif
    }

// TODO: gör en till container där jag v isar remote

    //
    //        let countDirect = lookupRemoteModules.filter { $0.referencedFromLocalModuleOrProject == true }.count
    //        data += "{from: \"Remote modules (direct reference): \(countDirect)\", to: \"\(all)\", weight: \(countDirect)},"
    //
    //        let countIndirect = lookupRemoteModules.filter { $0.referencedFromLocalModuleOrProject == false }.count
    //        data += "{from: \"Remote modules (indirect reference): \(countIndirect)\", to: \"\(all)\", weight: \(countIndirect)}"
    data += "]"
    
    let indexFileContents =
    """
    <!DOCTYPE html>
    <script src="https://cdn.jsdelivr.net/npm/d3@7"></script>
    <body>
    <h2>SPM module relations</h2>
    <div id="container" style="padding: 50px;"></div>
    <svg id="g" style="width:1080px;height:1080px"></svg>
    
    <script type="module">
    
    const data = \(data);
    
    const width = 1080;
    const height = width;
    const innerRadius = Math.min(width, height) * 0.5 - 90;
    const outerRadius = innerRadius + 10;
    
    // Compute a dense matrix from the weighted links in data.
    const names = d3.sort(d3.union(data.map(d => d.source), data.map(d => d.target)));
    const index = new Map(names.map((name, i) => [name, i]));
    const matrix = Array.from(index, () => new Array(names.length).fill(0));
    for (const {source, target, value} of data) matrix[index.get(source)][index.get(target)] += value;
    
    const chord = d3.chordDirected()
      .padAngle(10 / innerRadius)
      .sortSubgroups(d3.descending)
      .sortChords(d3.descending);
    
    const arc = d3.arc()
      .innerRadius(innerRadius)
      .outerRadius(outerRadius);
    
    const ribbon = d3.ribbonArrow()
      .radius(innerRadius - 1)
      .padAngle(1 / innerRadius);
    
    const colors = d3.quantize(d3.interpolateRainbow, names.length);
    
    const svg = d3.create("svg")
      .attr("width", width)
      .attr("height", height)
      .attr("viewBox", [-width / 2, -height / 2, width, height])
      .attr("style", "width: 100%; height: auto; font: 8px sans-serif;");
    
    const chords = chord(matrix);
    
    const group = svg.append("g")
    .selectAll()
    .data(chords.groups)
    .join("g");
    
    group.append("path")
      .attr("fill", d => colors[d.index])
      .attr("d", arc);
    
    group.append("text")
      .each(d => (d.angle = (d.startAngle + d.endAngle) / 2))
      .attr("dy", "0.25em")
      .attr("transform", d => `
        rotate(${(d.angle * 180 / Math.PI - 90)})
        translate(${outerRadius + 5})
        ${d.angle > Math.PI ? "rotate(180)" : ""}
      `)
      .attr("text-anchor", d => d.angle > Math.PI ? "end" : null)
      .text(d => names[d.index]);
    
    group.append("title")
      .text(d => `${names[d.index]}
    ${d3.sum(chords, c => (c.source.index === d.index) * c.source.value)} outgoing →
    ${d3.sum(chords, c => (c.target.index === d.index) * c.source.value)} incoming ←`);
    
    svg.append("g")
      .attr("fill-opacity", 0.75)
    .selectAll()
    .data(chords)
    .join("path")
      .style("mix-blend-mode", "multiply")
      .attr("fill", d => colors[d.target.index])
      .attr("d", ribbon)
    .append("title")
      .text(d => `${names[d.source.index]} → ${names[d.target.index]} ${d.source.value}`);
    
    container.append(svg.node());
    
    </script>
    
    </body>
    </html>
    """
    
    return indexFileContents
}

func generateWebFiles() {
    
    #if false
    return overViewModules() // fördelning local, remote_direct, remote_indirect
    #elseif true
    let all = "Total (\(lookupLocalModulesOnDisk.count + lookupRemoteModules.count))"
    
    let allLocal = "\(lookupLocalModulesOnDisk.count) local"

    let remoteDirect = lookupRemoteModules.filter { $0.referencedFromLocalModuleOrProject == true }
    let remoteDirectCount = remoteDirect.count
    let allRemoteDirect = "\(remoteDirectCount) remote (direct)"

    let remoteIndirect = lookupRemoteModules.filter { $0.referencedFromLocalModuleOrProject == false }
    let remoteIndirectCount = remoteIndirect.count
    let allRemoteIndirect = "\(remoteIndirectCount) remote (indirect)"

    var data = "["
    
    data += "{from: \"\(allLocal)\", to: \"\(all)\", weight: \(lookupLocalModulesOnDisk.count)},"
    data += "{from: \"\(allRemoteDirect)\", to: \"\(all)\", weight: \(remoteDirectCount)},"
    data += "{from: \"\(allRemoteIndirect)\", to: \"\(all)\", weight: \(remoteIndirectCount)},"
/*
    lookupLocalModulesOnDisk
        .forEach {
            if let r = $0.moduleName.split(separator: "/").last {
                let moduleName = "\(r)".replacingOccurrences(of: ".", with: "_")
                data += "{from: \"\(moduleName)\", to: \"\(allLocal)\", weight: \($0.localModules.count + $0.remoteModules.count)},"
            } else {
                print("failed!!")
            }
        }
    
    remoteDirect.forEach {
        if let r = $0.moduleName.split(separator: "/").last {
            let moduleName = "\(r)".replacingOccurrences(of: ".", with: "_")
            data += "{from: \"\(moduleName)\", to: \"\(allRemoteDirect)\", weight: \($0.localModules.count + $0.remoteModules.count)},"
        } else {
            print("failed!!")
        }
    }

    remoteIndirect.forEach {
        if let r = $0.moduleName.split(separator: "/").last {
            let moduleName = "\(r)".replacingOccurrences(of: ".", with: "_")
            data += "{from: \"\(moduleName)\", to: \"\(allRemoteIndirect)\", weight: \($0.localModules.count + $0.remoteModules.count)},"
        } else {
            print("failed!!")
        }
    }
*/
    if data.last == "," { data = "\(data.dropLast())" }

    data += "];"
    
    // print("DATA: \(data)")

    let indexFileContents =
    """
    <html>
    <head>
    <script src="https://cdn.anychart.com/releases/v8/js/anychart-core.min.js"></script>
    <script src="https://cdn.anychart.com/releases/v8/js/anychart-sankey.min.js"></script>
    </head>
    <body>
    <div id="container"></div>
    <script>
    anychart.onDocumentReady(function(){
    //creating the data
    var data = \(data)
    //calling the Sankey function
    var sankey_chart = anychart.sankey(data);
    //customizing the width of the nodes
    sankey_chart.nodeWidth("20%");
    //setting the chart title
    sankey_chart.title("Sankey Diagram Customization Example");
    //customizing the vertical padding of the nodes
    sankey_chart.nodePadding(20);
    //customizing the visual appearance of nodes
    sankey_chart.node().normal().fill("#64b5f5 0.6");
    sankey_chart.node().hovered().fill(anychart.color.darken("#64b5f7"));
    sankey_chart.node().normal().stroke("#455a63", 2);
    //customizing the visual appearance of flows
    sankey_chart.flow().normal().fill("#ffa000 0.5");
    sankey_chart.flow().hovered().fill(anychart.color.darken("#ffa000"));
    sankey_chart.flow().hovered().stroke("#455a63");
    //setting the container id
    sankey_chart.container("container");
    //initiating drawing the Sankey diagram
    sankey_chart.draw();
    });
    </script>
    </body>
    </html>
    """
    #elseif true
    
//    let all = "All"
    let all = "All (\(lookupLocalModulesOnDisk.count + lookupRemoteModules.count))"
    let allLocal = "\(lookupLocalModulesOnDisk.count) local"
    let allRemote = "\(lookupRemoteModules.count) remote"

    var data = "["
    
    [lookupLocalModulesOnDisk].forEach { lookup in
        lookup.forEach {
            if let r = $0.moduleName.split(separator: "/").last {
                let moduleName = "\(r)".replacingOccurrences(of: ".", with: "_")
                data += "{from: \"\(moduleName)\", to: \"\(allLocal)\", weight: \($0.localModules.count + $0.remoteModules.count)},"
            } else {
                print("failed!!")
            }
        }
    }

    [lookupRemoteModules].forEach { lookup in
        lookup.forEach {
            if let r = $0.moduleName.split(separator: "/").last {
                let moduleName = "\(r)".replacingOccurrences(of: ".", with: "_")
                data += "{from: \"\(moduleName)\", to: \"\(allRemote)\", weight: \($0.localModules.count + $0.remoteModules.count)},"
            } else {
                print("failed!!")
            }
        }
    }


//    lookupLocalModulesOnDisk.forEach {
//        data += "{from: \"\($0.moduleName)\", to: \"\(all)\", weight: \($0.localModules.count),"
//    }
    
    if data.last == "," { data = "\(data.dropLast())" }
    data += "];"
    
    print("DATA: \(data)")

//    data = """
//    [
//    {from: "Google", to: "Facebook", weight: 20000},
//    {from: "Google", to: "Twitter", weight: 17000},
//    {from: "Google", to: "YouTube", weight: 8000},
//    {from: "Google", to: "Wikipedia", weight: 11000},
//    {from: "Bing", to: "Facebook", weight: 7500},
//    {from: "Bing", to: "Twitter", weight: 5000},
//    {from: "Bing", to: "Wikipedia", weight: 4000}
//    ];
//    """
    
    let indexFileContents =
    """
    <html>
    <head>
    <script src="https://cdn.anychart.com/releases/v8/js/anychart-core.min.js"></script>
    <script src="https://cdn.anychart.com/releases/v8/js/anychart-sankey.min.js"></script>
    </head>
    <body>
    <div id="container"></div>
    <script>
    anychart.onDocumentReady(function(){
    //creating the data
    var data = \(data)
    //calling the Sankey function
    var sankey_chart = anychart.sankey(data);
    //customizing the width of the nodes
    sankey_chart.nodeWidth("20%");
    //setting the chart title
    sankey_chart.title("Sankey Diagram Customization Example");
    //customizing the vertical padding of the nodes
    sankey_chart.nodePadding(20);
    //customizing the visual appearance of nodes
    sankey_chart.node().normal().fill("#64b5f5 0.6");
    sankey_chart.node().hovered().fill(anychart.color.darken("#64b5f7"));
    sankey_chart.node().normal().stroke("#455a63", 2);
    //customizing the visual appearance of flows
    sankey_chart.flow().normal().fill("#ffa000 0.5");
    sankey_chart.flow().hovered().fill(anychart.color.darken("#ffa000"));
    sankey_chart.flow().hovered().stroke("#455a63");
    //setting the container id
    sankey_chart.container("container");
    //initiating drawing the Sankey diagram
    sankey_chart.draw();
    });
    </script>
    </body>
    </html>
    """

    
//    let indexFileContents =
//    """
//    <html>
//    <head>
//    <script src="https://cdn.anychart.com/releases/v8/js/anychart-core.min.js"></script>
//    <script src="https://cdn.anychart.com/releases/v8/js/anychart-sankey.min.js"></script>
//    </head>
//    <body>
//    <div id="container"></div>
//    <script>
//    anychart.onDocumentReady(function(){
//    //creating the data
//    var data = [
//    {from: "Google", to: "Facebook", weight: 20000},
//    {from: "Google", to: "Twitter", weight: 17000},
//    {from: "Google", to: "YouTube", weight: 8000},
//    {from: "Google", to: "Wikipedia", weight: 11000},
//    {from: "Bing", to: "Facebook", weight: 7500},
//    {from: "Bing", to: "Twitter", weight: 5000},
//    {from: "Bing", to: "Wikipedia", weight: 4000}
//    ];
//    //calling the Sankey function
//    var sankey_chart = anychart.sankey(data);
//    //customizing the width of the nodes
//    sankey_chart.nodeWidth("20%");
//    //setting the chart title
//    sankey_chart.title("Sankey Diagram Customization Example");
//    //customizing the vertical padding of the nodes
//    sankey_chart.nodePadding(20);
//    //customizing the visual appearance of nodes
//    sankey_chart.node().normal().fill("#64b5f5 0.6");
//    sankey_chart.node().hovered().fill(anychart.color.darken("#64b5f7"));
//    sankey_chart.node().normal().stroke("#455a63", 2);
//    //customizing the visual appearance of flows
//    sankey_chart.flow().normal().fill("#ffa000 0.5");
//    sankey_chart.flow().hovered().fill(anychart.color.darken("#ffa000"));
//    sankey_chart.flow().hovered().stroke("#455a63");
//    //setting the container id
//    sankey_chart.container("container");
//    //initiating drawing the Sankey diagram
//    sankey_chart.draw();
//    });
//    </script>
//    </body>
//    </html>
//    """
    #else
    let indexFileContents =
    """
    <!DOCTYPE html>
    <html lang="en">
    <body>
    <script src="https://unpkg.com/gojs@2.3.11/release/go.js"></script>
    <p>
    This is a minimalist HTML and JavaScript skeleton of the GoJS Sample
    <a href="https://gojs.net/latest/samples/sankey.html">sankey.html</a>. It was automatically generated from a button on the sample page,
    and does not contain the full HTML. It is intended as a starting point to adapt for your own usage.
    For many samples, you may need to inspect the
    <a href="https://github.com/NorthwoodsSoftware/GoJS/blob/master/samples/sankey.html">full source on Github</a>
    and copy other files or scripts.
    </p>
    <div id="allSampleContent" class="p-4 w-full">
    <script id="code">
    class SankeyLayout extends go.LayeredDigraphLayout {
    constructor() {
      super();
      this.alignOption = go.LayeredDigraphLayout.AlignAll;
    }
    // determine the desired height of each node/vertex,
    // based on the thicknesses of the connected links;
    // actually modify the height of each node's SHAPE
    makeNetwork(coll) {
      var net = super.makeNetwork(coll);
      this.diagram.nodes.each(node => {
        // figure out how tall the node's bar should be
        var height = this.getAutoHeightForNode(node);
        var shape = node.findObject("SHAPE");
        if (shape) shape.height = height;
        var text = node.findObject("TEXT");
        var ltext = node.findObject("LTEXT");
        var font = "bold " + Math.max(12, Math.round(height / 8)) + "pt Segoe UI, sans-serif"
        if (text) text.font = font;
        if (ltext) ltext.font = font;
        // and update the vertex's dimensions accordingly
        var v = net.findVertex(node);
        if (v !== null) {
          node.ensureBounds();
          var r = node.actualBounds;
          v.width = r.width;
          v.height = r.height;
          v.focusY = v.height/2;
        }
      });
      return net;
    }
    
    getAutoHeightForNode(node) {
      var heightIn = 0;
      var it = node.findLinksInto()
      while (it.next()) {
        var link = it.value;
        heightIn += link.computeThickness();
      }
      var heightOut = 0;
      var it = node.findLinksOutOf()
      while (it.next()) {
        var link = it.value;
        heightOut += link.computeThickness();
      }
      var h = Math.max(heightIn, heightOut);
      if (h < 10) h = 10;
      return h;
    }
    
    // treat dummy vertexes as having the thickness of the link that they are in
    nodeMinColumnSpace(v, topleft) {
      if (v.node === null) {
        if (v.edgesCount >= 1) {
          var max = 1;
          var it = v.edges;
          while (it.next()) {
            var edge = it.value;
            if (edge.link != null) {
              var t = edge.link.computeThickness();
              if (t > max) max = t;
              break;
            }
          }
          return Math.max(2, Math.ceil(max / this.columnSpacing));
        }
        return 2;
      }
      return super.nodeMinColumnSpace(v, topleft);
    }
    
    // treat dummy vertexes as being thicker, so that the Bezier curves are gentler
    nodeMinLayerSpace(v, topleft) {
      if (v.node === null) return 100;
      return super.nodeMinLayerSpace(v, topleft);
    }
    
    assignLayers() {
      super.assignLayers();
      var maxlayer = this.maxLayer;
      // now make sure every vertex with no outputs is maxlayer
      for (var it = this.network.vertexes.iterator; it.next();) {
        var v = it.value;
        var node = v.node;
        if (v.destinationVertexes.count == 0) {
          v.layer = 0;
        }
        if (v.sourceVertexes.count == 0) {
          v.layer = maxlayer;
        }
      }
      // from now on, the LayeredDigraphLayout will think that the Node is bigger than it really is
      // (other than the ones that are the widest or tallest in their respective layer).
    }
    
    commitLayout() {
      super.commitLayout();
      for (var it = this.network.edges.iterator; it.next();) {
        var link = it.value.link;
        if (link && link.curve === go.Link.Bezier) {
          // depend on Link.adjusting === go.Link.End to fix up the end points of the links
          // without losing the intermediate points of the route as determined by LayeredDigraphLayout
          link.invalidateRoute();
        }
      }
    }
    }
    // end of SankeyLayout
    
    function init() {
    
      // Since 2.2 you can also author concise templates with method chaining instead of GraphObject.make
      // For details, see https://gojs.net/latest/intro/buildingObjects.html
      const $ = go.GraphObject.make;  // for conciseness in defining templates
    
      myDiagram =
        new go.Diagram("myDiagramDiv", // the ID of the DIV HTML element
          {
            initialAutoScale: go.Diagram.UniformToFill,
            "animationManager.isEnabled": false,
            layout: $(SankeyLayout,
              {
                setsPortSpots: false,  // to allow the "Side" spots on the nodes to take effect
                direction: 0,  // rightwards
                layeringOption: go.LayeredDigraphLayout.LayerOptimalLinkLength,
                packOption: go.LayeredDigraphLayout.PackStraighten || go.LayeredDigraphLayout.PackMedian,
                layerSpacing: 100,  // lots of space between layers, for nicer thick links
                columnSpacing: 1
              })
          });
    
      var colors = ["#AC193D/#BF1E4B", "#2672EC/#2E8DEF", "#8C0095/#A700AE", "#5133AB/#643EBF", "#008299/#00A0B1", "#D24726/#DC572E", "#008A00/#00A600", "#094AB2/#0A5BC4"];
    
      // this function provides a common style for the TextBlocks
      function textStyle() {
        return { font: "bold 12pt Segoe UI, sans-serif", stroke: "black", margin: 5 };
      }
    
      // define the Node template
      myDiagram.nodeTemplate =
        $(go.Node, go.Panel.Horizontal,
          {
            locationObjectName: "SHAPE",
            locationSpot: go.Spot.Left,
            portSpreading: go.Node.SpreadingPacked  // rather than the default go.Node.SpreadingEvenly
          },
          $(go.TextBlock, textStyle(),
            { name: "LTEXT" },
            new go.Binding("text", "ltext")),
          $(go.Shape,
            {
              name: "SHAPE",
              fill: "#2E8DEF",  // default fill color
              strokeWidth: 0,
              portId: "",
              fromSpot: go.Spot.RightSide,
              toSpot: go.Spot.LeftSide,
              height: 10,
              width: 20
            },
            new go.Binding("fill", "color")),
          $(go.TextBlock, textStyle(),
            { name: "TEXT" },
            new go.Binding("text"))
        );
    
      function getAutoLinkColor(data) {
        var nodedata = myDiagram.model.findNodeDataForKey(data.from);
        var hex = nodedata.color;
        if (hex.charAt(0) == '#') {
          var rgb = parseInt(hex.slice(1, 7), 16);
          var r = rgb >> 16;
          var g = rgb >> 8 & 0xFF;
          var b = rgb & 0xFF;
          var alpha = 0.4;
          if (data.width <= 2) alpha = 1;
          var rgba = "rgba(" + r + "," + g + "," + b + ", " + alpha + ")";
          return rgba;
        }
        return "rgba(173, 173, 173, 0.25)";
      }
    
      // define the Link template
      var linkSelectionAdornmentTemplate =
        $(go.Adornment, "Link",
          $(go.Shape,
            { isPanelMain: true, fill: null, stroke: "rgba(0, 0, 255, 0.3)", strokeWidth: 0 })  // use selection object's strokeWidth
        );
    
      myDiagram.linkTemplate =
        $(go.Link, go.Link.Bezier,
          {
            selectionAdornmentTemplate: linkSelectionAdornmentTemplate,
            layerName: "Background",
            fromEndSegmentLength: 150, toEndSegmentLength: 150,
            adjusting: go.Link.End
          },
          $(go.Shape, { strokeWidth: 4, stroke: "rgba(173, 173, 173, 0.25)" },
            new go.Binding("stroke", "", getAutoLinkColor),
            new go.Binding("strokeWidth", "width"))
        );
    
      // read in the JSON-format data from the "mySavedModel" element
      load();
    }
    
    function load() {
      myDiagram.model = go.Model.fromJson(document.getElementById("mySavedModel").value);
    }
    window.addEventListener('DOMContentLoaded', init);
    </script>
    
    <div id="sample">
    <div id="myDiagramDiv" style="border: 1px solid black; width: 99%; height: 850px; position: relative;"><canvas tabindex="0" width="2086" height="1696" style="position: absolute; top: 0px; left: 0px; z-index: 2; touch-action: none; width: 1043px; height: 848px;"></canvas><div style="position: absolute; overflow: auto; width: 1043px; height: 848px; z-index: 1;"><div style="position: absolute; width: 1390.796862px; height: 1px;"></div></div></div>
    <p>
    A Sankey diagram is a type of flow diagram where the Link thickness is proportional to the flow quantity.
    </p>
    <div>
    <textarea id="mySavedModel" style="width:100%;height:250px">{ "class": "go.GraphLinksModel",
    "nodeDataArray": [
    {"key":"Coal reserves", "text":"Coal reserves", "color":"#9d75c2"},
    {"key":"Coal imports", "text":"Coal imports", "color":"#9d75c2"},
    {"key":"Oil reserves", "text":"Oil\nreserves", "color":"#9d75c2"},
    {"key":"Oil imports", "text":"Oil imports", "color":"#9d75c2"},
    {"key":"Gas reserves", "text":"Gas reserves", "color":"#a1e194"},
    {"key":"Gas imports", "text":"Gas imports", "color":"#a1e194"},
    {"key":"UK land based bioenergy", "text":"UK land based bioenergy", "color":"#f6bcd5"},
    {"key":"Marine algae", "text":"Marine algae", "color":"#681313"},
    {"key":"Agricultural 'waste'", "text":"Agricultural 'waste'", "color":"#3483ba"},
    {"key":"Other waste", "text":"Other waste", "color":"#c9b7d8"},
    {"key":"Biomass imports", "text":"Biomass imports", "color":"#fea19f"},
    {"key":"Biofuel imports", "text":"Biofuel imports", "color":"#d93c3c"},
    {"key":"Coal", "text":"Coal", "color":"#9d75c2"},
    {"key":"Oil", "text":"Oil", "color":"#9d75c2"},
    {"key":"Natural gas", "text":"Natural\ngas", "color":"#a6dce6"},
    {"key":"Solar", "text":"Solar", "color":"#c9a59d"},
    {"key":"Solar PV", "text":"Solar PV", "color":"#c9a59d"},
    {"key":"Bio-conversion", "text":"Bio-conversion", "color":"#b5cbe9"},
    {"key":"Solid", "text":"Solid", "color":"#40a840"},
    {"key":"Liquid", "text":"Liquid", "color":"#fe8b25"},
    {"key":"Gas", "text":"Gas", "color":"#a1e194"},
    {"key":"Nuclear", "text":"Nuclear", "color":"#fea19f"},
    {"key":"Thermal generation", "text":"Thermal\ngeneration", "color":"#3483ba"},
    {"key":"CHP", "text":"CHP", "color":"yellow"},
    {"key":"Electricity imports", "text":"Electricity imports", "color":"yellow"},
    {"key":"Wind", "text":"Wind", "color":"#cbcbcb"},
    {"key":"Tidal", "text":"Tidal", "color":"#6f3a5f"},
    {"key":"Wave", "text":"Wave", "color":"#8b8b8b"},
    {"key":"Geothermal", "text":"Geothermal", "color":"#556171"},
    {"key":"Hydro", "text":"Hydro", "color":"#7c3e06"},
    {"key":"Electricity grid", "text":"Electricity grid", "color":"#e483c7"},
    {"key":"H2 conversion", "text":"H2 conversion", "color":"#868686"},
    {"key":"Solar Thermal", "text":"Solar Thermal", "color":"#c9a59d"},
    {"key":"H2", "text":"H2", "color":"#868686"},
    {"key":"Pumped heat", "text":"Pumped heat", "color":"#96665c"},
    {"key":"District heating", "text":"District heating", "color":"#c9b7d8"},
    {"key":"Losses", "ltext":"Losses", "color":"#fec184"},
    {"key":"Over generation / exports", "ltext":"Over generation / exports", "color":"#f6bcd5"},
    {"key":"Heating and cooling - homes", "ltext":"Heating and cooling - homes", "color":"#c7a39b"},
    {"key":"Road transport", "ltext":"Road transport", "color":"#cbcbcb"},
    {"key":"Heating and cooling - commercial", "ltext":"Heating and cooling - commercial", "color":"#c9a59d"},
    {"key":"Industry", "ltext":"Industry", "color":"#96665c"},
    {"key":"Lighting &amp; appliances - homes", "ltext":"Lighting &amp; appliances - homes", "color":"#2dc3d2"},
    {"key":"Lighting &amp; appliances - commercial", "ltext":"Lighting &amp; appliances - commercial", "color":"#2dc3d2"},
    {"key":"Agriculture", "ltext":"Agriculture", "color":"#5c5c10"},
    {"key":"Rail transport", "ltext":"Rail transport", "color":"#6b6b45"},
    {"key":"Domestic aviation", "ltext":"Domestic aviation", "color":"#40a840"},
    {"key":"National navigation", "ltext":"National navigation", "color":"#a1e194"},
    {"key":"International aviation", "ltext":"International aviation", "color":"#fec184"},
    {"key":"International shipping", "ltext":"International shipping", "color":"#fec184"},
    {"key":"Geosequestration", "ltext":"Geosequestration", "color":"#fec184"}
    ], "linkDataArray": [
    {"from":"Coal reserves", "to":"Coal", "width":31},
    {"from":"Coal imports", "to":"Coal", "width":86},
    {"from":"Oil reserves", "to":"Oil", "width":244},
    {"from":"Oil imports", "to":"Oil", "width":1},
    {"from":"Gas reserves", "to":"Natural gas", "width":182},
    {"from":"Gas imports", "to":"Natural gas", "width":61},
    {"from":"UK land based bioenergy", "to":"Bio-conversion", "width":1},
    {"from":"Marine algae", "to":"Bio-conversion", "width":1},
    {"from":"Agricultural 'waste'", "to":"Bio-conversion", "width":1},
    {"from":"Other waste", "to":"Bio-conversion", "width":8},
    {"from":"Other waste", "to":"Solid", "width":1},
    {"from":"Biomass imports", "to":"Solid", "width":1},
    {"from":"Biofuel imports", "to":"Liquid", "width":1},
    {"from":"Coal", "to":"Solid", "width":117},
    {"from":"Oil", "to":"Liquid", "width":244},
    {"from":"Natural gas", "to":"Gas", "width":244},
    {"from":"Solar", "to":"Solar PV", "width":1},
    {"from":"Solar PV", "to":"Electricity grid", "width":1},
    {"from":"Solar", "to":"Solar Thermal", "width":1},
    {"from":"Bio-conversion", "to":"Solid", "width":3},
    {"from":"Bio-conversion", "to":"Liquid", "width":1},
    {"from":"Bio-conversion", "to":"Gas", "width":5},
    {"from":"Bio-conversion", "to":"Losses", "width":1},
    {"from":"Solid", "to":"Over generation / exports", "width":1},
    {"from":"Liquid", "to":"Over generation / exports", "width":18},
    {"from":"Gas", "to":"Over generation / exports", "width":1},
    {"from":"Solid", "to":"Thermal generation", "width":106},
    {"from":"Liquid", "to":"Thermal generation", "width":2},
    {"from":"Gas", "to":"Thermal generation", "width":87},
    {"from":"Nuclear", "to":"Thermal generation", "width":41},
    {"from":"Thermal generation", "to":"District heating", "width":2},
    {"from":"Thermal generation", "to":"Electricity grid", "width":92},
    {"from":"Thermal generation", "to":"Losses", "width":142},
    {"from":"Solid", "to":"CHP", "width":1},
    {"from":"Liquid", "to":"CHP", "width":1},
    {"from":"Gas", "to":"CHP", "width":1},
    {"from":"CHP", "to":"Electricity grid", "width":1},
    {"from":"CHP", "to":"Losses", "width":1},
    {"from":"Electricity imports", "to":"Electricity grid", "width":1},
    {"from":"Wind", "to":"Electricity grid", "width":1},
    {"from":"Tidal", "to":"Electricity grid", "width":1},
    {"from":"Wave", "to":"Electricity grid", "width":1},
    {"from":"Geothermal", "to":"Electricity grid", "width":1},
    {"from":"Hydro", "to":"Electricity grid", "width":1},
    {"from":"Electricity grid", "to":"H2 conversion", "width":1},
    {"from":"Electricity grid", "to":"Over generation / exports", "width":1},
    {"from":"Electricity grid", "to":"Losses", "width":6},
    {"from":"Gas", "to":"H2 conversion", "width":1},
    {"from":"H2 conversion", "to":"H2", "width":1},
    {"from":"H2 conversion", "to":"Losses", "width":1},
    {"from":"Solar Thermal", "to":"Heating and cooling - homes", "width":1},
    {"from":"H2", "to":"Road transport", "width":1},
    {"from":"Pumped heat", "to":"Heating and cooling - homes", "width":1},
    {"from":"Pumped heat", "to":"Heating and cooling - commercial", "width":1},
    {"from":"CHP", "to":"Heating and cooling - homes", "width":1},
    {"from":"CHP", "to":"Heating and cooling - commercial", "width":1},
    {"from":"District heating", "to":"Heating and cooling - homes", "width":1},
    {"from":"District heating", "to":"Heating and cooling - commercial", "width":1},
    {"from":"District heating", "to":"Industry", "width":2},
    {"from":"Electricity grid", "to":"Heating and cooling - homes", "width":7},
    {"from":"Solid", "to":"Heating and cooling - homes", "width":3},
    {"from":"Liquid", "to":"Heating and cooling - homes", "width":3},
    {"from":"Gas", "to":"Heating and cooling - homes", "width":81},
    {"from":"Electricity grid", "to":"Heating and cooling - commercial", "width":7},
    {"from":"Solid", "to":"Heating and cooling - commercial", "width":1},
    {"from":"Liquid", "to":"Heating and cooling - commercial", "width":2},
    {"from":"Gas", "to":"Heating and cooling - commercial", "width":19},
    {"from":"Electricity grid", "to":"Lighting &amp; appliances - homes", "width":21},
    {"from":"Gas", "to":"Lighting &amp; appliances - homes", "width":2},
    {"from":"Electricity grid", "to":"Lighting &amp; appliances - commercial", "width":18},
    {"from":"Gas", "to":"Lighting &amp; appliances - commercial", "width":2},
    {"from":"Electricity grid", "to":"Industry", "width":30},
    {"from":"Solid", "to":"Industry", "width":13},
    {"from":"Liquid", "to":"Industry", "width":34},
    {"from":"Gas", "to":"Industry", "width":54},
    {"from":"Electricity grid", "to":"Agriculture", "width":1},
    {"from":"Solid", "to":"Agriculture", "width":1},
    {"from":"Liquid", "to":"Agriculture", "width":1},
    {"from":"Gas", "to":"Agriculture", "width":1},
    {"from":"Electricity grid", "to":"Road transport", "width":1},
    {"from":"Liquid", "to":"Road transport", "width":122},
    {"from":"Electricity grid", "to":"Rail transport", "width":2},
    {"from":"Liquid", "to":"Rail transport", "width":1},
    {"from":"Liquid", "to":"Domestic aviation", "width":2},
    {"from":"Liquid", "to":"National navigation", "width":4},
    {"from":"Liquid", "to":"International aviation", "width":38},
    {"from":"Liquid", "to":"International shipping", "width":13},
    {"from":"Electricity grid", "to":"Geosequestration", "width":1},
    {"from":"Gas", "to":"Losses", "width":2}
    ]}
    </textarea>
    </div>
    </div>
    </div>
    </body>
    </html>
    """
    #endif
    
    print("INDEXFILECONTENT: \(indexFileContents)")

    
    let file = "index.html"
    
    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let fileURL = dir.appendingPathComponent(file)
        do {
            try indexFileContents.write(to: fileURL, atomically: false, encoding: .utf8)
        } catch {
            print(error)
        }
    }
}
