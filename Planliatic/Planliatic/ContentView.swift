//
//  ContentView.swift
//  Planliatic
//
//  Created by Ali Erdem Kökcik on 27.09.2022.
//

import SwiftUI

enum Priority: String, Identifiable, CaseIterable{
    var id: UUID{
        return UUID()
    }
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

extension Priority{
    var title: String{
        switch self{
        case .low:
            return "Low"
        case .medium:
            return "Medium"
        case .high:
            return "High"
        }
    }
}

struct ContentView: View {
    
    @State private var title: String = ""
    @State private var selectedPriority: Priority = .medium
    @State private var showingAlert = false
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(key: "dateCreated", ascending: false)]) private
    var allTasks: FetchedResults<Task>
    
    private func saveTask(){
        do {
            let task = Task(context: viewContext)
            task.title = title
            task.priority = selectedPriority.rawValue
            task.dateCreated = Date()
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func styleForPriority(_ value: String) -> Color{
        let priority = Priority(rawValue: value)
        
        switch priority{
        case .low:
            return Color.green
        case .medium:
            return Color.orange
        case .high:
            return Color.red
        default:
            return Color.black
        }
    }
    
    private func updateTask(_ task: Task){
        task.isFavorite = !task.isFavorite
        
        do{
            try viewContext.save()
        } catch{
            print(error.localizedDescription)
        }
    }
    
    private func deleteTask(at offset: IndexSet){
        offset.forEach { index in
            let task = allTasks[index]
            viewContext.delete(task)
            
            do{
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
        showingAlert = true
    }
    
    var body: some View {
        NavigationView{
            VStack{
                TextField("Enter the task", text: $title)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(.roundedBorder)
                    .cornerRadius(5)
                Picker("Priority", selection: $selectedPriority){
                    ForEach(Priority.allCases){priority in
                        Text(priority.title).tag(priority)
                    }
                }.pickerStyle(.segmented)
                
                Button("Save"){
                    saveTask()
                }
                .padding(10)
                .shadow(radius: 40.0)
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 30.0, style: .continuous))
                
                List{
                    ForEach(allTasks){ task in
                        HStack {
                            Circle()
                                .fill(styleForPriority(task.priority!))
                                .frame(width: 12, height: 12)
                            Spacer().frame(width: 20)
                            Text(task.title ?? "")
                            Spacer()
                            Image(systemName: task.isFavorite ? "star.fill": "star")
                                .foregroundColor(.black)
                                .onTapGesture {
                                    updateTask(task)
                                }
                        }
                    }.onDelete(perform: deleteTask)
                        .alert("Important Message", isPresented: $showingAlert){
                            Button("Delete", role: .destructive) { }
                            Button("Cancel", role: .cancel) { }
                        } message: {
                            Text("Are you sure you want to delete the task?")
                        }
                }
                
                
                Spacer()
            }
                    .padding()
                    .navigationTitle("All Tasks")
            }
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            let persistenContainer = CoreDataManager.shared.persistentContainer
                ContentView().environment(\.managedObjectContext, persistenContainer.viewContext)
        }
}
