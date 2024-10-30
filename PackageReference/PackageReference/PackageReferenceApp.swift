//
//  PackageReferenceApp.swift
//  PackageReference
//
//  Created by Mark Dubouzet on 10/30/24.
//

import SwiftUI

@main
struct PackageReferenceApp: App {
    @StateObject var uSet = AltSettings()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(uSet)
        }
    }
}

class MySingleton: ObservableObject {
    static let shared = MySingleton()
    
    @Published var myVar:String = ""
    
    private init() {
        print("MySingleton initialized")
    }
}
