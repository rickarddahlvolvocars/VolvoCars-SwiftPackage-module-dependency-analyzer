/*
    Module graph generation
    
 // TODO: Migreara till SPM som man kan köra på projektet
 // TODO: flytta in storybook och demo-projekten i workspacet så det också inkluderas?
 */

import Foundation
import Cocoa
import RegexBuilder

print("""
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Volvo Cars iOS app dependency graph generator
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
""")

let insetMarker = "⎬⎯"

class Module: Hashable, Equatable, Comparable {
    static func < (lhs: Module, rhs: Module) -> Bool { lhs.moduleName < rhs.moduleName }
    
    let moduleName: String
    var localModules: Set<Module> = Set()
    var remoteModules: Set<Module> = Set()
    
    var referencedFromLocalModuleOrProject: Bool = false // Is this module referenced from any local module?
    
    init(moduleName: String) {
        self.moduleName = moduleName
    }
    
    static func == (lhs: Module, rhs: Module) -> Bool {
        lhs.moduleName == rhs.moduleName &&
        lhs.referencedFromLocalModuleOrProject == rhs.referencedFromLocalModuleOrProject &&
        lhs.localModules.count == rhs.localModules.count &&
        lhs.remoteModules.count == rhs.remoteModules.count
    }
    
    func hash(into hasher: inout Hasher) { hasher.combine(moduleName) }
    
    static func localModuleWithName(name: String) -> Module? {
        let module = lookupLocalModulesOnDisk.first { $0.moduleName == name }
        guard let module else {
            print("⚠️ Failed to find local module '\(name)' on disk")
            return nil
        }
        return module
    }
    
    static func remoteModuleWithName(name: String) -> Module? {
        let module = lookupRemoteModules.first { $0.moduleName == name }
        guard let module else {
            print("⚠️ Failed to find remote module '\(name)' on disk")
            return nil
        }
        return module
    }
}

//class Target: Hashable, Equatable {
//    let targetName: String = ""
//    var localModules: Set<Module> = Set()
//    var remoteModules: Set<Module> = Set()
//
//    static func == (lhs: Target, rhs: Target) -> Bool { lhs.targetName == rhs.targetName }
//
//    func hash(into hasher: inout Hasher) { hasher.combine(targetName) }
//}

class Project: Hashable, Equatable {
    let projectName: String
    //var targets: [Target] = []

    init(projectName: String) {
        self.projectName = projectName
    }
    
    static func == (lhs: Project, rhs: Project) -> Bool { lhs.projectName == rhs.projectName }
    
    func hash(into hasher: inout Hasher) { hasher.combine(projectName) }
}


// MARK: - Data storage
var lookupLocalModulesOnDisk: Set<Module> = [] // All modules on disk, some potentially without any relations -- This is where to search among ALL local modules
var lookupRemoteModules: Set<Module> = [] // Init first! and use for lookup

var localModulesReferencedByWorkspace: Set<Module> = []
//var targets: Set<Target> = []
var projects: Set<Project> = []


// MARK: - Path constants
let baseDir = "~/Developer/Repos/volvo-cars-ios" // Volvo Cars iOS app root folder
let workspaceDataFilePath = NSString(string: "\(baseDir)/VolvoCars/VolvoCars.xcworkspace/contents.xcworkspacedata").expandingTildeInPath
let packageResolvedFilePath = NSString(string: "\(baseDir)/VolvoCars/VolvoCars.xcworkspace/xcshareddata/swiftpm/Package.resolved").expandingTildeInPath


/*
 IMPORTANT! Remote modules must be fetched first so that we create module instances. These are used for lookup so that we don't have duplicates of modules!
 */
// MARK: - Remote modules in Package.resolved
func getRemoteModulesInPackageResolved() {
    do {
        let packageResolvedFileContent = try String(contentsOfFile: packageResolvedFilePath)
        // print("•• " + packageResolvedFileContent)

        packageResolvedFileContent
            .split(separator: "\"location\" : \"")
            .dropFirst()
            .forEach {
                // print("••• '\($0)' ->")
                if let m = $0.split(separator: "\",").first {
                    //print("••• \t'\(m)'")
                    lookupRemoteModules.insert(Module(moduleName: "\(m)"))
                }
            }
    } catch {
        print(error)
    }
}
getRemoteModulesInPackageResolved()


/*
    IMPORTANT! Local modules on disk must be run first so that we create module instances. These are used for lookup so that we don't have duplicates of modules!
 */
