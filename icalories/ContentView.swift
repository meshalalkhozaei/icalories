import SwiftUI
import CoreData

enum SortingType: String, CaseIterable {
    case old
    case new
    case completed
    var title : String {
        switch self {
        case .new:
            return "due Date"
        case .old:
            return "newest Task"
        case .completed:
            return "is Completed"
        }
    }
}


struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.dueDate, order: .reverse)]) var food: FetchedResults<Food>
    @State private var showingAddView = false
    @State private var sortingType: SortingType = .new // Default sorting
    
    var sortedFood: [Food] {
        switch sortingType {
        case .old:
            return food.sorted { $0.dueDate! > $1.dueDate! }
        case .new:
            return food.sorted { $0.dueDate! < $1.dueDate! }
        case .completed:
            let sortedFood = food.sorted { food1, food2 in
                if food1.isDone == food2.isDone {
                    return food1.dueDate! < food2.dueDate!
                } else {
                    return food1.isDone && !food2.isDone
                }
            }
            return sortedFood.filter { $0.isDone }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                List {
                    ForEach(sortedFood) { food in
                        HStack {
                            Button(action: {
                                toggleCompletion(food)
                            }) {
                                Image(systemName: food.isDone ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(food.isDone ? .green : .gray)
                                    .padding(.trailing, 5)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text(food.name ?? "")
                                    .bold()
                                    .foregroundColor(food.isDone ? .gray : .primary)
                                Text(food.desc ?? "") // Display description
                                    .foregroundColor(.gray)
                                Text("Due: \(formattedDate(food.dueDate ?? Date()))")
                                    .foregroundColor(.gray)
                                Text("Time: \(formattedTime(food.dueDate ?? Date()))")
                                    .foregroundColor(.gray)
                            }
                            
                            NavigationLink(destination: EditFoodView(food: food)) {
                                EmptyView()
                            }
                        }
                    }
                    .onDelete(perform: deleteFood)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color("PrimaryColor"))
            }
            .navigationTitle("Todos")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddView.toggle()
                    } label: {
                        Label("Add Todo", systemImage: "plus.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    
                    Menu {
                        ForEach(SortingType.allCases, id: \.self) { type in
                            Button(type.title) {
                                sortingType = type
                            }
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease")
                    }
                    
                }
            }
            .sheet(isPresented: $showingAddView) {
                AddFoodView()
            }
        }
        .navigationViewStyle(.stack) // Removes sidebar on iPad
        // Set color scheme to dark mode
    }
    
    private func deleteFood(offsets: IndexSet) {
        withAnimation {
            offsets.map { food[$0] }
                .forEach(managedObjContext.delete)
            DataController().save(context: managedObjContext)
        }
    }
    
    private func toggleCompletion(_ food: Food) {
        food.isDone.toggle()
        DataController().save(context: managedObjContext)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
    
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
