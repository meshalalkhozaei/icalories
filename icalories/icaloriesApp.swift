//
//  icaloriesApp.swift
//  icalories
//
//  Created by meshal alkhozaei on 18/09/1445 AH.
//

import SwiftUI

@main
struct icaloriesApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