// MARK: - Local modules on disk
func getAllLocalModulesOnDisk() {
    let localModulesPath = NSString(string: "\(baseDir)/VolvoCars/SwiftPackages").expandingTildeInPath
    
    func contentsOfDirectoryAtPath(path: String) -> [String]? {
        guard let paths = try? FileManager.default.contentsOfDirectory(atPath: path) else { return nil }
        return paths.map { aContent in (path as NSString).appendingPathComponent(aContent)}
    }
    
    if let allContents: [String] = contentsOfDirectoryAtPath(path: localModulesPath) {
        allContents
            .forEach {
                let x = "\($0.trimmingPrefix(localModulesPath + "/"))"
                if x.first != "." {
                    lookupLocalModulesOnDisk.insert(Module(moduleName: x))
                }
            }
    }
}
getAllLocalModulesOnDisk()



// MARK: - Projects and local modules in workspace
func getAllProjectsAndModulesInWorkspace() {
    do {
        let workspacefileContent = try String(contentsOfFile: workspaceDataFilePath)
        // print(workspacefileContent)

        let parts = workspacefileContent
            .split(separator: "<Group")

        let pPart = "\(parts.first ?? "")" // Data before modules data (which is after '<Group'
        let mPart = "\(parts.last ?? "")" // First is the above projects. Second part is the local modules definition
        
        // MARK: - Projects in workspace
        pPart
            .split(separator: "group:") // strings ending with "group:"
            .dropFirst() // First one is garbage
            .filter { !$0.contains { "Pods" } } // Exclude the Prod project
            .compactMap { $0.split(separator: ".xcodeproj").first }
            .forEach { projects.insert(Project(projectName: "\($0).xcodeproj")) }
        
        // MARK: - Modules referenced in workspace
        mPart
            .split(separator: "group:") // strings ending with "group:"
            .dropFirst()
            .dropFirst()
            .forEach {
                $0
                    .split(separator: "\">")
                    .filter { !$0.contains( "</FileRef") && $0.first != "." }
                    .forEach {
                        // print("---> \($0)")
                        if let localModuleOnDisk = Module.localModuleWithName(name: "\($0)") {
                            localModuleOnDisk.referencedFromLocalModuleOrProject = true // TODO: kanske kan separera om ref from app eller moduler??
                            localModulesReferencedByWorkspace.insert(localModuleOnDisk)
                        }
                    }
                }
    } catch {
        print(error)
    }
}
getAllProjectsAndModulesInWorkspace()


// MARK: - Projects and local modules in workspace
func parseProject(project: Project) {
    do {
        let workspaceDataFilePath = NSString(string: "\(baseDir)/VolvoCars/\(project.projectName)/project.pbxproj").expandingTildeInPath
        let workspacefileContent = try String(contentsOfFile: workspaceDataFilePath)
        // print(workspacefileContent)
        
        // Local
        workspacefileContent
            .split(separator: "isa = XCSwiftPackageProductDependency;")
            .dropFirst()
            .forEach {
                // print("==> '" + $0 + "'")
                
                if $0.contains("XCRemoteSwiftPackageReference") {
                    // print("IGNORING \($0)")
                    return
                }
                
                if let s = "\($0)"
                    .split(separator: "productName = ")
                    .dropFirst()
                    .first {
                        let ss = "\(s)"
                        //print("==> s: '\(ss)'")
                        if let r = ss.firstRange(of: ";") {
                            let xx = ss.prefix(upTo: r.lowerBound)
                            let moduleName = "\(xx)"
                            // print(moduleName)
                            if let m = Module.localModuleWithName(name: moduleName) {
                                m.referencedFromLocalModuleOrProject = true
                                lookupLocalModulesOnDisk.insert(m)
                            } else {
                                // print("Ignoring \(moduleName) since no local module with this name exist... it is probably a sub product of some module...")
                            }
                        }
                    }
            }

        // Remote
        workspacefileContent
            .split(separator: "repositoryURL = \"")
            .dropFirst()
            .forEach {
                //print($0)
                if let r = $0.firstRange(of: "\";") {
                    let xx = $0.prefix(upTo: r.lowerBound)
                    //print(xx)
                    let moduleName = "\(xx)"
                    let m = Module.remoteModuleWithName(name: moduleName) ?? Module(moduleName: moduleName)
                    m.referencedFromLocalModuleOrProject = true
                    lookupRemoteModules.insert(m)
                }
            }
    } catch {
        print(error)
    }
}
projects.forEach {
    // print(">### \($0.projectName)")
    parseProject(project: $0)
    // print("<### \($0.projectName)")
}


