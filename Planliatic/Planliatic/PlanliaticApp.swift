//
//  PlanliaticApp.swift
//  Planliatic
//
//  Created by Ali Erdem Kökcik on 27.09.2022.
//

import SwiftUI

@main
struct PlanliaticApp: App {
    
    let persistenContainer = CoreDataManager.shared.persistentContainer
    
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, persistenContainer.viewContext)
        }
    }
}