// MARK: - Populate all local modules internal module dependencies (local and remote)
func updateAllModulesWithModuleDependencies() {
    lookupLocalModulesOnDisk.forEach { localModuleToUpdate in
        let modulesPackageSwiftFilePath = NSString(string: "\(baseDir)/VolvoCars/SwiftPackages/\(localModuleToUpdate.moduleName)/Package.swift").expandingTildeInPath
            do {
            let fileContent = try String(contentsOfFile: modulesPackageSwiftFilePath)
                #if false
                print("Contents of \(modulesPackageSwiftFilePath):")
                print(fileContent)
                #endif

            // Local module dependencies
            fileContent
                .split(separator: ".package(path: \"../")
                .dropFirst()
                .forEach { // Add each module dependency to localModuleToUpdate.modules
                    if let dependencyModuleName = $0.split(separator: "\")").first {
                        //print("Dependency module: " + dependencyModuleName)

                        if let dependencyModule = Module.localModuleWithName(name: "\(dependencyModuleName)") {
                            //print("Found m: \(dependencyModule.moduleName) | \(dependencyModule.modules)")
                            dependencyModule.referencedFromLocalModuleOrProject = true
                            localModuleToUpdate.localModules.insert(dependencyModule)
                        }
                    }
                }

            // Remote module dependencies
            fileContent
                .split(separator: ".package(url: \"")
                .dropFirst()
                .forEach { // Add each module dependency to localModuleToUpdate.modules
                    if let dependencyModuleName = $0.split(separator: "\",").first {
                        //print("Dependency module: " + dependencyModuleName)
                        
                        if let dependencyModule = Module.remoteModuleWithName(name: "\(dependencyModuleName)") {
                            //print("Found m: \(dependencyModule.moduleName) | \(dependencyModule.modules)")
                            dependencyModule.referencedFromLocalModuleOrProject = true
                            localModuleToUpdate.remoteModules.insert(dependencyModule)
                        }
                    }
                }
        } catch {
            print(error)
        }
    }
}
updateAllModulesWithModuleDependencies()


// MARK: - Print the results

print("\n==================================================[\(projects.count) projects in workspace]")
projects.forEach {
    print("\(insetMarker)" + $0.projectName)
}

print("\n================================================== [\(localModulesReferencedByWorkspace.count) modules referenced by workspace]")
localModulesReferencedByWorkspace.forEach {
    print("[" + $0.moduleName + "]")
    if !$0.localModules.isEmpty {
        print("\tLocal:")
        _ = $0.localModules.map {
            print("\t\t\(insetMarker)" + $0.moduleName)
        }
    }
    if !$0.remoteModules.isEmpty {
        print("\tRemote:")
        _ = $0.remoteModules.map {
            print("\t\t\(insetMarker)" + $0.moduleName)
        }
    }
}

//print("\n================================================== [ Targets | \(targets.count) targets]")
//targets.forEach {
//    print($0.targetName)
//}


print("\n================================================== [\(lookupRemoteModules.count) remote modules]")
lookupRemoteModules
    .sorted(by: >)
    .filter { $0.referencedFromLocalModuleOrProject == true }
    .forEach {
        print("\t\(insetMarker)" + $0.moduleName)
    }

print("Indirect references (not referenced from any local module or project, but from some of the remote modules):")
lookupRemoteModules
    .filter { $0.referencedFromLocalModuleOrProject == false }
    .sorted(by: <)
    .forEach {
        print("\t\(insetMarker)" + $0.moduleName)
    }

print("\n================================================== [\(lookupLocalModulesOnDisk.count) local modules (all in local repo)]")
lookupLocalModulesOnDisk
    .sorted(by: >)
    .filter { $0.referencedFromLocalModuleOrProject == true }
    .forEach {
        print("\t\(insetMarker)" + $0.moduleName)
    }

print("Not referenced by any module:")
lookupLocalModulesOnDisk
    .filter { $0.referencedFromLocalModuleOrProject == false }
    .sorted(by: <)
    .forEach {
        print("\t\(insetMarker)" + $0.moduleName)
    }


// MARK: - File management

func writeFile(content: String, name: String) {
    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let fileURL = dir.appendingPathComponent(name)
        do {
            try content.write(to: fileURL, atomically: false, encoding: .utf8)
        } catch {
            print(error)
        }
    }
}

func openFile(file: String) {
    // MARK: - Open the file in a browser
    let urlStr = NSString(string: "~/Documents/\(file)").expandingTildeInPath
    if let url = URL(string: "file://" + urlStr) {
        print("Opening '\(urlStr)'")
        NSWorkspace.shared.open(url)
        return
    }
    print("Failed to open '\(file)")
}

// MARK: - Generate and open files
print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")

let overview_content = genOverview()
let overview_fileName = "index-overview.html"
writeFile(content: overview_content, name: overview_fileName)
openFile(file: overview_fileName)

let sunburst_content = genD3Sunburst()
let sunburst_fileName = "index-sunburst.html"
writeFile(content: sunburst_content, name: sunburst_fileName)
openFile(file: sunburst_fileName)

let sunburst2_content = genD3Sunburst_loc_rem()
let sunburst2_fileName = "index-sunburst-loc+rem.html"
writeFile(content: sunburst2_content, name: sunburst2_fileName)
openFile(file: sunburst2_fileName)

